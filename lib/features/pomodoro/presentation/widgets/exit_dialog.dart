import 'package:flutter/material.dart';
import '../../../../core/utils/function.dart';
import '../../../../core/utils/theme.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Timer is running or session is in progress, Continue?",
              style: buttonSmall.copyWith(fontWeight: FontWeight.w400),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                SizedBox(width: getWidth(90, context)),
                GestureDetector(
                  onTap: () {
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
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
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
            )
          ],
        ),
      ),
    );
  }
}
