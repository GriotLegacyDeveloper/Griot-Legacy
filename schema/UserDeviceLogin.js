var mongoose = require('mongoose');

var userDeviceLoginSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, required: true },
    appType: { type: String,required: true , enum: ['IOS', 'ANDROID', 'BROWSER']},
    deviceToken: { type: String  }
}, {
    timestamps: true
});

module.exports = mongoose.model('UserDeviceLogin', userDeviceLoginSchema);