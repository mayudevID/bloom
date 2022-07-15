import 'package:flutter/material.dart';
import '../../../../core/utils/theme.dart';

enum ButtonType { fb, google, none }

class ButtonLogo extends StatelessWidget {
  final ButtonType type;
  const ButtonLogo({Key? key, required this.type}) : super(key: key);

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
        child: (type == ButtonType.none)
            ? SizedBox(
                width: 21.6,
                height: 21.6,
                child: CircularProgressIndicator(color: naturalBlack),
              )
            : (type == ButtonType.google)
                ? Image.asset(
                    "assets/icons/google_logo.png",
                    width: 21.6,
                    height: 21.6,
                  )
                : Image.asset(
                    "assets/icons/fb_logo.png",
                    width: 21.6,
                    height: 21.6,
                  ),
      ),
    );
  }
}
