const mongoose = require('mongoose');

const JournalScoreSchema = new mongoose.Schema({
  hashedUuid: { 
    type: String, 
    required: true, 
    index: true 
  },
  sentiment_score: { 
    type: Number, 
    required: true 
  },
  date: { 
    type: String, // YYYY-MM-DD
    required: true 
  },
  timestamp: { 
    type: Date, 
    default: Date.now 
  }
});

module.exports = mongoose.model('JournalScore', JournalScoreSchema);
