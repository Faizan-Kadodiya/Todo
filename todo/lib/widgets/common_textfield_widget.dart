import 'package:todo/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  final Color? cursorColor;
  final double? cursorWidth;
  final TextStyle? styleOfWritingText;
  final String? hintText;
  final Widget? label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int? maxLines;
  final bool? readOnly;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final AutovalidateMode? autovalidateMode;
  final Widget? suffixIcon;
  final Widget? suffix;
  final bool? autofocus;

  const AppTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.cursorColor,
    this.cursorWidth,
    this.styleOfWritingText,
    this.hintText,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
    this.maxLines,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onFieldSubmitted,
    this.readOnly,
    this.obscureText,
    this.textCapitalization,
    this.textInputAction,
    this.validator,
    this.label,
    this.autovalidateMode,
    this.suffixIcon,
    this.suffix,
    this.autofocus,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      maxLength: maxLength,
      maxLines: maxLines,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      autovalidateMode: autovalidateMode,
      inputFormatters: inputFormatters,
      cursorColor: cursorColor ?? AppColor.blackColor,
      cursorWidth: cursorWidth ?? 1,
      autofocus: autofocus ?? false,
      style:
          styleOfWritingText ??
          const TextStyle(
            fontSize: 16,
            color: AppColor.blackColor,
            fontWeight: FontWeight.w400,
          ),
      decoration: InputDecoration(
        suffix: suffixIcon,
        hintText: hintText ?? '',
        label: label,
        counter: const SizedBox(),
      ),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      onTap: onTap,
      onEditingComplete: onEditingComplete,
    );
  }
}
