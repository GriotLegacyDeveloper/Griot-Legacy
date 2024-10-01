import 'package:flutter/material.dart';

class QuickLink {
  final String content;
  final VoidCallback onPressed;
  QuickLink(this.content, this.onPressed);
  factory QuickLink.fromMap(Map<String, dynamic> json) {
    return QuickLink(json['content'], json['action']);
  }
}
