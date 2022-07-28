import 'package:flutter/material.dart';

import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';

class ExitEditProfileDialog extends StatelessWidget {
  const ExitEditProfileDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Profile changed, Exit anyway?",
            style: buttonSmall.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: getHeight(10, context)),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context)
                    ..pop()
                    ..pop();
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
                      'Exit',
                      style: buttonSmall.copyWith(
                        color: naturalWhite,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: getWidth(10, context)),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
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
                      'Cancel',
                      style: buttonSmall.copyWith(
                        color: naturalWhite,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
