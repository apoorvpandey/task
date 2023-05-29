import 'package:task/business_logic/repository/auth_repo/auth_repo.dart';
import 'package:task/data/remote_service/models/send_otp_response.dart';
import 'package:task/data/remote_service/models/verify_otp_response.dart';

class AuthUseCase {
  final AuthRepo _authRepoImpl;

  AuthUseCase({required AuthRepo authRepoImpl}) : _authRepoImpl = authRepoImpl;

  Future<SendOtpResponse> sendOTP(Map<String, String> body) {
    return _authRepoImpl.sendOTP(body);
  }

  Future<VerifyOtpResponse> verifyOTP(Map<String, String> body) {
    return _authRepoImpl.verifyOTP(body);
  }

  Future<VerifyOtpResponse> submitProfile(Map<String, String> body) {
    return _authRepoImpl.submitProfile(body);
  }
}
