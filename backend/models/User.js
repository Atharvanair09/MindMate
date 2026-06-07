const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  uuid: {
    type: String,
    required: true,
    unique: true
  },
  recoveryPhraseHash: {
    type: String,
    required: true,
    unique: true // Since we use sha256 to deterministically find the user by their phrase
  }
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
