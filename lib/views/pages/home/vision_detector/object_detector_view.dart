import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:smart_farm/data/helper/settings_manager.dart';
import 'package:smart_farm/data/models/user.dart';
import 'package:smart_farm/data/service/analytics_service.dart';
import 'package:smart_farm/data/service/performance_service.dart';

import 'detector_view.dart';
import 'painters/object_detector_painter.dart';

class ObjectDetectorView extends StatefulWidget {
  const ObjectDetectorView({super.key, required this.userData});

  final UserModel userData;

  @override
  State<ObjectDetectorView> createState() => _ObjectDetectorView();
}

class _ObjectDetectorView extends State<ObjectDetectorView> {
  ObjectDetector? _objectDetector;
  DetectionMode _mode = DetectionMode.single;
  bool _canProcess = false;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  final SettingsManager _settingsManager = SettingsManager();

  String getGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) {
      return 'Good morning ${widget.userData.firstName},';
    } else if (hour < 17) {
      return 'Good afternoon ${widget.userData.firstName},';
    } else {
      return 'Good evening ${widget.userData.firstName},';
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeDetector();
  }

  @override
  void dispose() {
    _canProcess = false;
    _objectDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      DetectorView(
        title: getGreeting(),
        customPaint: _customPaint,
        text: _text,
        onImage: _processImage,
        initialCameraLensDirection: _cameraLensDirection,
        onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
        onCameraFeedReady: _initializeDetector,
        initialDetectionMode: DetectorViewMode.values[_mode.index],
        onDetectorViewModeChanged: _onScreenModeChanged,
      ),
    ]);
  }

  // handle screen mode change
  void _onScreenModeChanged(DetectorViewMode mode) {
    switch (mode) {
      case DetectorViewMode.gallery:
        _mode = DetectionMode.single;
        _initializeDetector();
        return;

      case DetectorViewMode.liveFeed:
        _mode = DetectionMode.stream;
        _initializeDetector();
        return;
    }
  }

  // initialize the detector
  void _initializeDetector() async {
    _objectDetector?.close();
    _objectDetector = null;
    debugPrint('Set detector in mode: $_mode');

    // use a remote model
    var modelName = await _settingsManager.getMlModel();
    final response =
        await FirebaseObjectDetectorModelManager().downloadModel(modelName);
    debugPrint('Downloaded: $response');
    final options = FirebaseObjectDetectorOptions(
      mode: _mode,
      modelName: modelName,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);

    _canProcess = true;
  }

  // process the image
  Future<void> _processImage(InputImage inputImage) async {
    if (_objectDetector == null) return;
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    await PerformanceService().diagnosisTrace.start();
    var startTime = DateTime.now();

    final objects = await _objectDetector!.processImage(inputImage);
    debugPrint('Objects found: ${objects.length}\n\n');
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = ObjectDetectorPainter(
        objects,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text =
          objects.isNotEmpty ? '\nObjects found: ${objects.length}\n\n' : '';
      for (final object in objects) {
        text +=
            '${objects.indexOf(object) + 1}. ${object.labels.map((e) => '${e.text}: ${e.confidence}')}\n\n';
      }
      String processedText = text.replaceAll(RegExp(r'[()]'), '');
      _text = processedText;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }

    await PerformanceService().diagnosisTrace.stop();
    var endTime = DateTime.now();
    var duration = endTime.difference(startTime).inMilliseconds;
    await AnalyticsService().logEvent(AnalyticsService().diagnosisEvent,
        AnalyticsService().diagnosisModel, duration);
  }
}
