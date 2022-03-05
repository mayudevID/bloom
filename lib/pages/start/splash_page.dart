import 'package:bloom/theme.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellowLight,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/logo.png',
              width: 125,
            ),
            Text(
              "Bloom",
              style: mainBrandName,
            ),
            Text(
              "Your productivity tool in one app",
              style: smallText.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
