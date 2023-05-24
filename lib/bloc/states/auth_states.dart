abstract class AuthState {}

class AuthInitial extends AuthState {}

class OTPSendingState extends AuthState {}

class OTPSendingSuccessState extends AuthState {
  final String? response, requestId;

  OTPSendingSuccessState(this.response, this.requestId);
}

class OTPSendingFailureState extends AuthState {
  final String? response;

  OTPSendingFailureState(this.response);
}

class OTPVerifyingState extends AuthState {}

class OTPVerifyingSuccessState extends AuthState {
  final bool? profileExists;
  final String? jwtToken;

  OTPVerifyingSuccessState(this.profileExists, this.jwtToken);
}

class OTPVerifyingFailureState extends AuthState {
  final String? response;

  OTPVerifyingFailureState(this.response);
}

class ProfileSubmittingState extends AuthState {}

class ProfileSubmittingSuccessState extends AuthState {
  final String? response;

  ProfileSubmittingSuccessState(this.response);
}

class ProfileSubmittingFailureState extends AuthState {
  final String? response;

  ProfileSubmittingFailureState(this.response);
}
