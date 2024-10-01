const mongoose = require('mongoose');

const storageSchema = new mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    allocatedSize: {
        type: Number,
        required: true,
    },
});

const storage = mongoose.model('storage', storageSchema);

module.exports = storage;
