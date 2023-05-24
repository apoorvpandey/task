import 'package:task/business_logic/repository/auth_repo/auth_repo.dart';
import 'package:task/data/abstract_service/remote_data_service.dart';
import 'package:task/data/api_service.dart';
import 'package:task/data/remote_service/models/send_otp_response.dart';
import 'package:task/data/remote_service/models/verify_otp_response.dart';

class AuthRepoImp extends AuthRepo {
  final RemoteDataService _service = ApiService();

  @override
  Future<SendOtpResponse> sendOTP(Map<String, String> body) {
    return _service.sendOTP(body);
  }

  @override
  Future<VerifyOtpResponse> verifyOTP(Map<String, String> body) {
    return _service.verifyOTP(body);
  }

  @override
  Future<VerifyOtpResponse> submitProfile(Map<String, String> body) {
    return _service.submitProfile(body);
  }
}
