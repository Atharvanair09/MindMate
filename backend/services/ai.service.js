const Anthropic = require('@anthropic-ai/sdk');

const apiKey = process.env.ANTHROPIC_API_KEY?.trim() || 'dummy_key';
console.log('[AI-SVC] Anthropic API key loaded:', apiKey ? `${apiKey.substring(0, 12)}...` : 'MISSING');

const anthropic = new Anthropic({
  apiKey: apiKey,
});

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
    // Format messages for Claude
    const messages = [];
    
    for (const msg of history) {
      messages.push({
        role: msg.role,
        content: msg.message
      });
    }

    messages.push({
      role: 'user',
      content: currentMessage
    });

    console.log('[AI-SVC] Sending to Claude — messages count:', messages.length);
    console.log('[AI-SVC] Messages array:', JSON.stringify(messages).substring(0, 500));

    const response = await anthropic.messages.create({
      model: "claude-3-5-sonnet-20241022",
      max_tokens: 1024,
      system: SYSTEM_PROMPT,
      messages: messages,
      temperature: 0.7,
    });

    console.log('[AI-SVC] ✅ Claude raw response received');
    console.log('[AI-SVC] Response stop_reason:', response.stop_reason);
    console.log('[AI-SVC] Response content type:', response.content?.[0]?.type);

    const textOutput = response.content[0].text;
    console.log('[AI-SVC] Raw text output:', textOutput?.substring(0, 500));

    try {
      // Sometimes Claude wraps JSON in markdown block even when told not to
      const cleanedText = textOutput.replace(/```json/g, '').replace(/```/g, '').trim();
      console.log('[AI-SVC] Cleaned text:', cleanedText?.substring(0, 500));

      const jsonResponse = JSON.parse(cleanedText);
      console.log('[AI-SVC] ✅ JSON parsed successfully');
      console.log('[AI-SVC] Parsed keys:', Object.keys(jsonResponse));
      
      // Basic validation
      if (!jsonResponse.response || !jsonResponse.detected_emotion) {
        console.error('[AI-SVC] ❌ Invalid JSON structure — missing response or detected_emotion');
        throw new Error('Invalid JSON structure returned from Claude');
      }
      
      console.log('[AI-SVC] ✅ Returning valid response — emotion:', jsonResponse.detected_emotion, '| risk:', jsonResponse.risk_flag);
      return jsonResponse;
    } catch (parseError) {
      console.error('[AI-SVC] ❌ JSON parse error:', parseError.message);
      console.error('[AI-SVC] Raw text that failed to parse:', textOutput);
      if (retryCount < 1) {
        console.log('[AI-SVC] Retrying Claude API call (attempt 2)...');
        return getChatResponse(history, currentMessage, retryCount + 1);
      }
      console.error('[AI-SVC] ❌ Parse failure after retry — returning fallback');
      throw new Error('Parse failure after retry');
    }

  } catch (error) {
    console.error('[AI-SVC] ❌ Claude API Error:', error.message);
    console.error('[AI-SVC] Error type:', error.constructor?.name);
    console.error('[AI-SVC] Full error:', error);
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
