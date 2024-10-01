var mongoose = require('mongoose');

var userFileSchema = new mongoose.Schema({
    userId: { type: String, required: true },
    postId: { type: String, required: true },
    file: { type: String, required: true },
    type: { type: String, default: 'IMAGE', enum: ['IMAGE','VIDEO'] },
    thumb: { type: String, default: ''},
    caption: { type: String, default: ''},
    album: { type: String, default: 'NORMAL'}
},
    {
        timestamps: true,
    });


module.exports = mongoose.model('UserFile', userFileSchema);