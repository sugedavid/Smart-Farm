import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_farm/utils/assets.dart';
import 'package:smart_farm/utils/spacing.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({
    super.key,
    required this.title,
    this.text,
    required this.dropdownButton,
    required this.onImage,
    required this.onDetectorViewModeChanged,
  });

  final String title;
  final String? text;
  final Widget dropdownButton;
  final Function(InputImage inputImage) onImage;
  final Function()? onDetectorViewModeChanged;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;

  final _key = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _galleryBody(),

      // floating action button
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _key,
        type: ExpandableFabType.fan,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.white.withOpacity(0.7),
        ),
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.add),
          fabSize: ExpandableFabSize.regular,
        ),
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.image_rounded),
            onPressed: () {
              final state = _key.currentState;
              if (state != null) state.toggle();
              _getImage(ImageSource.gallery);
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.camera_alt_rounded),
            onPressed: () {
              final state = _key.currentState;
              if (state != null) state.toggle();
              _getImage(ImageSource.camera);
            },
          ),
        ],
      ),
    );
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      // title
      Text(
        widget.title,
        style: const TextStyle(fontSize: 20),
      ),

      AppSpacing.medium,
      // tf model dropdown
      widget.dropdownButton,

      // image
      _image != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                width: 400,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Image.file(_image!),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                // anim
                Lottie.asset(
                  AppAssets.leafScanAnim,
                  repeat: false,
                ),

                // desc
                const Text("Scan a plant leaf by tapping the ‘+’ icon.")
              ],
            ),

      // image info
      if (_image != null)
        Card.outlined(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_path == null ? '' : widget.text ?? ''),
          ),
        ),
    ]);
  }

  // get image from device
  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processFile(pickedFile.path);
    }
  }

  // process the image
  Future _processFile(String path) async {
    setState(() {
      _image = File(path);
    });
    _path = path;
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }
}
