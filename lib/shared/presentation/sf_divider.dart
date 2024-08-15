import 'package:flutter/material.dart';

class SFDivider extends StatelessWidget {
  const SFDivider({super.key, this.indent = 0.0});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.black12,
      height: 0.5,
      thickness: 0.5,
      indent: indent,
      endIndent: 0,
    );
  }
}
