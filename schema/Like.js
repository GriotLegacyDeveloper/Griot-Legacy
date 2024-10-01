var mongoose = require("mongoose");

var LikeSchema = new mongoose.Schema(
  {
    postId: {
      type: mongoose.Schema.ObjectId,
      ref: "UserPost",
    },
    likedBy: {
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

module.exports = mongoose.model("Like", LikeSchema);
