const mongoose = require('mongoose');

var contactUsSchema = new mongoose.Schema({
    name: { type: String, default: '', required: true },
    email: { type: String, default: '',email: true, required: true },
    message: { type: String, default: '', required: true  }
},
{
    timestamps: true
});

module.exports = mongoose.model('ContactUs', contactUsSchema);