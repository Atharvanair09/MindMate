const express = require('express');
const router = express.Router();
const voiceController = require('../controllers/voice.controller');

// Proxy OpenRouter chat completions
router.post('/chat', voiceController.chatCompletions);

module.exports = router;
