  const express = require('express');
const router = express.Router();
const chatService = require('../services/chat.service');
const { hashUuid } = require('../utils/crypto');
const authenticateToken = require('../middleware/authMiddleware');

// Apply rate limiting for chat: 100 per day
const rateLimit = require('express-rate-limit');
const chatLimiter = rateLimit({
  windowMs: 24 * 60 * 60 * 1000, // 24 hours
  max: 100,
  message: { error: 'Daily chat limit reached. Please try again tomorrow.' }
});

// Middleware to hash the UUID if it's not already hashed by authMiddleware
const ensureHashedUuid = (req, res, next) => {
  if (req.uuid && !req.hashedUuid) {
    req.hashedUuid = hashUuid(req.uuid);
  }
  next();
};

/**
 * POST /api/v1/chat/message
 * Input: { message: string, conversation_id: string }
 */
router.post('/message', authenticateToken, chatLimiter, ensureHashedUuid, async (req, res) => {
  try {
    const { message, conversation_id } = req.body;
    console.log('[CHAT] POST /message — uuid:', req.uuid, '| hashedUuid:', req.hashedUuid);
    console.log('[CHAT] conversation_id:', conversation_id, '| message:', message?.substring(0, 80));
    
    if (!message || !conversation_id) {
      console.log('[CHAT] ❌ Missing message or conversation_id');
      return res.status(400).json({ error: 'message and conversation_id are required' });
    }

    const result = await chatService.handleNewMessage(req.hashedUuid, conversation_id, message);
    console.log('[CHAT] ✅ Response sent:', JSON.stringify(result).substring(0, 200));
    return res.json(result);
  } catch (error) {
    console.error('[CHAT] ❌ Error handling chat message:', error);
    return res.status(500).json({ error: 'Internal server error processing chat message' });
  }
});

/**
 * GET /api/v1/chat/history?conversation_id=X
 */
router.get('/history', authenticateToken, ensureHashedUuid, async (req, res) => {
  try {
    const { conversation_id } = req.query;
    
    if (!conversation_id) {
      return res.status(400).json({ error: 'conversation_id query parameter is required' });
    }

    const history = await chatService.getHistory(req.hashedUuid, conversation_id);
    return res.json(history);
  } catch (error) {
    console.error('Error fetching chat history:', error);
    return res.status(500).json({ error: 'Internal server error fetching history' });
  }
});

/**
 * GET /api/v1/chat/conversations
 */
router.get('/conversations', authenticateToken, ensureHashedUuid, async (req, res) => {
  try {
    const conversations = await chatService.getConversations(req.hashedUuid);
    return res.json(conversations);
  } catch (error) {
    console.error('Error fetching conversations:', error);
    return res.status(500).json({ error: 'Internal server error fetching conversations' });
  }
});

module.exports = router;
