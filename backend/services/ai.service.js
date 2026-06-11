// Uses OpenRouter (OpenAI-compatible API) to access Claude models.
// No Anthropic SDK needed — just a standard fetch to OpenRouter's endpoint.

const OPENROUTER_API_KEY = (process.env.OPENROUTER_API_KEY || '').trim();
console.log('[AI-SVC] OpenRouter API key loaded:', OPENROUTER_API_KEY ? `${OPENROUTER_API_KEY.substring(0, 12)}...` : 'MISSING');

const OPENROUTER_URL = 'https://openrouter.ai/api/v1/chat/completions';

const SYSTEM_PROMPT = `You are MindMate — a warm, emotionally present companion for Indian college students, not a therapist and not a scripted chatbot.

For every message, respond with ONLY a valid JSON object (no markdown, no extra text) in this exact format:
{
  "detected_emotion": "<one of: anxious, sad, angry, lonely, overwhelmed, hopeful, neutral, stressed, content>",
  "emotion_confidence": "<low|medium|high>",
  "response": "<your reply>",
  "risk_flag": <true only if the message contains hopelessness, self-harm ideation, or 'giving up' language — otherwise false>
}

For the 'response' field:
- Sound like a perceptive friend, not a script. Vary structure — sometimes just validate, sometimes ask a gentle follow-up, sometimes share a small relatable thought. Don't ask a question after every message.
- Read the conversation history — respond like a continuing dialogue, not isolated Q&A.
- Be culturally aware: exam pressure, placements, family expectations, hostel loneliness, comparison culture in Indian colleges.
- Keep it conversational length — 1 to 4 sentences typically.
- Never diagnose. If risk_flag is true, weave in (naturally, not alarmingly) that talking to someone they trust or a helpline could help.`;

async function getChatResponse(history, currentMessage, retryCount = 0) {
  console.log('[AI-SVC] getChatResponse called — retryCount:', retryCount);
  console.log('[AI-SVC] History length:', history.length, '| Current message:', currentMessage?.substring(0, 80));

  try {
    // Build OpenAI-compatible messages array
    const messages = [
      { role: 'system', content: SYSTEM_PROMPT }
    ];

    // Add conversation history
    for (const msg of history) {
      messages.push({
        role: msg.role,
        content: msg.message
      });
    }

    // Add current user message
    messages.push({
      role: 'user',
      content: currentMessage
    });

    console.log('[AI-SVC] Sending to OpenRouter — messages count:', messages.length);
    console.log('[AI-SVC] Messages preview:', JSON.stringify(messages.slice(-2)).substring(0, 500));

    const response = await fetch(OPENROUTER_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENROUTER_API_KEY}`,
        'HTTP-Referer': 'https://mindmate-app.com',
        'X-Title': 'MindMate',
      },
      body: JSON.stringify({
        model: 'anthropic/claude-sonnet-4',
        messages: messages,
        max_tokens: 1024,
        temperature: 0.7,
      }),
    });

    console.log('[AI-SVC] OpenRouter HTTP status:', response.status);

    if (!response.ok) {
      const errorBody = await response.text();
      console.error('[AI-SVC] ❌ OpenRouter error response:', errorBody);
      throw new Error(`OpenRouter returned ${response.status}: ${errorBody}`);
    }

    const data = await response.json();
    console.log('[AI-SVC] ✅ OpenRouter response received');

    const textOutput = data.choices?.[0]?.message?.content;
    console.log('[AI-SVC] Raw text output:', textOutput?.substring(0, 500));

    if (!textOutput) {
      console.error('[AI-SVC] ❌ No content in response:', JSON.stringify(data).substring(0, 500));
      throw new Error('Empty response from OpenRouter');
    }

    try {
      // Sometimes the model wraps JSON in markdown code blocks
      const cleanedText = textOutput.replace(/```json/g, '').replace(/```/g, '').trim();
      console.log('[AI-SVC] Cleaned text:', cleanedText?.substring(0, 500));

      const jsonResponse = JSON.parse(cleanedText);
      console.log('[AI-SVC] ✅ JSON parsed successfully');
      console.log('[AI-SVC] Parsed keys:', Object.keys(jsonResponse));

      // Basic validation
      if (!jsonResponse.response || !jsonResponse.detected_emotion) {
        console.error('[AI-SVC] ❌ Invalid JSON structure — missing response or detected_emotion');
        throw new Error('Invalid JSON structure returned from model');
      }

      console.log('[AI-SVC] ✅ Returning valid response — emotion:', jsonResponse.detected_emotion, '| risk:', jsonResponse.risk_flag);
      return jsonResponse;
    } catch (parseError) {
      console.error('[AI-SVC] ❌ JSON parse error:', parseError.message);
      console.error('[AI-SVC] Raw text that failed to parse:', textOutput);
      if (retryCount < 1) {
        console.log('[AI-SVC] Retrying API call (attempt 2)...');
        return getChatResponse(history, currentMessage, retryCount + 1);
      }
      console.error('[AI-SVC] ❌ Parse failure after retry — returning fallback');
      throw new Error('Parse failure after retry');
    }

  } catch (error) {
    console.error('[AI-SVC] ❌ API Error:', error.message);
    console.error('[AI-SVC] Error type:', error.constructor?.name);
    // Fallback response
    return {
      response: "I'm here, but having a little trouble right now — can you try sending that again?",
      detected_emotion: "neutral",
      emotion_confidence: "low",
      risk_flag: false,
      show_escalation: false
    };
  }
}

module.exports = {
  getChatResponse
};
