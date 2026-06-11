const express = require('express');
const router = express.Router();
const journalController = require('../controllers/journalController');
const authMiddleware = require('../middleware/authMiddleware');
const JournalScore = require('../models/JournalScore');
const { hashUuid } = require('../utils/crypto');

/**
 * POST /journal
 * Create a new journal entry for the authenticated user
 * Body: { content: string }
 * Returns: { _id, userId, content, createdAt }
 */
router.post('/', authMiddleware, journalController.createJournalEntry);

/**
 * GET /journal
 * Retrieve all journal entries for the authenticated user
 * Query params: limit (default 50), offset (default 0)
 * Returns: [ { _id, userId, content, createdAt }, ... ]
 */
router.get('/', authMiddleware, journalController.getJournalEntries);

/**
 * DELETE /journal/:id
 * Delete a specific journal entry by ID (only own entries)
 * Returns: { success: true, message: "Journal entry deleted" }
 */
router.delete('/:id', authMiddleware, journalController.deleteJournalEntry);

/**
 * POST /journal/sync-score
 * Securely sync the sentiment score from the on-device journal
 */
router.post('/sync-score', authMiddleware, async (req, res) => {
  try {
    const { sentiment_score, date } = req.body;
    
    if (sentiment_score === undefined || !date) {
      return res.status(400).json({ error: 'sentiment_score and date are required' });
    }

    const hashedUuid = hashUuid(req.uuid);

    const scoreEntry = new JournalScore({
      hashedUuid,
      sentiment_score,
      date
    });

    await scoreEntry.save();
    return res.json({ success: true, message: 'Sentiment score synced successfully' });
  } catch (error) {
    console.error('Error syncing journal score:', error);
    return res.status(500).json({ error: 'Internal server error syncing score' });
  }
});

module.exports = router;

