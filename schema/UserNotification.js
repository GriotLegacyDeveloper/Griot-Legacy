var mongoose = require('mongoose');

var userNotificationSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, required: true },
    notificationType: { type: String, required: true, enum: ['REQUEST_RECEIVE', 'ACCEPT_REJECT', 'MESSAGE', 'NEW_POST', 'NEW_POST_LIVE', 'POST_LIKE', 'POST_COMMENT', 'REPORT_POST', 'DELETE_POST', 'REPORT_USER'] },
    title: { type: String },
    message: { type: String },
    isRead: { type: String, enum: ['YES', 'NO'] },
    otherData: { type: String },
    otherUserId: { type: String }
}, {
    timestamps: true
});

module.exports = mongoose.model('UserNotification', userNotificationSchema);