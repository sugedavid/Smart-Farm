import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma_interface.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:smart_farm/components/sf_main_scaffold.dart';
import 'package:smart_farm/components/sf_single_page_scaffold.dart';
import 'package:smart_farm/data/helper/diagnosis_manager.dart';
import 'package:smart_farm/data/models/diagnosis.dart';
import 'package:smart_farm/utils/spacing.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({
    super.key,
    required this.diagnosisModel,
  });

  final DiagnosisModel diagnosisModel;

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final flutterGemma = FlutterGemmaPlugin.instance;
  late Future<String?> response;

  final DiagnosisManager _diagnosisManager = DiagnosisManager();

  @override
  void initState() {
    super.initState();
    generateResponse();
  }

  void generateResponse() {
    if (widget.diagnosisModel.analysis.isEmpty) {
      response = flutterGemma.getResponse(
          prompt:
              'I have conducted bean plant diagnosis. Analyse the results and give me recommendations and possible ways to manage it: ${widget.diagnosisModel.description}');
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
                  final data = snapshot.data as String;
                  widget.diagnosisModel.analysis = data;
                  _diagnosisManager.updateDiagnosis(widget.diagnosisModel);

                  return analysisBody(data, context);
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
