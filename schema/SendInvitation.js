var mongoose = require('mongoose');

var Schema = mongoose.Schema;
var SendInvitationSchema = new Schema({
    fromUserId: { type: String, default: '', required: true },
    toUserId: { type: String, default: '', required: true },
    sendOn: { type: Date, default: new Date, required: true },
    isAccepted: { type: String, enum: ['YES', 'NO']},
    acceptedOn: { type: Date, default: new Date, required: true },
    acceptReject: { type: String, enum: ['ACCEPT', 'REJECT']},
}, {
    timestamps: true
});

module.exports = mongoose.model('SendInvitation', SendInvitationSchema);