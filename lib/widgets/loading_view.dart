import 'package:bloom/theme.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 45,
            height: 45,
            child: CircularProgressIndicator(color: naturalBlack),
          ),
        ),
      ),
    );
  }
}
