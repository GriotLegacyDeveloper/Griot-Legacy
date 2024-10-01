var mongoose = require('mongoose');

var blockUserTribeSchema = new mongoose.Schema({
    userId: { type: String, required: true },
    tribeId: { type: String, required: true }
},
    {
        timestamps: true,
    });


module.exports = mongoose.model('BlockUserTribe', blockUserTribeSchema);