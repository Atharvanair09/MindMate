const express = require('express');
const router = express.Router();
const journalController = require('../controllers/journalController');
const authMiddleware = require('../middleware/authMiddleware');

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

module.exports = router;

