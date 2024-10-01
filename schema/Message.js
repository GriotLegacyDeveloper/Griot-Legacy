var mongoose = require('mongoose');

var MessageSchema = new mongoose.Schema({
    fromUserId: { type: mongoose.Schema.ObjectId,  ref: 'User', required: true},
    toUserId: { type: mongoose.Schema.ObjectId,  ref: 'User', required: true},
    messageType: { type: String, enum: ['NORMAL','POST']},
    message: { type: String  },
    fromIsRead: { type: String, default: 'NO', enum: ['YES', 'NO']  },
    toIsRead: { type: String, default: 'NO', enum: ['YES', 'NO']  },
    postId: { type: mongoose.Schema.ObjectId, ref: "Post"},
    combinationName: { type: String},
    deletedBy: {type: Array},
    quoteMsgID: {type: String, default: ''},
    quoteMsg: {type: String, default: ''},
}, {
    timestamps: true
});

module.exports = mongoose.model('Message', MessageSchema);