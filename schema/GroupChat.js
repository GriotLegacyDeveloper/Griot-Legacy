var mongoose = require("mongoose");

var chatModel = mongoose.Schema({
    chatName: { type: String, trim: true },
    isGroupChat: { type: Boolean, default: false },
    users: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
    blockedBy: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
    messages: [{ type: mongoose.Schema.Types.ObjectId, ref: "groupMessage" }],
    groupAdmin: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
}, { timestamps: true 
});

module.exports = mongoose.model('groupChats', chatModel);