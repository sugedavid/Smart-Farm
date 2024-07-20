import 'dart:convert';

class DiagnosisModel {
  String imagePath;
  String description;

  DiagnosisModel({
    required this.imagePath,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'imagePath': imagePath,
      'description': description,
    };
  }

  factory DiagnosisModel.fromMap(Map<String, dynamic> map) {
    return DiagnosisModel(
      imagePath: map['imagePath'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory DiagnosisModel.fromJson(String source) =>
      DiagnosisModel.fromMap(json.decode(source));
}
