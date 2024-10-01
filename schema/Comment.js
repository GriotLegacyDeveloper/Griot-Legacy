var mongoose = require("mongoose");

var CommentSchema = new mongoose.Schema(
  {
    postId: {
      type: mongoose.Schema.ObjectId,
      ref: "UserPost",
    },
    comment: { type: String, required: true },
    commentedBy: {
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

module.exports = mongoose.model("Comment", CommentSchema);
