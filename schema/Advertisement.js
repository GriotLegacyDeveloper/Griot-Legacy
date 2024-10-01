var mongoose = require('mongoose');

var advertisementSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.ObjectId, ref: "User" },
    companyName: { type: String, default: '' },
    contactPerson: { type: String, default: '' },
    emailAddress: { type: String, default: '' },
    phoneNumber: { type: Number, default: 0 },
    countryCode: { type: String, default: '' },
    physicalAddress: { type: String, default: '' },
    purposeOfAdvertisement: { type: String, default: '' },
    image: { type: String, default: '' },
    description: { type: String, default: '' },
    link: { type: String, default: '' },
    title: { type: String, default: '', required: true },
    validFrom: { type: Date },
    validTill: { type: Date },
    targetAudience: { type: String, default: "" },
    status: { type: String, enum: ['PENDING', 'APPROVED', 'REJECTED', 'UNPAID', 'EXPIRED', 'CANCELLED'], default: 'UNPAID' },
    paymentIntentId: { type: String, default: "" },
    amount: { type: String, default: "" },
    paymentType: { type: String, enum: ['STRIPE', 'PAYPAL', 'APPLEPAY'] }
    // trimmedValidFrom: { type: String },
    // trimmedValidTill: { type: String },
    // imageKey: { type: String, default: '', require: true },
}, {
    timestamps: true
});

module.exports = mongoose.model('advertisement', advertisementSchema);