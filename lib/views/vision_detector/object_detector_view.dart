import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:smart_farm/components/sf_dropdown_button.dart';

import 'detector_view.dart';
import 'painters/object_detector_painter.dart';

class ObjectDetectorView extends StatefulWidget {
  const ObjectDetectorView({super.key});

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
  int _option = 0;
  final _options = {
    'Default': '',
    'Object_custom': 'object_labeler.tflite',
    'Fruits': 'object_labeler_fruits.tflite',
    'Flowers': 'object_labeler_flowers.tflite',
    'Plants': 'lite-model_aiy_vision_classifier_plants_V1_3.tflite',
    // https://tfhub.dev/google/lite-model/aiy/vision/classifier/plants_V1/3
  };

  final _models = ['beans_model', 'plants_disease'];
  final modelController = TextEditingController();

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
    return Scaffold(
      body: Stack(children: [
        DetectorView(
          title: 'Plant Diagnosis',
          dropdownButton: SFDropdownButton(
            labelText: 'Model',
            list: _models,
            controller: modelController,
            onChanged: () {
              setState(() {
                _initializeDetector();
              });
            },
          ),
          customPaint: _customPaint,
          text: _text,
          onImage: _processImage,
          initialCameraLensDirection: _cameraLensDirection,
          onCameraLensDirectionChanged: (value) => _cameraLensDirection = value,
          onCameraFeedReady: _initializeDetector,
          initialDetectionMode: DetectorViewMode.values[_mode.index],
          onDetectorViewModeChanged: _onScreenModeChanged,
        ),
      ]),
    );
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
    var modelName =
        modelController.text.isNotEmpty ? modelController.text : _models.first;
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
      String text = '\nObjects found: ${objects.length}\n\n';
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
  }
}
