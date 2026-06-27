const CommunityMessage = require('../models/CommunityMessage');
const User = require('../models/User'); // We might need to verify users, but for now we trust the senderId from token if passed
const crypto = require('crypto');

function initCommunityChatService(io) {
  io.on('connection', (socket) => {
    console.log(`[COMMUNITY-CHAT] User connected: ${socket.id}`);

    // User joins a specific community room
    socket.on('join_community', async ({ communityId }) => {
      socket.join(communityId);
      console.log(`[COMMUNITY-CHAT] Socket ${socket.id} joined community: ${communityId}`);
    });

    // User leaves a specific community room
    socket.on('leave_community', ({ communityId }) => {
      socket.leave(communityId);
      console.log(`[COMMUNITY-CHAT] Socket ${socket.id} left community: ${communityId}`);
    });

    // Receive message, store in DB, and broadcast
    socket.on('send_message', async (data, callback) => {
      try {
        const { communityId, senderId, anonymousAlias, sanitizedMessage, replyTarget } = data;
        
        if (!communityId || !senderId || !anonymousAlias || !sanitizedMessage) {
           if (callback) callback({ success: false, error: 'Missing required fields' });
           return;
        }

        const messageId = crypto.randomBytes(16).toString('hex');
        const timestamp = new Date();

        const newMsg = new CommunityMessage({
          messageId,
          communityId,
          senderId,
          anonymousAlias,
          sanitizedMessage,
          timestamp,
          replyTarget: replyTarget || null,
        });

        await newMsg.save();
        console.log(`[COMMUNITY-CHAT] Saved message ${messageId} in ${communityId}`);

        // Broadcast to everyone in the room INCLUDING the sender (or the sender can just add it locally)
        // We will broadcast to the room so all other clients get it
        io.to(communityId).emit('new_message', {
          messageId: newMsg.messageId,
          communityId: newMsg.communityId,
          senderId: newMsg.senderId,
          anonymousAlias: newMsg.anonymousAlias,
          sanitizedMessage: newMsg.sanitizedMessage,
          timestamp: newMsg.timestamp.toISOString(),
          replyTarget: newMsg.replyTarget,
          reactionCounts: {},
          isEdited: false,
          isDeleted: false
        });

        if (callback) callback({ success: true, messageId });
      } catch (error) {
        console.error('[COMMUNITY-CHAT] Error saving message:', error);
        if (callback) callback({ success: false, error: 'Failed to save message' });
      }
    });

    // Get chat history for a community
    socket.on('get_community_history', async ({ communityId, limit = 50, beforeTimestamp }, callback) => {
      try {
        let query = { communityId };
        if (beforeTimestamp) {
          query.timestamp = { $lt: new Date(beforeTimestamp) };
        }
        
        const messages = await CommunityMessage.find(query)
          .sort({ timestamp: -1 })
          .limit(limit)
          .lean();
        
        if (callback) {
          callback({ success: true, messages: messages.reverse() });
        }
      } catch (error) {
        console.error('[COMMUNITY-CHAT] Error fetching history:', error);
        if (callback) callback({ success: false, error: 'Failed to fetch history' });
      }
    });

    // Get dynamic metrics for a community
    socket.on('get_community_metrics', async ({ communityId }, callback) => {
      try {
        // Active members in socket room
        const room = io.sockets.adapter.rooms.get(communityId);
        const activeMembers = room ? room.size : 0;
        
        // Count total unique senders in this community
        const uniqueSenders = await CommunityMessage.distinct('senderId', { communityId });
        const totalMembers = uniqueSenders.length;

        // Messages today
        const startOfDay = new Date();
        startOfDay.setHours(0, 0, 0, 0);
        
        const messagesToday = await CommunityMessage.countDocuments({
          communityId,
          timestamp: { $gte: startOfDay }
        });

        const repliesToday = await CommunityMessage.countDocuments({
          communityId,
          timestamp: { $gte: startOfDay },
          replyTarget: { $ne: null }
        });

        if (callback) {
          callback({
            success: true,
            metrics: {
              activeMembers,
              totalMembers: totalMembers > activeMembers ? totalMembers : activeMembers, // Rough estimate
              messagesToday,
              repliesToday
            }
          });
        }
      } catch (error) {
        console.error('[COMMUNITY-CHAT] Error fetching metrics:', error);
        if (callback) callback({ success: false, error: 'Failed to fetch metrics' });
      }
    });

    socket.on('disconnect', () => {
      console.log(`[COMMUNITY-CHAT] User disconnected: ${socket.id}`);
    });
  });
}

module.exports = {
  initCommunityChatService
};
