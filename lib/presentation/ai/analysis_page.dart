import 'dart:io';

import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_farm/core/data/models/diagnosis.dart';
import 'package:smart_farm/core/data/models/gpt/analysis_request.dart';
import 'package:smart_farm/core/data/models/user.dart';
import 'package:smart_farm/core/data/service/analytics_service.dart';
import 'package:smart_farm/core/data/service/gemini_service.dart';
import 'package:smart_farm/core/data/service/gemma_service.dart';
import 'package:smart_farm/core/data/service/gpt_service.dart';
import 'package:smart_farm/core/data/service/performance_service.dart';
import 'package:smart_farm/core/helper/diagnosis_manager.dart';
import 'package:smart_farm/core/helper/settings_manager.dart';
import 'package:smart_farm/core/utils/spacing.dart';
import 'package:smart_farm/shared/presentation/sf_main_scaffold.dart';
import 'package:smart_farm/shared/presentation/sf_single_page_scaffold.dart';
import 'package:smart_farm/shared/presentation/sf_toast_notification.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({
    super.key,
    required this.diagnosisModel,
    required this.userModel,
  });

  final DiagnosisModel diagnosisModel;
  final UserModel userModel;

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late Future<dynamic> response;

  final SettingsManager settingsManager = SettingsManager();
  final DiagnosisManager _diagnosisManager = DiagnosisManager();
  String aiName = '';

  @override
  void initState() {
    super.initState();
    generateResponse();
  }

  // generate AI analysis
  void generateResponse() {
    if (widget.diagnosisModel.analysis.isEmpty) {
      // gemma
      if (widget.diagnosisModel.aiModel == AIModel.gemma.name) {
        response = GemmaService().processResponse(
          widget.diagnosisModel.description,
          PerformanceService().gemmaAnalysisTrace,
          AnalyticsService().analysisEvent,
        );

        setState(() {
          aiName = 'Gemma AI (on-device)';
        });
      }
      // gemini
      else if (widget.diagnosisModel.aiModel == AIModel.gemini.name) {
        response = GeminiService().processResponse(
          widget.diagnosisModel.description,
          PerformanceService().geminiAnalysisTrace,
          AnalyticsService().analysisEvent,
        );

        setState(() {
          aiName = 'Gemini AI';
        });
      }
      // GPT
      else if (widget.diagnosisModel.aiModel == AIModel.gpt.name) {
        final requestBody = AnalysisRequestModel(
          assistantId: GPTService().assistantId,
          threadId: widget.userModel.threadId,
          content: widget.diagnosisModel.description,
          userId: widget.userModel.userId,
          instructions: GPTService().prompt,
        );

        response = GPTService().processResponse(
          requestBody,
          PerformanceService().gptAnalysisTrace,
          AnalyticsService().gptModel,
          context,
        );

        setState(() {
          aiName = 'GPT: gpt-3.5-turbo-1106';
        });
      }
      // default
      else {
        response = Future.delayed(const Duration(seconds: 1));
      }
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
                      mainAxisSize: MainAxisSize.min,
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
                  // gemma
                  if (widget.diagnosisModel.aiModel == AIModel.gemma.name) {
                    var gemmaData = snapshot.data as String;
                    analysis = gemmaData;
                  }
                  // gemini
                  else if (widget.diagnosisModel.aiModel ==
                      AIModel.gemini.name) {
                    var geminiData = snapshot.data as GenerateContentResponse;
                    analysis = geminiData.text ?? '';
                  }
                  // GPT
                  else if (widget.diagnosisModel.aiModel == AIModel.gpt.name) {
                    var gptData = snapshot.data?['data'] as List? ?? [];
                    analysis = gptData
                            .where((element) => element['role'] == 'assistant')
                            .toList()
                            .firstOrNull?['content']?[0]?['text']?['value'] ??
                        'Analysis not available';
                  }

                  var diagnosisModel = widget.diagnosisModel;
                  if (analysis != 'No Analysis') {
                    diagnosisModel.analysis = analysis;
                  }
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
                color: Theme.of(context).colorScheme.onSurface,
                size: 18,
              ),
              AppWidthSpacing.xSmall,
              Text(widget.diagnosisModel.aiModel == AIModel.gpt.name
                  ? AIModel.gpt.name.toUpperCase()
                  : capitalizeFirstLetter(widget.diagnosisModel.aiModel)),
            ],
          ),
          padding: EdgeInsets.zero,
          backgroundColor: Colors.amber.withOpacity(0.5),
          labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface, fontSize: 12),
          side: BorderSide.none,
          onPressed: () async {
            if (widget.diagnosisModel.aiModel == AIModel.gemma.name) {
              showToast(
                  'Gemma AI model (on-device): gemma-2b-it-gpu-int4', context,
                  status: Status.info);
            } else if (widget.diagnosisModel.aiModel == AIModel.gemini.name) {
              showToast('Gemini AI model: gemini-1.5-flash', context,
                  status: Status.info);
            } else if (widget.diagnosisModel.aiModel == AIModel.gpt.name) {
              showToast('GPT AI model: gpt-3.5-turbo-1106', context,
                  status: Status.info);
            }
          },
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
