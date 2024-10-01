var mongoose = require('mongoose');

var mapUserInnerCircleeSchema = new mongoose.Schema({
    userId: { type: String, required: true },
    circleUserId: { type: String, required: true }
},
    {
        timestamps: true,
    });


module.exports = mongoose.model('MapUserInnerCircle', mapUserInnerCircleeSchema);