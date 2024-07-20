import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_farm/components/sf_dialog.dart';
import 'package:smart_farm/components/sf_toast_notification.dart';
import 'package:smart_farm/data/helper/diagnosis_manager.dart';
import 'package:smart_farm/data/models/diagnosis.dart';
import 'package:smart_farm/utils/spacing.dart';
import 'package:smart_farm/views/ai/analysis_page.dart';

class DiagnosisHistoryPage extends StatefulWidget {
  const DiagnosisHistoryPage({super.key});

  @override
  State<DiagnosisHistoryPage> createState() => _DiagnosisHistoryPageState();
}

class _DiagnosisHistoryPageState extends State<DiagnosisHistoryPage> {
  final DiagnosisManager _diagnosisManager = DiagnosisManager();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DiagnosisModel>>(
      future: _diagnosisManager.getDiagnosis(),
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // error
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // empty
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No diagnosis yet'));
        }
        // data
        else {
          return ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var imagePath = snapshot.data![index].imagePath;
              var image = File(imagePath);
              var description = snapshot.data![index].description;
              return ExpansionTile(
                initiallyExpanded: index == 0,
                backgroundColor: Theme.of(context).colorScheme.background,
                dense: true,
                expandedAlignment: Alignment.centerLeft,
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                leading: IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                  ),
                  color: Colors.red,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => SFDialog.showSFDialog(
                    context: context,
                    title: 'Delete Diagnosis',
                    content: const Text(
                        'Are you sure you want to delete this diagnosis?'),
                    okText: 'DELETE',
                    cancelText: 'CANCEL',
                    onOk: () async {
                      Navigator.pop(context);

                      await _diagnosisManager.deleteDiagnosis(index);
                      setState(() {});
                      if (context.mounted) {
                        showToast('Diagnosis deleted', context,
                            status: Status.success);
                      }
                    },
                    onCancel: () => Navigator.pop(context),
                  ),
                ),
                title: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    image,
                    width: 200,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                children: <Widget>[
                  // description
                  Text(description),

                  // recommendation
                  Align(
                    alignment: Alignment.center,
                    child: FilledButton.tonal(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AnalysisPage(
                              diagnosis: description,
                              image: image,
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
                  AppSpacing.medium,
                ],
              );
            },
          );
        }
      },
    );
  }
}