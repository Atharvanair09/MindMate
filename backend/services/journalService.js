const Journal = require('../models/Journal');
const mongoose = require('mongoose');

/**
 * Create a new journal entry
 * @param {string} userId - Hashed user ID
 * @param {string} content - Journal entry content
 * @returns {Promise<Object>} Created journal entry
 */
const createJournalEntry = async (userId, content) => {
  try {
    const entry = new Journal({
      userId,
      content,
      createdAt: new Date()
    });

    const savedEntry = await entry.save();
    return {
      _id: savedEntry._id,
      userId: savedEntry.userId,
      content: savedEntry.content,
      createdAt: savedEntry.createdAt
    };
  } catch (error) {
    console.error('[v0] journalService.createJournalEntry error:', error.message);
    throw new Error(`Failed to create journal entry: ${error.message}`);
  }
};

/**
 * Get all journal entries for a user
 * @param {string} userId - Hashed user ID
 * @param {number} limit - Number of entries to retrieve (default 50, max 100)
 * @param {number} offset - Offset for pagination (default 0)
 * @returns {Promise<Object>} Entries array and total count
 */
const getJournalEntries = async (userId, limit = 50, offset = 0) => {
  try {
    // Ensure limit doesn't exceed max
    const safeLimit = Math.min(limit, 100);

    const entries = await Journal.find({ userId })
      .sort({ createdAt: -1 })
      .limit(safeLimit)
      .skip(offset)
      .lean();

    const total = await Journal.countDocuments({ userId });

    return {
      entries: entries.map(entry => ({
        _id: entry._id,
        userId: entry.userId,
        content: entry.content,
        createdAt: entry.createdAt
      })),
      total
    };
  } catch (error) {
    console.error('[v0] journalService.getJournalEntries error:', error.message);
    throw new Error(`Failed to retrieve journal entries: ${error.message}`);
  }
};

/**
 * Delete a journal entry (ownership verified)
 * @param {string} entryId - Journal entry ID
 * @param {string} userId - Hashed user ID (for authorization)
 * @returns {Promise<boolean>} True if deleted, false if not found or unauthorized
 */
const deleteJournalEntry = async (entryId, userId) => {
  try {
    // Validate ObjectId format
    if (!mongoose.Types.ObjectId.isValid(entryId)) {
      return false;
    }

    // Delete only if entry belongs to user
    const result = await Journal.findOneAndDelete({
      _id: entryId,
      userId
    });

    return result !== null;
  } catch (error) {
    console.error('[v0] journalService.deleteJournalEntry error:', error.message);
    throw new Error(`Failed to delete journal entry: ${error.message}`);
  }
};

module.exports = {
  createJournalEntry,
  getJournalEntries,
  deleteJournalEntry
};

