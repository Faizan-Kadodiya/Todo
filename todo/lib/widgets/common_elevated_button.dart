import 'package:flutter/material.dart';
import 'package:todo/constants/color_constant.dart';
import 'package:todo/constants/helper.dart';

class CommonElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? buttonText;
  const CommonElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(
          Size(Helper().getDevicewidth(context), 46),
        ),
        backgroundColor: WidgetStateProperty.all(AppColor.primaryButtonColor),
      ),
      child: Text(
        buttonText ?? "",
        style: const TextStyle(color: AppColor.whiteColor),
      ),
    );
  }
}
