var mongoose = require('mongoose');

var reportUserSchema = new mongoose.Schema({
    postId: { type: String, required: true },
    userId: { type: String, required: true },
    reportedUserId: { type: String, required: true },
    reportReason: { type: String, required: true }
}, {
    timestamps: true
})


module.exports = mongoose.model('ReportUser', reportUserSchema)