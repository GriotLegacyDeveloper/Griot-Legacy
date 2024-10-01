var mongoose = require('mongoose');

var mapUserTribeSchema = new mongoose.Schema({
    userId: { type: String, required: true },
    tribeId: { type: String, required: true }
},
    {
        timestamps: true,
    });


module.exports = mongoose.model('MapUserTribe', mapUserTribeSchema);