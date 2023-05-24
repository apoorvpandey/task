import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:task/bloc/auth_bloc.dart';
import 'package:task/bloc/events/auth_events.dart';
import 'package:task/bloc/states/auth_states.dart';
import 'package:task/utils/strings.dart';
import 'package:task/utils/utils.dart';
import 'package:task/views/home/home.dart';
import 'package:task/views/welcome/welcome.dart';

class EnterOTP extends StatelessWidget {
  final String mobile, requestId;

  const EnterOTP({super.key, required this.mobile, required this.requestId});

  @override
  Widget build(BuildContext context) {
    final otpController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    AuthBloc authBloc = AuthBloc();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false, title: const Text('Verify OTP')),
        body: BlocConsumer<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, state) {
            if (state is OTPVerifyingFailureState) {
              showDialogMessage(context, state.response ?? errorString);
            } else if (state is OTPVerifyingSuccessState) {
              if (!state.profileExists!) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              child: const Welcome(),
                              create: (context) => AuthBloc(),
                            )),
                    (route) => false);
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Home()),
                    (route) => false);
              }
            }
          },
          builder: (context, state) {
            return Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FlutterLogo(
                        size: 100,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Enter OTP',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'OTP sent to +91 $mobile',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        maxLength: 6,
                        controller: otpController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Please enter your OTP'),
                          LengthRangeValidator(
                              min: 6,
                              max: 6,
                              errorText:
                                  'OTP should be at least 6 digits long'),
                        ]),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter OTP',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      state is OTPVerifyingState
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  authBloc.add(AuthOTPSubmitEvent(
                                      requestId, otpController.text.trim()));
                                }
                              },
                              child: const Text('Verify'),
                            ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
