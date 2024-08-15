// Model class for the root of the JSON object
class AnalysisResponseModel {
  final String object;
  final List<DataModel> data;

  AnalysisResponseModel({
    required this.object,
    required this.data,
  });

  // Factory constructor to create a AnalysisResponseModel instance from JSON
  factory AnalysisResponseModel.fromJson(Map<String, dynamic> json) {
    return AnalysisResponseModel(
      object: json['object'] as String,
      data: (json['data'] as List)
          .map((item) => DataModel.fromJson(item))
          .toList(),
    );
  }

  // Method to convert AnalysisResponseModel instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'object': object,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }

  // empty analysis
  static AnalysisResponseModel toEmpty() {
    return AnalysisResponseModel(
      object: '',
      data: <DataModel>[],
    );
  }
}

// Model class for each item in the "data" list
class DataModel {
  final int createdAt;
  final String id;
  final List object;
  final String threadId;
  final String role;
  final List<ContentModel> content;

  DataModel({
    required this.createdAt,
    required this.id,
    required this.object,
    required this.threadId,
    required this.role,
    required this.content,
  });

  // Factory constructor to create a DataModel instance from JSON
  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      createdAt: json['created_at'] as int,
      id: json['id'] as String,
      object: json['object'] as List,
      threadId: json['thread_id'] as String,
      role: json['role'] as String,
      content: (json['content'] as List)
          .map((item) => ContentModel.fromJson(item))
          .toList(),
    );
  }

  // Method to convert DataModel instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'id': id,
      'object': object,
      'thread_id': threadId,
      'role': role,
      'content': content.map((item) => item.toJson()).toList(),
    };
  }
}

// Model class for each item in the "content" list
class ContentModel {
  final String type;
  final Map<String, String> text;

  ContentModel({
    required this.type,
    required this.text,
  });

  // Factory constructor to create a ContentModel instance from JSON
  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      type: json['type'] as String,
      text: Map<String, String>.from(json['text']),
    );
  }

  // Method to convert ContentModel instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
    };
  }
}
