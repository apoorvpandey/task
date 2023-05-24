import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:task/bloc/auth_bloc.dart';
import 'package:task/bloc/events/auth_events.dart';
import 'package:task/bloc/states/auth_states.dart';
import 'package:task/utils/strings.dart';
import 'package:task/utils/utils.dart';
import 'package:task/views/home/home.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    AuthBloc authBloc = AuthBloc();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is ProfileSubmittingFailureState) {
            showDialogMessage(context, state.response ?? errorString);
          } else if (state is ProfileSubmittingSuccessState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Home()),
                (route) => false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Looks like you are new here. Tell us a bit about yourself.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please provide your name'),
                        PatternValidator(r'^[a-zA-Z]',
                            errorText: 'Please provide a valid input')
                      ]),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                      ),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Please enter an Email Address'),
                        EmailValidator(
                            errorText: 'Please enter a valid Email Address'),
                      ]),
                    ),
                    const SizedBox(height: 8),
                    state is ProfileSubmittingState
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => {
                              if (formKey.currentState!.validate())
                                {
                                  authBloc.add(AuthProfileSubmitEvent(
                                      nameController.text.trim(),
                                      emailController.text.trim()))
                                }
                            },
                            child: const Text('Submit'),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
