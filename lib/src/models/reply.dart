class Reply {
  final bool success;
  final int code;
  final String message;
  final Map<String, dynamic> data;
  Reply(this.success, this.code, this.message, this.data);
  Map<String, dynamic> get json {
    Map<String, dynamic> map = <String, dynamic>{};
    map['data'] = data;
    map['status'] = code;
    map['success'] = success;
    map['message'] = message;
    return map;
  }

  factory Reply.fromMap(Map<String, dynamic> json) {
    print(json);
    return Reply(json['success'], json['STATUSCODE'], json['message'],
        json['response_data'] ?? <String, dynamic>{});
  }
}
