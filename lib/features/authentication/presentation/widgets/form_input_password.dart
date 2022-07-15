// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../bloc/login/login_cubit.dart';
import '../bloc/signup/signup_cubit.dart';
import 'form_input.dart';

class FormInputPassword extends StatelessWidget {
  final FormType formType;
  const FormInputPassword({Key? key, required this.formType}) : super(key: key);

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
          Image.asset("assets/icons/lock.png", width: 24),
          SizedBox(width: getWidth(8, context)),
          Expanded(
            child: (formType == FormType.login)
                ? BlocBuilder<LoginCubit, LoginState>(
                    buildWhen: (previous, current) {
                      return previous.password != current.password ||
                          previous.isHidden != current.isHidden;
                    },
                    builder: (context, state) {
                      return TextFormField(
                        onChanged: (password) {
                          context.read<LoginCubit>().passwordChanged(password);
                        },
                        style: textForm,
                        cursorColor: naturalBlack,
                        obscureText: (state.isHidden ? true : false),
                        decoration: InputDecoration.collapsed(
                          hintText: "Password",
                          hintStyle: textForm.copyWith(color: greyDark),
                        ),
                      );
                    },
                  )
                : BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) {
                      return previous.password != current.password ||
                          previous.isHidden != current.isHidden;
                    },
                    builder: (context, state) {
                      return TextFormField(
                        onChanged: (password) {
                          context.read<SignupCubit>().passwordChanged(password);
                        },
                        style: textForm,
                        cursorColor: naturalBlack,
                        obscureText: (state.isHidden ? true : false),
                        decoration: InputDecoration.collapsed(
                          hintText: "Password",
                          hintStyle: textForm.copyWith(color: greyDark),
                        ),
                      );
                    },
                  ),
          ),
          (formType == FormType.login)
              ? BlocBuilder<LoginCubit, LoginState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        context.read<LoginCubit>().hidePassword();
                      },
                      child: state.isHidden
                          ? Image.asset("assets/icons/eye_show.png")
                          : Image.asset("assets/icons/eye_hide.png"),
                    );
                  },
                )
              : BlocBuilder<SignupCubit, SignupState>(
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        context.read<SignupCubit>().hidePassword();
                      },
                      child: state.isHidden
                          ? Image.asset("assets/icons/eye_show.png")
                          : Image.asset("assets/icons/eye_hide.png"),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
