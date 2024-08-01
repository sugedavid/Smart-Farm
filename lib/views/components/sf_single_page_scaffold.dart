import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_farm/utils/responsiveness.dart';

class SFSinglePageScaffold extends StatefulWidget {
  const SFSinglePageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final List<Widget>? actions;
  final Widget child;
  final Widget? floatingActionButton;

  @override
  State<SFSinglePageScaffold> createState() => _SFSinglePageScaffoldState();
}

class _SFSinglePageScaffoldState extends State<SFSinglePageScaffold>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.w400),
        ),
        actions: widget.actions,
      ),
      body: Container(
        alignment: kIsWeb && isLargeScreen(context) ? Alignment.center : null,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: SizedBox(
              width: kIsWeb ? 400 : null,
              child: widget.child,
            ),
          ),
        ),
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
