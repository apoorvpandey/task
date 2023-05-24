abstract class AuthEvents {}

class AuthMobileSubmitEvent extends AuthEvents {
  final String mobile;

  AuthMobileSubmitEvent(this.mobile);
}

class AuthOTPSubmitEvent extends AuthEvents {
  final String requestId, otp;

  AuthOTPSubmitEvent(this.requestId, this.otp);
}

class AuthProfileSubmitEvent extends AuthEvents {
  final String name, email;

  AuthProfileSubmitEvent(this.name, this.email);
}
