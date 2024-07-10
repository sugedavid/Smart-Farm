import 'package:flutter/material.dart';
import 'package:smart_farm/data/models/user.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.userData});

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hello World!'),
    );
  }
}
