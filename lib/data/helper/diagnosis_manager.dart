import 'dart:io';
import 'dart:math';

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

  // update a diagnosis based on its id
  Future<void> updateDiagnosis(DiagnosisModel diagnosisModel) async {
    if (diagnosisModel.id == null) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> diagnosisList = prefs.getStringList(_diagnosisKey) ?? [];
    List<DiagnosisModel> dL =
        diagnosisList.map((e) => DiagnosisModel.fromJson(e)).toList();
    int index = dL.indexWhere((element) => element.id == diagnosisModel.id);
    diagnosisList[index] = diagnosisModel.toJson();

    prefs.setStringList(_diagnosisKey, diagnosisList);
  }

  // delete a diagnosis based on its id
  Future<void> deleteDiagnosis(DiagnosisModel diagnosisModel) async {
    if (diagnosisModel.id == null) return;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> diagnosisList = prefs.getStringList(_diagnosisKey) ?? [];
    List<DiagnosisModel> dL =
        diagnosisList.map((e) => DiagnosisModel.fromJson(e)).toList();
    int index = dL.indexWhere((element) => element.id == diagnosisModel.id);
    diagnosisList.removeAt(index);

    prefs.setStringList(_diagnosisKey, diagnosisList);
  }

  // delete all diagnosis
  Future<void> deleteAllDiagnosis() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_diagnosisKey);
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

  // generate a six digits random number
  String generateUniqueId() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    int randomPart = Random().nextInt(1000000);
    String uniqueId = '$timestamp$randomPart';

    return uniqueId;
  }
}
