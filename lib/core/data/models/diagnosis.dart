import 'dart:convert';

class DiagnosisModel {
  String imagePath;
  String description;
  String analysis;
  String aiModel;
  String time;
  String? id;

  DiagnosisModel({
    required this.imagePath,
    required this.description,
    required this.analysis,
    required this.aiModel,
    required this.time,
    required this.id,
  });

// convert to a Map
  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'description': description,
      'analysis': analysis,
      'aiModel': aiModel,
      'time': time,
      'id': id,
    };
  }

  // create from a Map
  factory DiagnosisModel.fromMap(Map<String, dynamic> map) {
    return DiagnosisModel(
      imagePath: map['imagePath'] ?? '',
      description: map['description'] ?? '',
      analysis: map['analysis'] ?? '',
      aiModel: map['aiModel'] ?? '',
      time: map['time'] ?? '',
      id: map['id'],
    );
  }

  // convert to a Json
  String toJson() => json.encode(toMap());

  // create from a Json
  factory DiagnosisModel.fromJson(String source) =>
      DiagnosisModel.fromMap(json.decode(source));
}
