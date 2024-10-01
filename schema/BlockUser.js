var mongoose = require('mongoose');

var BlockUserSchema = new mongoose.Schema({
    userId: { type: String, required: true },
    blockUserId: { type: String, required: true }
},
    {
        timestamps: true,
    });


module.exports = mongoose.model('BlockUser', BlockUserSchema);