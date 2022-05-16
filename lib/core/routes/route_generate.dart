import 'package:bloom/features/auth/presentation/bloc/app/app_bloc.dart';
import 'package:bloom/features/auth/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import '../../features/home/pages/main_page.dart';

List<Page> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [MainPage.page()];
    case AppStatus.unauthenticated:
      return [OnboardingPage.page()];
  }
}
