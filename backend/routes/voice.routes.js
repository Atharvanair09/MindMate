const express = require('express');
const router = express.Router();
const voiceController = require('../controllers/voice.controller');

// Generate ephemeral token for OpenAI Realtime API
router.post('/session', voiceController.getSessionToken);

module.exports = router;
