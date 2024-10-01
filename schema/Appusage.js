var mongoose = require('mongoose');
var bcrypt = require('bcryptjs');
var Schema = mongoose.Schema

var appUsageSchema = new mongoose.Schema({
    customerId: {type: String},
    IN: {type: String, default: ''},
    OUT: {type: String, default: ''},
    name: { type: String},
    email: {type: String },
    countryCode: { type: String,default: ''},
    phone: { type: Number, default: 0},
    date: {type: String},
    appUsage: {type: Number, default: 0}
},{
    timestamps: true
});

module.exports = mongoose.model('appUsage', appUsageSchema)