// ignore_for_file: must_be_immutable
import 'package:bloom/features/auth/presentation/bloc/signup/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../../../injection_container.dart';
import '../../data/auth_repository.dart';
import '../widgets/button_logo.dart';
import '../widgets/form_input.dart';
import '../widgets/form_input_password.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SignupCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: naturalWhite,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: getHeight(88, context)),
              Image.asset("assets/icons/logo.png",
                  width: getWidth(100, context)),
              Text("Create Account", style: mainTitle),
              SizedBox(height: getHeight(32, context)),
              BlocListener<SignupCubit, SignupState>(
                listener: (context, state) {
                  if (state.status == SignupStatus.error) {}
                },
                child: Column(
                  children: [
                    const FormInput(
                      formType: FormType.signup,
                      hintText: 'Name',
                      icon: 'person',
                    ),
                    SizedBox(height: getHeight(8, context)),
                    const FormInput(
                      formType: FormType.signup,
                      hintText: 'Email',
                      icon: 'mail',
                    ),
                    SizedBox(height: getHeight(8, context)),
                    const FormInputPassword(formType: FormType.signup),
                  ],
                ),
              ),
              SizedBox(height: getHeight(32, context)),
              GestureDetector(
                onTap: () {
                  context
                      .read<SignupCubit>()
                      .signupWithCredentials(SignupType.email);
                },
                child: Container(
                  height: getHeight(56, context),
                  margin:
                      EdgeInsets.symmetric(horizontal: getWidth(30, context)),
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
                        child: Text("Create Account", style: buttonLarge),
                      );
                    }
                  }),
                ),
              ),
              SizedBox(height: getHeight(23, context)),
              Text("Or Create new account with", style: smallText),
              SizedBox(height: getHeight(18, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const ButtonLogo(platformLogo: 'fb'),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<SignupCubit>()
                          .signupWithCredentials(SignupType.fb);
                    },
                    child: BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        if (state.status == SignupStatus.submitting &&
                            state.type == SignupType.fb) {
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
                          return const ButtonLogo(type: ButtonType.fb);
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
                  Text("Already have an account? ", style: smallText),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login",
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
