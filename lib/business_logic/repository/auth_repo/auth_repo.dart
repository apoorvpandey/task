import 'package:task/data/remote_service/models/send_otp_response.dart';
import 'package:task/data/remote_service/models/verify_otp_response.dart';

abstract class AuthRepo {
  Future<SendOtpResponse> sendOTP(Map<String, String> body);

  Future<VerifyOtpResponse> verifyOTP(Map<String, String> body);

  Future<VerifyOtpResponse> submitProfile(Map<String, String> body);
}
