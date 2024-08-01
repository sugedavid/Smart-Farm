import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class SFPrimaryButton extends StatefulWidget {
  final String text;
  final Future<void> Function() onPressed;
  final bool enable;
  final Color? backgroundColor;

  const SFPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enable = true,
    this.backgroundColor,
  });

  @override
  SFPrimaryButtonState createState() => SFPrimaryButtonState();
}

class SFPrimaryButtonState extends State<SFPrimaryButton> {
  bool isLoading = false;
  late Color bgColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bgColor = widget.backgroundColor ?? Theme.of(context).colorScheme.primary;

    void toggleLoading(bool value) {
      setState(() {
        isLoading = value;
      });
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading || !widget.enable
            ? null
            : () async {
                toggleLoading(true);
                await widget.onPressed();
                toggleLoading(false);
              },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: isLoading
              ? const CircularProgressIndicator(
                  color: AppColors.primaryColor,
                )
              : Text(
                  widget.text,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
        ),
      ),
    );
  }
}
