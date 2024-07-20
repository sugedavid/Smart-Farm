import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_farm/data/models/diagnosis.dart';

class DiagnosisManager {
  static const String _diagnosisKey = 'diagnosis';

  // save diagnosis
  Future<void> saveDiagnosis(DiagnosisModel diagnosisModel) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> diagnosisList = prefs.getStringList(_diagnosisKey) ?? [];
    diagnosisList.add(diagnosisModel.toJson());
    prefs.setStringList(_diagnosisKey, diagnosisList);
  }

  // delete a diagnosis based on its id
  Future<void> deleteDiagnosis(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var diagnosisList = prefs.getStringList(_diagnosisKey) ?? [];
    diagnosisList.removeAt(index);
    prefs.setStringList(_diagnosisKey, diagnosisList);
  }

  // get diagnosis
  Future<List<DiagnosisModel>> getDiagnosis() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> diagnosisList = prefs.getStringList(_diagnosisKey) ?? [];
    return diagnosisList.reversed
        .map((e) => DiagnosisModel.fromJson(e))
        .toList();
  }

  // save image to local storage
  Future<String> saveImageToLocalStorage(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final filePath = '${appDir.path}/$fileName.png';
    await imageFile.copy(filePath);
    return filePath;
  }
}
