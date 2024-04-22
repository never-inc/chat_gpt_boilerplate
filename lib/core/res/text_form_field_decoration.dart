import 'package:flutter/material.dart';

import '../../../core/res/text_styles.dart';
import '../../core/extensions/context_extension.dart';
import 'colors.dart';

class TextFormFieldDecoration {
  TextFormFieldDecoration._();

  static InputDecoration input(
    BuildContext context, {
    String? labelText,
    String? hintText,
    Widget? suffixIcon,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.4),
      ),
    );
    final fillColor = context.isDark ? Colors.black : Colors.white;
    return InputDecoration(
      suffixIcon: suffixIcon,
      suffixIconColor: Colors.grey,
      labelText: labelText,
      labelStyle: context.mediumStyle.copyWith(
        color: Colors.grey,
      ),
      hintText: hintText,
      hintStyle: context.mediumStyle.copyWith(
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 8,
      ),
      border: border,
      focusedBorder: border,
      enabledBorder: border,
      filled: true,
      fillColor: fillColor,
    );
  }

  static InputDecoration textMessage(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: context.isDark
            ? Colors.grey[850] ?? Colors.transparent
            : ColorNames.lightGrey2,
      ),
      borderRadius: BorderRadius.circular(24),
    );

    final fillColor =
        context.isDark ? ColorNames.black1 : ColorNames.lightGrey1;

    return InputDecoration(
      isDense: true,
      hintText: 'Aa',
      hintStyle: context.mediumStyle.copyWith(
        color: Colors.grey,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      border: border,
      focusedBorder: border,
      enabledBorder: border,
      fillColor: fillColor,
      filled: true,
      counterText: '',
    );
  }
}
