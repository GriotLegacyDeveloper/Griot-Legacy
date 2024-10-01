var mongoose = require('mongoose')

var groupFileSchema = new mongoose.Schema({
    groupId: { type: String, required: true },
    file: { type: String, required: true }
},
{
    timestamps: true
});

module.exports = mongoose.model('GroupFile', groupFileSchema)