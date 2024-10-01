var mongoose = require("mongoose");

var storagePackageSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.ObjectId,
    },
    size: {
      type: Number
    },
    unit: {
        type:String
    },
    price: {
      type: Number
    },
    currency: {
        type:String
    }
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("storagePackage", storagePackageSchema);
