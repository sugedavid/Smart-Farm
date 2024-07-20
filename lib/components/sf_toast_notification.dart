import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
    String message, BuildContext context,
    {SnackBarAction? action, Status status = Status.info}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: getColorForStatus(status, context),
      content: Text(
        message,
        style: TextStyle(color: getTextColorForStatus(status, context)),
      ),
      duration: const Duration(seconds: 4),
      action: action,
    ),
  );
}

Color getColorForStatus(
  Status status,
  BuildContext context,
) {
  switch (status) {
    case Status.success:
      return Colors.green.shade50;
    case Status.error:
      return Colors.red.shade50;
    case Status.warning:
      return Colors.orange.shade50;
    case Status.info:
      return Colors.blue.shade50;
  }
}

Color getTextColorForStatus(
  Status status,
  BuildContext context,
) {
  switch (status) {
    case Status.success:
      return Colors.green;
    case Status.error:
      return Colors.red;
    case Status.warning:
      return Colors.orange;
    case Status.info:
      return Colors.blue;
  }
}

enum Status {
  success,
  error,
  warning,
  info,
}
