import 'package:dart_main_website/models/eb_board_model.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class JournalModel extends Equatable {
  final String id;
  final String image;
  final String title;
  final String domain;
  final DateTime createdAt;
  final String issn;
  final String eIssn;
  final EditorialBoardModel chiefEditor;
  const JournalModel(
      {required this.id,
      required this.chiefEditor,
      required this.image,
      required this.title,
      required this.domain,
      required this.createdAt,
      required this.issn,
      required this.eIssn});

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'] ?? '',
      issn: json['issn'] ?? 'XXXX-XXXX',
      eIssn: json['eIssn'] ?? 'XXXX-XXXX',
      title: json['title'] ?? 'Untitled Journal',
      domain: json['domain'] ?? '',
      chiefEditor: json['chiefEditor'] != null
          ? EditorialBoardModel.fromJson(json['chiefEditor'])
          : EditorialBoardModel.empty(),
      image: json['image'] ?? '',
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] is String
              ? DateTime.parse(json['createdAt'])
              : DateTime.now())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issn': issn,
      'eIssn': eIssn,
      'title': title,
      'domain': domain,
      'image': image,
      'chiefEditor': chiefEditor.toJson(),
      'createdAt': DateFormat('dd, MMMM yyyy').format(createdAt),
    };
  }

  @override
  List<Object?> get props =>
      [id, title, domain, image, createdAt, issn, eIssn, chiefEditor];

  @override
  bool? get stringify => true;

  JournalModel copyWith({
    String? id,
    String? title,
    String? domain,
    String? image,
    DateTime? createdAt,
    String? issn,
    String? eIssn,
    EditorialBoardModel? chiefEditor,
  }) {
    return JournalModel(
      id: id ?? this.id,
      chiefEditor: chiefEditor ?? this.chiefEditor,
      issn: issn ?? this.issn,
      eIssn: eIssn ?? this.eIssn,
      title: title ?? this.title,
      domain: domain ?? this.domain,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
