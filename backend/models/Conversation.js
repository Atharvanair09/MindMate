const mongoose = require('mongoose');

const MessageSchema = new mongoose.Schema({
  role: { 
    type: String, 
    enum: ['user', 'assistant'], 
    required: true 
  },
  message: { 
    type: String, 
    required: true 
  }, // This will be encrypted
  emotion: { 
    type: String, 
    enum: ["anxious", "sad", "angry", "lonely", "overwhelmed", "hopeful", "neutral", "stressed", "content"], 
    default: 'neutral' 
  },
  emotion_confidence: { 
    type: String, 
    enum: ["low", "medium", "high"],
    default: "medium"
  },
  risk_flag: { 
    type: Boolean, 
    default: false 
  },
  timestamp: { 
    type: Date, 
    default: Date.now 
  }
});

const ConversationSchema = new mongoose.Schema({
  hashedUuid: { 
    type: String, 
    required: true, 
    index: true 
  },
  conversationId: { 
    type: String, 
    required: true, 
    index: true 
  },
  messages: [MessageSchema],
  createdAt: { 
    type: Date, 
    default: Date.now 
  },
  updatedAt: { 
    type: Date, 
    default: Date.now 
  }
});

// Update the updatedAt timestamp on save
ConversationSchema.pre('save', function(next) {
  this.updatedAt = new Date();
  next();
});

module.exports = mongoose.model('Conversation', ConversationSchema);
