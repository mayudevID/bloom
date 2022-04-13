import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../bloc/forgot_password/forgot_password_cubit.dart';
import '../bloc/login/login_cubit.dart';
import '../bloc/signup/signup_cubit.dart';

enum FormType { login, signup, forgotPassword }

class FormInput extends StatelessWidget {
  final String icon;
  final String hintText;
  final FormType formType;
  const FormInput({
    Key? key,
    required this.icon,
    required this.hintText,
    required this.formType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getWidth(30, context)),
      padding: const EdgeInsets.all(8),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: naturalBlack),
      ),
      child: Row(
        children: [
          Image.asset("assets/icons/$icon.png", width: 24),
          SizedBox(width: getWidth(8, context)),
          Expanded(
            child: (formType == FormType.login)
                ? BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (previous, current) =>
                        previous.email != current.email,
                    builder: (context, state) {
                      return TextFormField(
                        onChanged: (email) {
                          context.read<LoginCubit>().emailChanged(email);
                        },
                        style: textForm,
                        cursorColor: naturalBlack,
                        decoration: InputDecoration.collapsed(
                          hintText: hintText,
                          hintStyle: textForm.copyWith(color: greyDark),
                        ),
                      );
                    },
                  )
                : (formType == FormType.signup)
                    ? BlocBuilder<SignupCubit, SignupState>(
                        buildWhen: (previous, current) {
                          if (hintText == "Email") {
                            return previous.email != current.email;
                          } else {
                            return previous.name != current.name;
                          }
                        },
                        builder: (context, state) {
                          return TextFormField(
                            onChanged: (data) {
                              if (hintText == "Email") {
                                context.read<SignupCubit>().emailChanged(data);
                              } else {
                                context.read<SignupCubit>().nameChanged(data);
                              }
                            },
                            style: textForm,
                            cursorColor: naturalBlack,
                            decoration: InputDecoration.collapsed(
                              hintText: hintText,
                              hintStyle: textForm.copyWith(color: greyDark),
                            ),
                          );
                        },
                      )
                    : BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
                        buildWhen: (previous, current) {
                          return previous.email != current.email;
                        },
                        builder: (context, state) {
                          return TextFormField(
                            onChanged: (data) {
                              context
                                  .read<ForgotPasswordCubit>()
                                  .emailChanged(data);
                            },
                            style: textForm,
                            cursorColor: naturalBlack,
                            decoration: InputDecoration.collapsed(
                              hintText: hintText,
                              hintStyle: textForm.copyWith(color: greyDark),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
