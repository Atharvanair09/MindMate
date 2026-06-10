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
  },
  // Profile identity — set after profile setup, null until then
  username: {
    type: String,
    default: null,
    trim: true
  },
  avatarLabel: {
    type: String,
    default: null
  },
  // Custom avatar photo stored as a base64 data URL (null when using a default icon avatar)
  avatarImageUrl: {
    type: String,
    default: null
  }
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
