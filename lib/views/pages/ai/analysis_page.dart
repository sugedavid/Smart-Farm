import 'dart:io';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_farm/views/components/sf_main_scaffold.dart';
import 'package:smart_farm/views/components/sf_single_page_scaffold.dart';
import 'package:smart_farm/views/components/sf_toast_notification.dart';
import 'package:smart_farm/data/helper/diagnosis_manager.dart';
import 'package:smart_farm/data/helper/settings_manager.dart';
import 'package:smart_farm/data/models/diagnosis.dart';
import 'package:smart_farm/data/service/gemini_service.dart';
import 'package:smart_farm/utils/spacing.dart';
import 'package:smart_farm/data/service/gemma_service.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({
    super.key,
    required this.diagnosisModel,
    required this.isOffline,
  });

  final DiagnosisModel diagnosisModel;
  final bool isOffline;

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late Future<dynamic> response;

  final SettingsManager settingsManager = SettingsManager();
  final DiagnosisManager _diagnosisManager = DiagnosisManager();

  @override
  void initState() {
    super.initState();
    generateResponse();
  }

  // generate AI analysis
  void generateResponse() {
    if (widget.diagnosisModel.analysis.isEmpty) {
      response = widget.isOffline
          ? GemmaLocalService()
              .processResponse(widget.diagnosisModel.description)
          : GeminiLocalService()
              .processResponse(widget.diagnosisModel.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SFSinglePageScaffold(
      title: 'AI Analysis',
      actions: [
        // chat
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SFMainScaffold(
                  selectedIndex: 1,
                ),
              ));
            },
            icon: Icon(
              Icons.question_answer_rounded,
              color: Theme.of(context).colorScheme.primary,
            ))
      ],
      child: widget.diagnosisModel.analysis.isNotEmpty
          ? analysisBody(widget.diagnosisModel.analysis, context)
          : FutureBuilder(
              future: response,
              builder: (context, snapshot) {
                // loading state
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      children: [
                        // anim
                        LoadingAnimationWidget.threeRotatingDots(
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                        AppSpacing.xSmall,

                        // desc
                        const Text(
                          'Analysing data',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                  );
                }

                // error state
                else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error analysing data: ${snapshot.error}'),
                  );
                }

                // data
                else {
                  var analysis = '';
                  if (widget.isOffline) {
                    var gemmaData = snapshot.data as String;
                    analysis = gemmaData;
                  } else {
                    var geminiData = snapshot.data as GenerateContentResponse;
                    analysis = geminiData.text ?? '';
                  }

                  var diagnosisModel = widget.diagnosisModel;
                  diagnosisModel.analysis = analysis;
                  diagnosisModel.isOffline = widget.isOffline;
                  _diagnosisManager.updateDiagnosis(diagnosisModel);

                  return analysisBody(analysis, context);
                }
              },
            ),
    );
  }

  // analysis body
  Column analysisBody(String data, BuildContext context) {
    return Column(
      children: [
        // image
        SizedBox(
          height: 220,
          width: 400,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(widget.diagnosisModel.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        AppSpacing.medium,

        // ai model
        ActionChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                color: widget.isOffline
                    ? Theme.of(context).colorScheme.onErrorContainer
                    : Theme.of(context).colorScheme.onPrimaryContainer,
                size: 18,
              ),
              AppWidthSpacing.xSmall,
              Text(widget.diagnosisModel.isOffline ?? widget.isOffline
                  ? 'Gemma AI (on-device)'
                  : 'Gemini AI'),
            ],
          ),
          padding: EdgeInsets.zero,
          backgroundColor: widget.isOffline
              ? Theme.of(context).colorScheme.errorContainer
              : Theme.of(context).colorScheme.primaryContainer,
          labelStyle: TextStyle(
              color: widget.isOffline
                  ? Theme.of(context).colorScheme.onErrorContainer
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 12),
          side: BorderSide.none,
          onPressed: () async => widget.isOffline
              ? showToast('Gemma AI model (offline)', context,
                  status: Status.info)
              : showToast('Gemini AI model (online)', context,
                  status: Status.info),
        ),
        AppSpacing.small,

        // analysis
        MarkdownBody(
          data: data,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
