const journalService = require('../services/journalService');

/**
 * Create a new journal entry
 * POST /journal
 */
exports.createJournalEntry = async (req, res) => {
  try {
    const { content } = req.body;
    const userId = req.user.userId; // From JWT middleware

    // Validate input
    if (!content || typeof content !== 'string' || content.trim().length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Content is required and must be a non-empty string'
      });
    }

    if (content.length > 10000) {
      return res.status(400).json({
        success: false,
        message: 'Content must not exceed 10000 characters'
      });
    }

    // Create entry via service
    const entry = await journalService.createJournalEntry(userId, content);

    return res.status(201).json({
      success: true,
      data: entry
    });
  } catch (error) {
    console.error('[v0] Error in createJournalEntry:', error.message);
    return res.status(500).json({
      success: false,
      message: 'Failed to create journal entry'
    });
  }
};

/**
 * Retrieve all journal entries for the authenticated user
 * GET /journal
 */
exports.getJournalEntries = async (req, res) => {
  try {
    const userId = req.user.userId; // From JWT middleware
    const limit = Math.min(parseInt(req.query.limit) || 50, 100); // Cap at 100
    const offset = parseInt(req.query.offset) || 0;

    // Retrieve entries via service
    const result = await journalService.getJournalEntries(userId, limit, offset);

    return res.status(200).json({
      success: true,
      data: result.entries,
      pagination: {
        total: result.total,
        limit,
        offset
      }
    });
  } catch (error) {
    console.error('[v0] Error in getJournalEntries:', error.message);
    return res.status(500).json({
      success: false,
      message: 'Failed to retrieve journal entries'
    });
  }
};

/**
 * Delete a specific journal entry
 * DELETE /journal/:id
 */
exports.deleteJournalEntry = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.userId; // From JWT middleware

    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Journal entry ID is required'
      });
    }

    // Delete entry via service (verifies ownership)
    const deleted = await journalService.deleteJournalEntry(id, userId);

    if (!deleted) {
      return res.status(404).json({
        success: false,
        message: 'Journal entry not found or unauthorized'
      });
    }

    return res.status(200).json({
      success: true,
      message: 'Journal entry deleted successfully'
    });
  } catch (error) {
    console.error('[v0] Error in deleteJournalEntry:', error.message);
    return res.status(500).json({
      success: false,
      message: 'Failed to delete journal entry'
    });
  }
};

