import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme.dart';

class MainPageController extends GetxController {
  var tabIndex = 0;

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        Get.defaultDialog(
          title: 'Allow Notifications',
          titleStyle: buttonSmall,
          middleText: 'Our app would like to send your notifications',
          middleTextStyle: buttonSmall.copyWith(fontWeight: FontWeight.w400),
          actions: [
            const SizedBox(width: 180),
            GestureDetector(
              onTap: () async {
                AwesomeNotifications().requestPermissionToSendNotifications();
                Get.back();
              },
              child: Container(
                width: 70,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    'Allow',
                    style: buttonSmall.copyWith(
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 120,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: naturalBlack,
                ),
                child: Center(
                  child: Text(
                    'Don\'t Allow',
                    style: buttonSmall.copyWith(
                      color: naturalWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
    });
  }

  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }
}
