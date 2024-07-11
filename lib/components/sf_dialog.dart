import 'package:flutter/material.dart';

class SFDialog {
  static Future<bool> showSFDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    String? cancelText,
    String? okText,
    Function()? onCancel,
    Function()? onOk,
  }) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          if (onCancel != null)
            TextButton(
              onPressed: onCancel,
              child: Text(cancelText ?? "Cancel"),
            ),
          TextButton(
            onPressed: onOk,
            child: Text(okText ?? "OK"),
          ),
        ],
      ),
    );
  }
}
