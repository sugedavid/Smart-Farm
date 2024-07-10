import 'package:flutter/material.dart';

import '../utils/colors.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
    String message, BuildContext context,
    {SnackBarAction? action, Status status = Status.info}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: getColorForStatus(status),
      content: Text(message),
      duration: const Duration(seconds: 4),
      action: action,
    ),
  );
}

Color getColorForStatus(Status status) {
  switch (status) {
    case Status.success:
      return Colors.green.shade600;
    case Status.error:
      return Colors.red;
    case Status.warning:
      return Colors.orange;
    case Status.info:
      return AppColors.primaryColor;
  }
}

enum Status {
  success,
  error,
  warning,
  info,
}
