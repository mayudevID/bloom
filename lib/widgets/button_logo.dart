import 'package:flutter/material.dart';

import '../theme.dart';

class ButtonLogo extends StatelessWidget {
  final String platformLogo;
  const ButtonLogo({Key? key, required this.platformLogo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 52.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: greyDark),
      ),
      child: Center(
        child: (platformLogo == "-")
            ? SizedBox(
                width: 21.6,
                height: 21.6,
                child: CircularProgressIndicator(color: naturalBlack),
              )
            : Image.asset(
                "assets/icons/${platformLogo}_logo.png",
                width: 21.6,
                height: 21.6,
              ),
      ),
    );
  }
}
