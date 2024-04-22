import 'package:flutter/material.dart';

extension TextStyleContextExtension on BuildContext {
  TextStyle get titleStyle => Theme.of(this).textTheme.titleLarge!;
  TextStyle get largeStyle => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get mediumStyle => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get smallStyle => Theme.of(this).textTheme.bodySmall!;
}
