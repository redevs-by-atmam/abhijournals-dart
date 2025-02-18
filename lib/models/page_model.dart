import 'package:equatable/equatable.dart';

class PageModel extends Equatable {
  final String id;
  final String journalId;
  final String name;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PageModel({
    required this.id,
    required this.journalId,
    required this.name,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'],
      journalId: json['journalId'],
      name: json['name'] ?? 'Untitled',
      content: json['content'] ?? 'No content',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'journalId': journalId,
      'name': name,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [id, journalId, name, content, createdAt, updatedAt];
}
