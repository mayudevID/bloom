// ignore_for_file: must_be_immutable

import 'package:bloom/features/auth/presentation/bloc/forgot_password/forgot_password_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../../../injection_container.dart';
import '../../data/auth_repository.dart';
import '../widgets/form_input.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ForgotPasswordCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: naturalWhite,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.11),
              Image.asset("assets/icons/logo.png", width: 100),
              Text("Forgot Password", style: mainTitle),
              SizedBox(height: getHeight(8, context)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Enter your registered email so we can send you a link to reset password",
                  style: smallText,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: getHeight(18, context)),
              BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state.status == SendStatus.error) {}
                },
                child: const FormInput(
                  formType: FormType.forgotPassword,
                  icon: 'mail',
                  hintText: 'Email',
                ),
              ),
              SizedBox(height: getHeight(24, context)),
              GestureDetector(
                onTap: () async {
                  context
                      .read<ForgotPasswordCubit>()
                      .sendRequestForgotPassword();
                },
                child: Container(
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: yellowDark,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                    builder: (context, state) {
                      if (state.status == SendStatus.submitting) {
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
                          child: Text(
                            "Send",
                            style: buttonLarge,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
