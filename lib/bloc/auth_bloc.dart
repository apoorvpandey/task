import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/bloc/events/auth_events.dart';
import 'package:task/business_logic/use_case/auth_use_case/auth_use_case.dart';
import 'package:task/data/repository/auth_repo_imp/auth_repo_imp.dart';
import 'package:task/utils/strings.dart';
import 'package:task/utils/utils.dart';

import 'states/auth_states.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  final AuthUseCase _authUseCase = AuthUseCase(authRepoImpl: AuthRepoImp());

  AuthBloc() : super(AuthInitial()) {
    on<AuthMobileSubmitEvent>((event, emit) => _sentOTP(event, emit));
    on<AuthOTPSubmitEvent>((event, emit) => _verifyOTP(event, emit));
    on<AuthProfileSubmitEvent>((event, emit) => _submitProfile(event, emit));
  }

  Future<void> _sentOTP(
      AuthMobileSubmitEvent event, Emitter<AuthState> emit) async {
    try {
      Map<String, String> body = {'mobile': event.mobile};
      emit(OTPSendingState());
      var data = await _authUseCase.sendOTP(body);
      if (data.status!) {
        emit(OTPSendingSuccessState(data.response, data.requestId));
      } else {
        emit(OTPSendingFailureState(data.response));
      }
    } catch (error) {
      debugPrint('_sentOTPError: $error');
    }
  }

  Future<void> _verifyOTP(
      AuthOTPSubmitEvent event, Emitter<AuthState> emit) async {
    try {
      Map<String, String> body = {
        'request_id': event.requestId,
        'code': event.otp
      };
      emit(OTPVerifyingState());
      var data = await _authUseCase.verifyOTP(body);
      if (data.status!) {
        emit(OTPVerifyingSuccessState(data.profileExists, data.jwt));
        await saveToSharedPreference(jwtToken, data.jwt!);
      } else {
        emit(OTPVerifyingFailureState(data.response));
      }
    } catch (error) {
      debugPrint('_verifyOTPError: $error');
    }
  }

  Future<void> _submitProfile(
      AuthProfileSubmitEvent event, Emitter<AuthState> emit) async {
    try {
      Map<String, String> body = {'name': event.name, 'email': event.email};
      emit(ProfileSubmittingState());
      var data = await _authUseCase.submitProfile(body);
      if (data.status!) {
        emit(ProfileSubmittingSuccessState(data.response));
      } else {
        emit(ProfileSubmittingFailureState(data.response));
      }
    } catch (error) {
      debugPrint('_submitProfileError: $error');
    }
  }
}
