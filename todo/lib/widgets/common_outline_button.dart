import 'package:flutter/material.dart';
import 'package:todo/constants/color_constant.dart';
import 'package:todo/constants/helper.dart';

class CommonOutlineButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? buttonText;
  const CommonOutlineButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(
          Size(Helper().getDevicewidth(context), 50),
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: AppColor.secondaryButtonColor, width: 0),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
      ),
      child: Text(
        buttonText ?? "",
        style: TextStyle(color: AppColor.secondaryButtonColor, fontSize: 16),
      ),
    );
  }
}
