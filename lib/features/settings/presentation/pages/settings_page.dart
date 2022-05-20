import 'package:bloom/features/settings/presentation/bloc/logout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: naturalWhite,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.07),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset("assets/icons/arrow_back.png", width: 24),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.5 - 48 - 50,
                  ),
                  child: Text(
                    "Settings",
                    style: mainSubTitle,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(51, context)),
            GestureDetector(
              onTap: () {
                // if (!authController.isLoading.value) {
                //   _handleSignOut();
                // }
              },
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: redLight,
                ),
                child: BlocBuilder<LogoutCubit, LogoutState>(
                    builder: (context, state) {
                  if (state.status == LogoutStatus.initial) {
                    return Center(
                      child: Text(
                        "Logout",
                        style: buttonSmall.copyWith(
                          color: naturalWhite,
                        ),
                      ),
                    );
                  } else if (state.status == LogoutStatus.processing) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: naturalWhite),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Loading",
                          style: buttonSmall.copyWith(
                            color: naturalWhite,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text(
                      "Loading",
                      style: buttonSmall.copyWith(
                        color: naturalWhite,
                      ),
                    );
                  }
                }),
                // child: Obx(() {
                //   if (!authController.isLoading.value) {
                //     return Center(
                //       child: Text(
                //         "Logout",
                //         style: buttonSmall.copyWith(
                //           color: naturalWhite,
                //         ),
                //       ),
                //     );
                //   } else {
                //     return Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         SizedBox(
                //           width: 22,
                //           height: 22,
                //           child: CircularProgressIndicator(color: naturalWhite),
                //         ),
                //         const SizedBox(
                //           width: 15,
                //         ),
                //         Text(
                //           "Loading",
                //           style: buttonSmall.copyWith(
                //             color: naturalWhite,
                //           ),
                //         ),
                //       ],
                //     );
                //   }
                // }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
