var mongoose = require('mongoose');

var Schema = mongoose.Schema;
var ConnectUserSchema = new Schema({
    fromUserId: { type: String, default: '', required: true },
    toUserId: { type: String, default: '', required: true },
    addedOn: { type: Date, default: new Date, required: true },
}, {
    timestamps: true
});

module.exports = mongoose.model('ConnectUser', ConnectUserSchema);