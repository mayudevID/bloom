// ignore_for_file: must_be_immutable

import 'package:bloom/features/auth/presentation/bloc/onboard/onboard_bloc.dart';
import 'package:bloom/features/auth/presentation/pages/login_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';
import '../../../../injection_container.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({Key? key}) : super(key: key);
  final CarouselController sliderController = CarouselController();

  final List<String> imageOnboard = [
    'assets/images/onboard1.png',
    'assets/images/onboard2.png',
    'assets/images/onboard3.png',
  ];

  final List<String> title = [
    "Plan your day and become a better you",
    "Stay focus and motivated",
    "Reach your goals",
  ];

  final List<String> description = [
    "Plan and organize your life to archive your strengths, challenges and goals",
    "Stay focus while we track your day to motivated you to reach your goals",
    "It's now or never. There's nothing better than achieving your goals, whatever they might be",
  ];

  static Page page() => MaterialPage<void>(child: OnboardingPage());

  @override
  Widget build(BuildContext context) {
    Widget indicator(int indexPos, int newIndex) {
      return Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.symmetric(
          horizontal: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: newIndex == indexPos ? naturalBlack : const Color(0xffE5E5E5),
        ),
      );
    }

    Widget nextButtonBottom() {
      return GestureDetector(
        onTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            LoginPage.route(),
            (route) => false,
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: getWidth(26, context)),
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

    Widget defaultBottom(int newIndex) {
      int indexIndicator = -1;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: getWidth(26, context)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                // Get.offNamed(RouteName.LOGIN);
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
                  return indicator(indexIndicator, newIndex);
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

    return BlocProvider(
      create: (context) => sl<OnboardBloc>(),
      child: Scaffold(
        backgroundColor: naturalWhite,
        body: Center(
          child: Column(
            children: [
              // SizedBox(height: Get.height * 0.25),
              CarouselSlider(
                carouselController: sliderController,
                items: imageOnboard.map((e) {
                  return Image.asset(
                    e,
                    height: getHeight(321, context),
                    fit: BoxFit.fill,
                  );
                }).toList(),
                options: CarouselOptions(
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    context.read<OnboardBloc>().add(ChangeSlide(index));
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: getWidth(45, context),
                ),
                child: BlocBuilder<OnboardBloc, OnboardState>(
                  builder: (context, state) {
                    return Text(
                      title[state.index],
                      style: mainSubTitle,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
              SizedBox(height: getHeight(8, context)),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: getWidth(60, context),
                ),
                child: BlocBuilder<OnboardBloc, OnboardState>(
                  builder: (context, state) {
                    return Text(
                      description[state.index],
                      style: mainSubTitle,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
              const Spacer(),
              BlocBuilder<OnboardBloc, OnboardState>(
                builder: (context, state) {
                  if (state.index == 2) {
                    return nextButtonBottom();
                  } else {
                    return defaultBottom(state.index);
                  }
                },
              ),
              SizedBox(height: getHeight(40, context)),
            ],
          ),
        ),
      ),
    );
  }
}
