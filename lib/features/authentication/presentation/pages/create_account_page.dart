// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/route_name.dart';
import '../../../../core/utils/theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/local_auth_repository.dart';
import '../bloc/signup/signup_cubit.dart';
import '../widgets/button_logo.dart';
import '../widgets/form_input.dart';
import '../widgets/form_input_password.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(
        context.read<AuthRepository>(),
        context.read<LocalUserDataRepository>(),
      ),
      child: const CreateAccountPageContent(),
    );
  }
}

class CreateAccountPageContent extends StatelessWidget {
  const CreateAccountPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: naturalWhite,
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 88),
              Image.asset(
                "assets/icons/logo.png",
                width: 100,
              ),
              Text("Create Account", style: mainTitle),
              const SizedBox(height: 32),
              BlocListener<SignupCubit, SignupState>(
                listener: (context, state) {
                  if (state.status == SignupStatus.error) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage),
                        ),
                      );
                  } else if (state.status == SignupStatus.success) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.MAIN,
                      (route) => false,
                      arguments:
                          (state.type != SignupType.email) ? true : false,
                    );
                  }
                },
                child: const Column(
                  children: [
                    FormInput(
                      formType: FormType.signup,
                      hintText: 'Name',
                      icon: 'person',
                    ),
                    SizedBox(height: 8),
                    FormInput(
                      formType: FormType.signup,
                      hintText: 'Email',
                      icon: 'mail',
                    ),
                    SizedBox(height: 8),
                    FormInputPassword(formType: FormType.signup),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context
                      .read<SignupCubit>()
                      .signupWithCredentials(SignupType.email);
                },
                child: Container(
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: yellowDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                      if (state.status == SignupStatus.submitting &&
                          state.type == SignupType.email) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                color: naturalBlack,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text("Loading", style: buttonLarge),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text("Create Account", style: buttonLarge),
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 23),
              Text("Or Create new account with", style: smallText),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context
                      .read<SignupCubit>()
                      .signupWithCredentials(SignupType.google);
                },
                child: BlocBuilder<SignupCubit, SignupState>(
                  builder: (context, state) {
                    if (state.status == SignupStatus.submitting &&
                        state.type == SignupType.google) {
                      return const ButtonLogo(type: ButtonType.none);
                    } else {
                      return const ButtonLogo(type: ButtonType.google);
                    }
                  },
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: smallText),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Login",
                      style: smallText.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
