import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:task/bloc/auth_bloc.dart';
import 'package:task/bloc/events/auth_events.dart';
import 'package:task/bloc/states/auth_states.dart';
import 'package:task/utils/strings.dart';
import 'package:task/utils/utils.dart';
import 'package:task/views/enter_otp/enter_otp.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final mobileController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    AuthBloc authBloc = AuthBloc();
    return Scaffold(
      appBar: AppBar(title: const Text('Enter your mobile')),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is OTPSendingSuccessState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          child: EnterOTP(
                              mobile: mobileController.text.trim(),
                              requestId: state.requestId ?? ''),
                          create: (context) => AuthBloc(),
                        )));
          } else if (state is OTPSendingFailureState) {
            showDialogMessage(context, state.response ?? errorString);
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FlutterLogo(
                    size: 100,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      const Text(
                        '+91',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: TextFormField(
                          controller: mobileController,
                          maxLength: 10,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'Please enter a mobile number'),
                            LengthRangeValidator(
                                min: 10,
                                max: 10,
                                errorText:
                                    'Mobile number should be at least 10 digits long'),
                          ]),
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              hintText: 'Enter your mobile number',
                              counterText: ''),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  state is OTPSendingState
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => {
                            if (formKey.currentState!.validate())
                              {
                                authBloc.add(AuthMobileSubmitEvent(
                                    mobileController.text.trim())),
                                formKey.currentState!.save()
                              }
                          },
                          child: const Text('Continue'),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
