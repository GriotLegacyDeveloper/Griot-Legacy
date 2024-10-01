var mongoose = require('mongoose');

var userPostSchema = new mongoose.Schema({
    userId: { type: String, required: true },
    caption: { type: String, default: '' },
    postType: { type: String, default: 'NORMAL', enum: ['FILE','NORMAL','LINK'] },
    audience: { type: String, default: 'VILLAGE', enum: ['TRIBE','INNERCIRCLE','VILLAGE'] },
    tribe: { type: Array, default: [] },
    likes: [{ type: mongoose.Schema.ObjectId, ref: "Like" }],
    share: [{ type: mongoose.Schema.ObjectId, ref: "Share" }],
    comments: [{ type: mongoose.Schema.ObjectId, ref: "Comment" }],
    isBlocked: {type: Boolean, default: false},
},
    {
        timestamps: true,
    });


module.exports = mongoose.model('UserPost', userPostSchema);