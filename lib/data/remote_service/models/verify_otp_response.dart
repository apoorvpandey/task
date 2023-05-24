class VerifyOtpResponse {
  VerifyOtpResponse({
    bool? status,
    bool? profileExists,
    String? jwt,
    String? response,
  }) {
    _status = status;
    _profileExists = profileExists;
    _jwt = jwt;
    _response = response;
  }

  VerifyOtpResponse.fromJson(dynamic json) {
    _status = json['status'];
    _profileExists = json['profile_exists'];
    _jwt = json['jwt'];
    _response = json['response'];
  }

  bool? _status;
  bool? _profileExists;
  String? _jwt;
  String? _response;

  bool? get status => _status;

  bool? get profileExists => _profileExists;

  String? get jwt => _jwt;

  String? get response => _response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['profile_exists'] = _profileExists;
    map['jwt'] = _jwt;
    map['response'] = _response;
    return map;
  }
}
