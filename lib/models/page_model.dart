import 'package:equatable/equatable.dart';

class PageModel extends Equatable {
  final String id;
  final String journalId;
  final String name;
  final String url;
  final String content;

  const PageModel({
    required this.id,
    required this.journalId,
    required this.name,
    required this.url,
    required this.content,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      id: json['id'],
      journalId: json['journalId'],
      name: ((json['name'] ?? 'Untitled') as String).trim(),
      url: ((json['url'] ?? '') as String).trim(),
      content: ((json['content'] ?? 'No content') as String).trim(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'journalId': journalId,
      'name': name,
      'url': url,
      'content': content,
    };
  }

  @override
  List<Object?> get props =>
      [id, journalId, name, url, content, ];
}
