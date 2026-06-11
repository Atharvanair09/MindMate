const Conversation = require('../models/Conversation');
const { encrypt, decrypt } = require('../utils/crypto');
const aiService = require('./ai.service');

async function handleNewMessage(hashedUuid, conversationId, userMessage) {
  console.log('[CHAT-SVC] handleNewMessage called');
  console.log('[CHAT-SVC] hashedUuid:', hashedUuid);
  console.log('[CHAT-SVC] conversationId:', conversationId);
  console.log('[CHAT-SVC] userMessage:', userMessage?.substring(0, 80));

  // Find or create conversation
  let conversation = await Conversation.findOne({ hashedUuid, conversationId });
  if (!conversation) {
    console.log('[CHAT-SVC] No existing conversation found — creating new one');
    conversation = new Conversation({ hashedUuid, conversationId, messages: [] });
  } else {
    console.log('[CHAT-SVC] Found existing conversation with', conversation.messages.length, 'messages');
  }

  // Get recent history for Claude (last 8 messages)
  const recentMessages = conversation.messages.slice(-8);
  const decryptedHistory = recentMessages.map(msg => ({
    role: msg.role,
    message: decrypt(msg.message) || msg.message // fallback if decryption fails
  }));
  console.log('[CHAT-SVC] Decrypted history length:', decryptedHistory.length);

  // Call Claude AI
  console.log('[CHAT-SVC] Calling Claude AI...');
  const aiResponse = await aiService.getChatResponse(decryptedHistory, userMessage);
  console.log('[CHAT-SVC] Claude AI response received:', JSON.stringify(aiResponse).substring(0, 300));

  // Encrypt the messages
  const encryptedUserMessage = encrypt(userMessage);
  const encryptedAiMessage = encrypt(aiResponse.response);
  console.log('[CHAT-SVC] Encryption done — user:', !!encryptedUserMessage, '| ai:', !!encryptedAiMessage);

  // Add user message to DB
  conversation.messages.push({
    role: 'user',
    message: encryptedUserMessage,
    emotion: 'neutral', // default
    emotion_confidence: 'medium',
    risk_flag: false,
    timestamp: new Date()
  });

  // Add AI response to DB
  conversation.messages.push({
    role: 'assistant',
    message: encryptedAiMessage,
    emotion: aiResponse.detected_emotion || 'neutral',
    emotion_confidence: aiResponse.emotion_confidence || 'medium',
    risk_flag: aiResponse.risk_flag || false,
    timestamp: new Date()
  });

  console.log('[CHAT-SVC] Saving conversation to DB...');
  await conversation.save();
  console.log('[CHAT-SVC] ✅ Conversation saved');

  // Evaluate escalation logic
  let show_escalation = false;
  
  // Rule 1: 2+ risk flags in THIS conversation
  const riskCountInConv = conversation.messages.filter(msg => msg.risk_flag === true).length;
  console.log('[CHAT-SVC] Risk flags in this conversation:', riskCountInConv);
  if (riskCountInConv >= 2) {
    show_escalation = true;
  } else {
    // Rule 2: 3+ times in the last 7 days across all conversations
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
    
    const recentConvs = await Conversation.find({ 
      hashedUuid, 
      "messages.timestamp": { $gte: sevenDaysAgo },
      "messages.risk_flag": true 
    });
    
    let totalRecentRisks = 0;
    recentConvs.forEach(conv => {
      const risks = conv.messages.filter(m => m.risk_flag === true && m.timestamp >= sevenDaysAgo);
      totalRecentRisks += risks.length;
    });
    console.log('[CHAT-SVC] Total risk flags in last 7 days:', totalRecentRisks);

    if (totalRecentRisks >= 3) {
      show_escalation = true;
    }
  }

  // If aiResponse already set it (fallback case), respect it
  if (aiResponse.show_escalation !== undefined) {
      show_escalation = aiResponse.show_escalation;
  }

  const result = {
    response: aiResponse.response,
    emotion_detected: aiResponse.detected_emotion || 'neutral',
    show_escalation
  };
  console.log('[CHAT-SVC] ✅ Returning result:', JSON.stringify(result).substring(0, 200));
  return result;
}

async function getHistory(hashedUuid, conversationId) {
  const conversation = await Conversation.findOne({ hashedUuid, conversationId });
  if (!conversation) {
    return [];
  }

  return conversation.messages.map(msg => ({
    role: msg.role,
    message: decrypt(msg.message) || msg.message,
    emotion: msg.emotion,
    timestamp: msg.timestamp
  }));
}

async function getConversations(hashedUuid) {
  // Returns all conversation IDs with a preview of the last message
  const conversations = await Conversation.find({ hashedUuid }).sort({ updatedAt: -1 });
  
  return conversations.map(conv => {
    let lastMessageText = '';
    let timestamp = conv.updatedAt;
    
    if (conv.messages && conv.messages.length > 0) {
      const lastMsg = conv.messages[conv.messages.length - 1];
      const decrypted = decrypt(lastMsg.message) || lastMsg.message;
      lastMessageText = decrypted.substring(0, 50) + (decrypted.length > 50 ? '...' : '');
      timestamp = lastMsg.timestamp;
    }

    return {
      conversation_id: conv.conversationId,
      preview: lastMessageText,
      timestamp
    };
  });
}

module.exports = {
  handleNewMessage,
  getHistory,
  getConversations
};
