var mongoose = require('mongoose');

var ContentSchema = new mongoose.Schema({
    name: { type: String, default: '',  required: true},
    pageName: { type: String, default: '',  required: true},
    content: { type: String },
    isActive: { type: Boolean, default: true }
}, {
    timestamps: true
});

module.exports = mongoose.model('Content', ContentSchema);