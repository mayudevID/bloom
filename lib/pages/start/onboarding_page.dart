// ignore_for_file: must_be_immutable

import 'package:bloom/controllers/onboard_controller.dart';
import 'package:bloom/routes/route_name.dart';
import 'package:bloom/theme.dart';
import 'package:bloom/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({Key? key}) : super(key: key);
  final onboardController = Get.put(OnboardController());
  final CarouselController sliderController = CarouselController();

  final List<String> imageOnboard = [
    'assets/images/onboard1.png',
    'assets/images/onboard2.png',
    'assets/images/onboard3.png',
  ];

  @override
  Widget build(BuildContext context) {
    Widget indicator(int indexUpdate) {
      return Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: onboardController.currentIndex.value == indexUpdate
              ? naturalBlack
              : const Color(0xffE5E5E5),
        ),
      );
    }

    Widget nextButtonBottom() {
      return GestureDetector(
        onTap: () {
          Get.offNamed(RouteName.LOGIN);
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: getWidth(26)),
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: yellowDark,
          ),
          child: Center(
            child: Text(
              "Get Started",
              style: buttonLarge,
            ),
          ),
        ),
      );
    }

    Widget defaultBottom() {
      int indexIndicator = -1;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: getWidth(26)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Get.offNamed(RouteName.LOGIN);
              },
              child: Text(
                "Skip",
                style: buttonSmall,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageOnboard.map(
                (e) {
                  indexIndicator++;
                  return indicator(indexIndicator);
                },
              ).toList(),
            ),
            GestureDetector(
              onTap: () {
                sliderController.nextPage(
                  curve: Curves.fastOutSlowIn,
                  duration: const Duration(milliseconds: 500),
                );
              },
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: yellowDark,
                ),
                child: Center(
                  child: Image.asset(
                    "assets/icons/arrow_onboard.png",
                    width: 24,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: naturalWhite,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: Get.height * 0.25),
            CarouselSlider(
              carouselController: sliderController,
              items: imageOnboard.map((e) {
                return Image.asset(
                  e,
                  height: getHeight(321),
                  fit: BoxFit.fill,
                );
              }).toList(),
              options: CarouselOptions(
                initialPage: 0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  onboardController.changeSlide(index);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: getWidth(45),
              ),
              child: Obx(() {
                return Text(
                  onboardController.title[onboardController.currentIndex.value],
                  style: mainSubTitle,
                  textAlign: TextAlign.center,
                );
              }),
            ),
            SizedBox(height: getHeight(8)),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: getWidth(60),
              ),
              child: Obx(() {
                return Text(
                  onboardController
                      .description[onboardController.currentIndex.value],
                  style: textParagraph,
                  textAlign: TextAlign.center,
                );
              }),
            ),
            const Spacer(),
            Obx(() {
              return (onboardController.currentIndex.value == 2)
                  ? nextButtonBottom()
                  : defaultBottom();
            }),
            SizedBox(height: getHeight(40)),
          ],
        ),
      ),
    );
  }
}
