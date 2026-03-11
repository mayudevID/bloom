// ignore_for_file: must_be_immutable
import '../../../../core/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/theme.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/local_auth_repository.dart';
import '../bloc/login/login_cubit.dart';
import '../widgets/button_logo.dart';
import '../widgets/form_input.dart';
import '../widgets/form_input_password.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        context.read<AuthRepository>(),
        context.read<LocalUserDataRepository>(),
      ),
      child: const LoginPageContent(),
    );
  }
}

class LoginPageContent extends StatelessWidget {
  const LoginPageContent({Key? key}) : super(key: key);

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
              Image.asset("assets/icons/logo.png", width: 100),
              Text("Login", style: mainTitle),
              const SizedBox(height: 32),
              BlocListener<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.status == LoginStatus.error) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage),
                        ),
                      );
                  } else if (state.status == LoginStatus.success) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      RouteName.MAIN,
                      (route) => false,
                      arguments: true,
                    );
                  }
                },
                child: const Column(
                  children: [
                    FormInput(
                      formType: FormType.login,
                      hintText: 'Email',
                      icon: 'mail',
                    ),
                    SizedBox(height: 8),
                    FormInputPassword(formType: FormType.login),
                  ],
                ),
              ),
              const SizedBox(height: 9),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(RouteName.FORGETPASS);
                    },
                    child: Text("Forgot Password?", style: smallTextLink),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context
                      .read<LoginCubit>()
                      .loginWithCredentials(LoginType.email);
                },
                child: Container(
                  height: 56,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  decoration: BoxDecoration(
                    color: yellowDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                    if (state.status == LoginStatus.submitting &&
                        state.type == LoginType.email) {
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
                        child: Text("Login", style: buttonLarge),
                      );
                    }
                  }),
                ),
              ),
              const SizedBox(height: 23),
              Text("Or login with", style: smallText),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      // context
                      //     .read<LoginCubit>()
                      //     .loginWithCredentials(LoginType.fb);
                    },
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state.status == LoginStatus.submitting &&
                            state.type == LoginType.fb) {
                          return const ButtonLogo(type: ButtonType.none);
                        } else {
                          return const ButtonLogo(type: ButtonType.fb);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 28.8),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context
                          .read<LoginCubit>()
                          .loginWithCredentials(LoginType.google);
                    },
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        if (state.status == LoginStatus.submitting &&
                            state.type == LoginType.google) {
                          return const ButtonLogo(type: ButtonType.none);
                        } else {
                          return const ButtonLogo(type: ButtonType.google);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: smallText),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(RouteName.REGISTER);
                    },
                    child: Text(
                      "Create Account",
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
