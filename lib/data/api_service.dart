import 'dart:io';

import 'package:task/data/abstract_service/remote_data_service.dart';
import 'package:task/data/remote_service/models/send_otp_response.dart';
import 'package:task/data/remote_service/models/verify_otp_response.dart';
import 'package:task/utils/strings.dart';
import 'package:task/utils/utils.dart';

import 'constants/constants.dart';
import 'network_utility.dart';

class ApiService extends RemoteDataService {
  @override
  Future<SendOtpResponse> sendOTP(Map<String, String> body) async {
    final url = Uri.https(RemoteUrls.baseURL, RemoteUrls.sentOTP);

    final json = await NetworkUtils.post(url, body: body);

    SendOtpResponse response = SendOtpResponse.fromJson(json);

    return response;
  }

  @override
  Future<VerifyOtpResponse> verifyOTP(Map<String, String> body) async {
    final url = Uri.https(RemoteUrls.baseURL, RemoteUrls.verifyOTP);

    final json = await NetworkUtils.post(url, body: body);

    VerifyOtpResponse response = VerifyOtpResponse.fromJson(json);

    return response;
  }

  @override
  Future<VerifyOtpResponse> submitProfile(Map<String, String> body) async {
    final url = Uri.https(RemoteUrls.baseURL, RemoteUrls.submitProfile);
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Token': '${await getFromSharedPreference(jwtToken)}',
    };

    final json = await NetworkUtils.post(url, headers: headers, body: body);

    VerifyOtpResponse response = VerifyOtpResponse.fromJson(json);

    return response;
  }
}
