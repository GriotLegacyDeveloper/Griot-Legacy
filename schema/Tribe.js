var mongoose = require('mongoose');

var tribeSchema = new mongoose.Schema({
    createrUserId: { type: String, required: true },
    image: { type: String, default: '' },
    name: { type: String, required: true },
    type: { type: String, required: true }
},
    {
        timestamps: true,
    });


module.exports = mongoose.model('Tribe', tribeSchema);