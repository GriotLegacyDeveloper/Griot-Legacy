var mongoose = require("mongoose");

var groupMessage = mongoose.Schema({
    group_id: { type: mongoose.Schema.ObjectId, ref: "groupChat", require: true },
    message: { type: String, require: true },
    deletedBy: {type: Array},
    sender: { type: mongoose.Schema.ObjectId, ref: "User", require: true },
    quoteMsgID: {type: String, default: ''},
    quoteMsg: {type: String, default: ''},
}, { timestamps: true 
});

module.exports = mongoose.model('groupMessage', groupMessage);