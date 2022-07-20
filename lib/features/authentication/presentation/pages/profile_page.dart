import 'package:bloom/core/routes/route_name.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../../home/bloc/user/user_bloc.dart';
import '../../data/repositories/local_auth_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
        localUserDataRepository: context.read<LocalUserDataRepository>(),
      )..add(
          const UserRequested(),
        ),
      child: const ProfilePageContent(),
    );
  }
}

class ProfilePageContent extends StatelessWidget {
  const ProfilePageContent({Key? key}) : super(key: key);

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
                  onTap: () => Navigator.pop(context),
                  child: Image.asset("assets/icons/arrow_back.png", width: 24),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.5 - 48 - 59,
                  ),
                  child: Text(
                    "My Profile",
                    style: mainSubTitle,
                  ),
                ),
              ],
            ),
            SizedBox(height: getHeight(32, context)),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state.status == UserStatus.success) {
                  return CachedNetworkImage(
                    imageUrl: state.userData.photoURL.toString(),
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        width: 80.0,
                        height: 80.0,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: naturalBlack,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return const SizedBox(
                        width: 80.0,
                        height: 80.0,
                        child: Icon(Icons.error),
                      );
                    },
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    width: 80.0,
                    height: 80.0,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: naturalBlack,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: getHeight(8, context)),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return Text(
                  (state.status == UserStatus.success)
                      ? state.userData.name.toString()
                      : "User",
                  style: buttonSmall.copyWith(
                    fontSize: 14,
                  ),
                );
              },
            ),
            SizedBox(height: getHeight(8, context)),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(RouteName.EDITPROFILE);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: naturalBlack),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 20,
                width: 80,
                child: Center(
                  child: Text(
                    "Edit profile",
                    style: smallTextLink.copyWith(
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: getHeight(32, context)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<UserBloc, UserState>(
                      builder: (builder, state) {
                        return Text(
                          (state.status == UserStatus.success)
                              ? state.userData.habitStreak.toString()
                              : 0.toString(),
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    Text(
                      "Habit Streak",
                      style: smallTextLink.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(width: getWidth(24, context)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<UserBloc, UserState>(
                      builder: (builder, state) {
                        return Text(
                          (state.status == UserStatus.success)
                              ? state.userData.taskCompleted.toString()
                              : 0.toString(),
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                    Text(
                      "Task Completed",
                      style: smallTextLink.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                SizedBox(width: getWidth(24, context)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        BlocBuilder<UserBloc, UserState>(
                          builder: (builder, state) {
                            return Text(
                              (state.status == UserStatus.success)
                                  ? state.userData.totalFocus.toStringAsFixed(1)
                                  : 0.toString(),
                              style: const TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                        Column(
                          children: [
                            Text(
                              "h",
                              style: smallText.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "Total Focus",
                      style: smallTextLink.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: getHeight(24, context)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Progress",
                style: textForm.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: getHeight(8, context)),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(RouteName.TASKHISTORY);
              },
              child: Container(
                height: getHeight(48, context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: yellowLight,
                ),
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 16,
                  top: 12,
                  bottom: 12,
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/clipboard_select.png", width: 24),
                    SizedBox(width: getWidth(7, context)),
                    Expanded(child: Text("Task History", style: textParagraph)),
                    Image.asset("assets/icons/arrow_right.png", width: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: getHeight(8, context)),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: getHeight(48, context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: yellowLight,
                ),
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 16,
                  top: 12,
                  bottom: 12,
                ),
                child: Row(
                  children: [
                    Image.asset("assets/icons/calendar_select.png", width: 24),
                    SizedBox(width: getWidth(7, context)),
                    Expanded(
                      child: Text("Habit Statistic", style: textParagraph),
                    ),
                    Image.asset("assets/icons/arrow_right.png", width: 16),
                  ],
                ),
              ),
            ),
            SizedBox(height: getHeight(8, context)),
            Container(
              height: getHeight(48, context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: yellowLight,
              ),
              padding: const EdgeInsets.only(
                left: 12,
                right: 16,
                top: 12,
                bottom: 12,
              ),
              child: Row(
                children: [
                  Image.asset("assets/icons/timer_select.png", width: 24),
                  SizedBox(width: getWidth(7, context)),
                  Expanded(
                    child: Text("Timer Statistic", style: textParagraph),
                  ),
                  Image.asset("assets/icons/arrow_right.png", width: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
