import 'dart:convert';

class AnalysisRequestModel {
  String assistantId;
  String threadId;
  String content;
  String userId;
  String instructions;

  AnalysisRequestModel({
    required this.assistantId,
    required this.threadId,
    required this.content,
    required this.userId,
    required this.instructions,
  });

// convert to a Map
  Map<String, dynamic> toMap() {
    return {
      'assistant_id': assistantId,
      'thread_id': threadId,
      'content': content,
      'user_id': userId,
      'instructions': instructions,
    };
  }

  // create from a Map
  factory AnalysisRequestModel.fromMap(Map<String, dynamic> map) {
    return AnalysisRequestModel(
      assistantId: map['assistant_id'] ?? '',
      threadId: map['thread_id'] ?? '',
      content: map['content'] ?? '',
      userId: map['user_id'] ?? '',
      instructions: map['instructions'] ?? '',
    );
  }

  // convert to a Json
  String toJson() => json.encode(toMap());

  // create from a Json
  factory AnalysisRequestModel.fromJson(String source) =>
      AnalysisRequestModel.fromMap(json.decode(source));
}
