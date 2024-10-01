var mongoose = require('mongoose');

var customerCardSchema = new mongoose.Schema({
    customerId: { type: mongoose.Schema.Types.ObjectId, required: true },
    StripeAccountId: { type: String, required: true },
    email: { type: String, default: '', required: true },
    phone: { type: String, default: '' },
    cardId: { type: String, default: '' }
}, {
    timestamps: true
});


module.exports = mongoose.model('CustomerCard', customerCardSchema);