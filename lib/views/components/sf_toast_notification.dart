import 'package:flutter/material.dart';
import 'package:smart_farm/utils/spacing.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showToast(
    String message, BuildContext context,
    {SnackBarAction? action, Status status = Status.info}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: getBgColor(status, context),
      content: Row(
        children: [
          // icon
          Icon(
            getIconForStatus(status, context),
            color: getTextColor(status, context),
          ),
          AppWidthSpacing.small,

          // message
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: getTextColor(status, context)),
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 4),
      action: action,
    ),
  );
}

// bg color
Color getBgColor(
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

// text color
Color getTextColor(
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

// icon
IconData getIconForStatus(
  Status status,
  BuildContext context,
) {
  switch (status) {
    case Status.success:
      return Icons.check_circle;
    case Status.error:
      return Icons.error;
    case Status.warning:
      return Icons.warning_amber_rounded;
    case Status.info:
      return Icons.info;
  }
}

enum Status {
  success,
  error,
  warning,
  info,
}
