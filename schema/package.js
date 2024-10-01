const mongoose = require('mongoose');

const storagePackageSchema = new mongoose.Schema({
    size: { type: String },
    unit: { type: String },
    price: { type: String },
    currency: { type: String }
});

const storagePackage = mongoose.model('storagePackage', storagePackageSchema);

module.exports = storagePackage;
