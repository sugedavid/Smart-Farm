import 'package:flutter/material.dart';
import 'package:smart_farm/core/data/models/user.dart';
import 'package:smart_farm/presentation/home/vision_detector/object_detector_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.userData});

  final UserModel userData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ObjectDetectorView(
        userData: userData,
      ),
    );
  }
}
