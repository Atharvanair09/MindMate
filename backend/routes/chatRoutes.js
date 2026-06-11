const express = require('express');
const router = express.Router();
const chatService = require('../services/chat.service');
const { hashUuid } = require('../utils/crypto');

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
router.post('/message', chatLimiter, ensureHashedUuid, async (req, res) => {
  try {
    const { message, conversation_id } = req.body;
    
    if (!message || !conversation_id) {
      return res.status(400).json({ error: 'message and conversation_id are required' });
    }

    const result = await chatService.handleNewMessage(req.hashedUuid, conversation_id, message);
    return res.json(result);
  } catch (error) {
    console.error('Error handling chat message:', error);
    return res.status(500).json({ error: 'Internal server error processing chat message' });
  }
});

/**
 * GET /api/v1/chat/history?conversation_id=X
 */
router.get('/history', ensureHashedUuid, async (req, res) => {
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
router.get('/conversations', ensureHashedUuid, async (req, res) => {
  try {
    const conversations = await chatService.getConversations(req.hashedUuid);
    return res.json(conversations);
  } catch (error) {
    console.error('Error fetching conversations:', error);
    return res.status(500).json({ error: 'Internal server error fetching conversations' });
  }
});

module.exports = router;
