var mongoose = require("mongoose");

var ShareSchema = new mongoose.Schema(
  {
    postId: {
      type: mongoose.Schema.ObjectId,
      ref: "UserPost",
    },
    sharedBy: {
      type: mongoose.Schema.ObjectId,
      ref: "User",
      required: true,
    },
    created_At: {
      type: Date,
      default: Date.now(),
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("Share", ShareSchema);
