import 'package:flutter/material.dart';

// large screen
bool isLargeScreen(BuildContext context) {
  final screenSizeInches = MediaQuery.of(context).size.shortestSide /
      MediaQuery.of(context).devicePixelRatio;
  return screenSizeInches > 200;
}
