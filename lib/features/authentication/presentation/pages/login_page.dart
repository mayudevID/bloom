// ignore_for_file: must_be_immutable
import 'package:bloom/core/routes/route_name.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/function.dart';
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
              SizedBox(height: getHeight(88, context)),
              Image.asset("assets/icons/logo.png",
                  width: getWidth(100, context)),
              Text("Login", style: mainTitle),
              SizedBox(height: getHeight(32, context)),
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

                  // showDialog(
                  //   context: context,
                  //   barrierDismissible: false,
                  //   builder: (context) {
                  //     return AlertDialog(
                  //       insetPadding: const EdgeInsets.only(
                  //         left: 120,
                  //         right: 120,
                  //       ),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(20.0),
                  //       ),
                  //       content: SizedBox(
                  //         height: 100,
                  //         child: Center(
                  //           child: SizedBox(
                  //             width: 50,
                  //             height: 50,
                  //             child: CircularProgressIndicator(
                  //               color: naturalBlack,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // );
                },
                child: Column(
                  children: [
                    const FormInput(
                      formType: FormType.login,
                      hintText: 'Email',
                      icon: 'mail',
                    ),
                    SizedBox(height: getHeight(8, context)),
                    const FormInputPassword(formType: FormType.login),
                  ],
                ),
              ),
              SizedBox(height: getHeight(9, context)),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: getWidth(30, context)),
                  child: GestureDetector(
                    onTap: () {
                      // Get.toNamed(RouteName.FORGETPASS);
                    },
                    child: Text("Forgot Password?", style: smallTextLink),
                  ),
                ),
              ),
              SizedBox(height: getHeight(32, context)),
              GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  context
                      .read<LoginCubit>()
                      .loginWithCredentials(LoginType.email);
                },
                child: Container(
                  height: getHeight(56, context),
                  margin: EdgeInsets.symmetric(
                    horizontal: getWidth(30, context),
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
                            child:
                                CircularProgressIndicator(color: naturalBlack),
                          ),
                          SizedBox(
                            width: getWidth(15, context),
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
              SizedBox(height: getHeight(23, context)),
              Text("Or login with", style: smallText),
              SizedBox(height: getHeight(18, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const ButtonLogo(platformLogo: 'fb'),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context
                          .read<LoginCubit>()
                          .loginWithCredentials(LoginType.fb);
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
                  SizedBox(width: getWidth(28.8, context)),
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
              SizedBox(height: getHeight(40, context)),
            ],
          ),
        ),
      ),
    );
  }
}
