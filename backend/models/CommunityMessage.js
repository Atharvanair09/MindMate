const mongoose = require('mongoose');

const CommunityMessageSchema = new mongoose.Schema({
  messageId: {
    type: String,
    required: true,
    unique: true
  },
  communityId: {
    type: String,
    required: true,
    index: true
  },
  senderId: {
    type: String,
    required: true
  },
  anonymousAlias: {
    type: String,
    required: true
  },
  sanitizedMessage: {
    type: String,
    required: true
  },
  timestamp: {
    type: Date,
    default: Date.now,
    index: true
  },
  replyTarget: {
    type: String,
    default: null
  },
  reactionCounts: {
    type: Map,
    of: Number,
    default: {}
  },
  isEdited: {
    type: Boolean,
    default: false
  },
  isDeleted: {
    type: Boolean,
    default: false
  }
});

module.exports = mongoose.model('CommunityMessage', CommunityMessageSchema);
