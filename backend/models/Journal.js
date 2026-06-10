const mongoose = require('mongoose');

const journalSchema = new mongoose.Schema(
  {
    userId: {
      type: String,
      required: true,
      index: true,
      description: 'Hashed user ID (SHA-256 of UUID), never raw UUID'
    },
    content: {
      type: String,
      required: true,
      minlength: 1,
      maxlength: 10000,
      description: 'Journal entry text content'
    },
    createdAt: {
      type: Date,
      default: Date.now,
      index: true
    }
  },
  {
    timestamps: true,
    collection: 'journal_entries'
  }
);

// Compound index for efficient querying by user and date range
journalSchema.index({ userId: 1, createdAt: -1 });

module.exports = mongoose.model('Journal', journalSchema);
