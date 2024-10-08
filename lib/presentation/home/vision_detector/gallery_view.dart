import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_farm/core/data/models/diagnosis.dart';
import 'package:smart_farm/core/data/models/user.dart';
import 'package:smart_farm/core/helper/diagnosis_manager.dart';
import 'package:smart_farm/core/helper/settings_manager.dart';
import 'package:smart_farm/core/utils/assets.dart';
import 'package:smart_farm/core/utils/firebase/user_utils.dart';
import 'package:smart_farm/core/utils/spacing.dart';
import 'package:smart_farm/presentation/ai/analysis_page.dart';
import 'package:smart_farm/shared/presentation/sf_main_scaffold.dart';
import 'package:smart_farm/shared/presentation/sf_toast_notification.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({
    super.key,
    required this.title,
    this.text,
    required this.onImage,
    required this.onDetectorViewModeChanged,
  });

  final String title;
  final String? text;

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
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;

  var aiModel = '';

  final _diagnosisManager = DiagnosisManager();
  final _settingsManager = SettingsManager();

  var diagnosisHistoryList = [];

  var userModel = UserModel.toEmpty();

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  }

  Future<void> getDiagnosis() async {
    diagnosisHistoryList = await _diagnosisManager.getDiagnosis();
  }

  void fetchUserData() async {
    userModel = await authUserInfo(context);
  }

  void initializeSettings() async {
    aiModel = await _settingsManager.getAIModel();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _scrollController.addListener(_onScroll);
    getDiagnosis();
    initializeSettings();
    fetchUserData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _galleryBody(),

      // floating action button
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: ExpandableFab(
          key: _key,
          type: ExpandableFabType.fan,
          overlayStyle: ExpandableFabOverlayStyle(
            color: Theme.of(context).colorScheme.background.withOpacity(0.7),
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
      ),
    );
  }

  // body
  Widget _galleryBody() {
    return ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 22),
        children: [
          // title
          Text(
            widget.title,
            style: const TextStyle(fontSize: 20),
          ),

          AppSpacing.medium,

          // image
          _image != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _image!,
                        height: 280,
                        width: 400,
                        fit: BoxFit.cover,
                      )),
                )
              : Column(
                  children: [
                    AppSpacing.large,
                    // anim
                    Lottie.asset(
                      width: 220,
                      height: 220,
                      AppAssets.leafScanAnim,
                      repeat: false,
                    ),

                    // desc
                    const Text("Scan a plant leaf by tapping the ‘+’ icon.")
                  ],
                ),
          AppSpacing.xSmall,

          // image info
          if (_image != null && widget.text != null && widget.text!.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_path == null
                        ? ''
                        : widget.text ?? 'Diagnosis not available'),
                    if (widget.text != null && widget.text!.isNotEmpty) ...{
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // generate analysis
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AnalysisPage(
                                      diagnosisModel: DiagnosisModel(
                                        imagePath: _path ?? '',
                                        description: widget.text ?? '',
                                        analysis: '',
                                        aiModel: aiModel,
                                        time: DateTime.now().toIso8601String(),
                                        id: null,
                                      ),
                                      userModel: userModel,
                                    ),
                                  ));
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.auto_awesome,
                                      size: 21,
                                    ),
                                    AppWidthSpacing.small,
                                    Text('Generate Analysis'),
                                  ],
                                )),
                          ),
                          AppWidthSpacing.xSmall,

                          // save
                          Flexible(
                            child: SizedBox(
                              width: 200,
                              child: FilledButton(
                                child: const Text('Save'),
                                onPressed: () async {
                                  await _diagnosisManager.saveDiagnosis(
                                    DiagnosisModel(
                                      imagePath: _path ?? '',
                                      description: widget.text ?? '',
                                      analysis: '',
                                      aiModel: aiModel,
                                      time: DateTime.now().toIso8601String(),
                                      id: DiagnosisManager().generateUniqueId(),
                                    ),
                                  );
                                  if (mounted) {
                                    showToast('Diagnosis saved', context,
                                        status: Status.success);
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SFMainScaffold(
                                            selectedIndex: 2,
                                          ),
                                        ),
                                        (route) => false);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.small,
                    },
                  ],
                ),
              ),
            ),

          // diagnosis not available
          if (_image != null &&
              (widget.text == null || widget.text!.isEmpty)) ...{
            AppSpacing.medium,
            const Text(
              'Diagnosis not available',
              textAlign: TextAlign.center,
            ),
          },
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
