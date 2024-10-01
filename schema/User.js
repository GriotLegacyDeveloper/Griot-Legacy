var mongoose = require('mongoose');
var bcrypt = require('bcryptjs');

var userSchema = new mongoose.Schema({
    fullName: { type: String, required: true },
    email: { type: String, default: ''},
    countryCode: { type: String,default: ''},
    phone: { type: Number, default: 0},
    password: { type: String },
    dateOfBirth: {type: Date},
    profileImage: { type: String, default: '' },
    gender: { type: String, default: '' },
    relationship: { type: String, default: '' },
    status: { type: String, enum: ['INACTIVE', 'WAITING FOR APPROVAL', 'ACTIVE','BLOCK']},
    userLoginType: { type: String, enum: ['EMAIL', 'PHONE']},
    verificationOTP: { type: String, default: '' },
    fpOTP: { type: String, default: '' },
    badgeCount: { type: Number, default: 0 },
    notificationCount: { type: Number, default: 0 },
    profile: { type: String, enum: ["PUBLIC", "PRIVATE"], default: 'PUBLIC'},
    notification: { type: String, enum: ["ON", "OFF"], default: 'ON'},
    lastLogin: {type: String},
    isDeleted: {type: Boolean, default: false}
}, {
    timestamps: true
});

userSchema.pre('save', function(next) {
    let customer = this;
    if (!customer.isModified('password')) {
        return next();
    }

    bcrypt.hash(customer.password, 8, function(err, hash) {
        if (err) {
            return next(err);
        } else {
            if (customer.password !== '') {
                customer.password = hash
            }
            next();
        }
    })
});

module.exports = mongoose.model('User', userSchema);