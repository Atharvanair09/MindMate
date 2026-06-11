const Anthropic = require('@anthropic-ai/sdk');

const anthropic = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY || 'dummy_key', // Defaults to dummy for dev
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
  try {
    // Format messages for Claude
    // History should be an array of { role: 'user' | 'assistant', content: string }
    const messages = [];
    
    // Add past history (limit to last 6-10 messages typically handled by caller)
    for (const msg of history) {
      messages.push({
        role: msg.role,
        content: msg.message // This will be the decrypted "response" string, not the full JSON
      });
    }

    // Add current message
    messages.push({
      role: 'user',
      content: currentMessage
    });

    const response = await anthropic.messages.create({
      model: "claude-3-5-sonnet-20241022", // Use Claude 3.5 Sonnet
      max_tokens: 1024,
      system: SYSTEM_PROMPT,
      messages: messages,
      temperature: 0.7,
    });

    const textOutput = response.content[0].text;

    try {
      // Sometimes Claude wraps JSON in markdown block even when told not to
      const cleanedText = textOutput.replace(/```json/g, '').replace(/```/g, '').trim();
      const jsonResponse = JSON.parse(cleanedText);
      
      // Basic validation
      if (!jsonResponse.response || !jsonResponse.detected_emotion) {
        throw new Error('Invalid JSON structure returned from Claude');
      }
      
      return jsonResponse;
    } catch (parseError) {
      console.error('Failed to parse Claude JSON response:', parseError, textOutput);
      if (retryCount < 1) {
        console.log('Retrying Claude API call due to parse error...');
        return getChatResponse(history, currentMessage, retryCount + 1);
      }
      throw new Error('Parse failure after retry');
    }

  } catch (error) {
    console.error('Claude API Error:', error);
    // Fallback response as requested
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
