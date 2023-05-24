class SendOtpResponse {
  SendOtpResponse({
    bool? status,
    String? response,
    String? requestId,
  }) {
    _status = status;
    _response = response;
    _requestId = requestId;
  }

  SendOtpResponse.fromJson(dynamic json) {
    _status = json['status'];
    _response = json['response'];
    _requestId = json['request_id'];
  }

  bool? _status;
  String? _response;
  String? _requestId;

  bool? get status => _status;

  String? get response => _response;

  String? get requestId => _requestId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['response'] = _response;
    map['request_id'] = _requestId;
    return map;
  }
}
