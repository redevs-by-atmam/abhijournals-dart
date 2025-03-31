import 'package:dart_main_website/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class ArticleModel extends Equatable {
  final String id;
  final String journalId;
  final String abstractString;
  final List<MyUser> authors;
  final String issueId;
  final String volumeId;
  final String documentType;
  final List<String> keywords;
  final List<String> mainSubjects;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String pdf;
  final List<String> references;
  final String status;
  final String title;

  const ArticleModel({
    required this.id,
    required this.journalId,
    required this.abstractString,
    required this.authors,
    required this.pdf,
    required this.references,
    required this.status,
    required this.title,
    required this.issueId,
    required this.volumeId,
    required this.documentType,
    required this.keywords,
    required this.mainSubjects,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    // Parse dates and format createdAt
    DateTime createdAtDate =
        DateFormat('dd/MM/yyyy').tryParse(json['createdAt']) ??
            DateTime.parse(json['createdAt']);

    // Handle potential null values in arrays
    List<dynamic> authorsData = json['authors'] ?? [];
    List<dynamic> keywordsData = json['keywords'] ?? [];
    List<dynamic> mainSubjectsData = json['mainSubjects'] ?? [];
    List<dynamic> referencesData = json['references'] ?? [];
    return ArticleModel(
      id: json['id'] as String,
      journalId: json['journalId'] as String,
      abstractString: (json['abstractString']).toString(),
      authors: List<MyUser>.from(
          authorsData.map((e) => MyUser.fromJson(e as Map<String, dynamic>))),
      issueId: json['issueId'] as String,
      volumeId: json['volumeId'] as String,
      documentType: json['documentType'] as String,
      keywords: List<String>.from(keywordsData),
      mainSubjects: List<String>.from(mainSubjectsData),
      createdAt: createdAtDate,
      updatedAt: DateTime.parse(json['updatedAt']),
      pdf: json['pdf'] as String,
      references: List<String>.from(referencesData),
      title: json['title'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return {
      'id': id,
      'journalId': journalId,
      'abstractString': abstractString,
      'authors': authors.map((e) => e.toJson()).toList(),
      'issueId': issueId,
      'volumeId': volumeId,
      'documentType': documentType,
      'keywords': keywords,
      'mainSubjects': mainSubjects,
      'createdAt': formatter.format(createdAt),
      'updatedAt': updatedAt.toIso8601String(),
      'pdf': pdf,
      'references': references,
      'title': title,
      'status': status,
    };
  }

  //copy with
  ArticleModel copyWith({
    String? id,
    String? abstractString,
    List<MyUser>? authors,
    String? issueId,
    String? volumeId,
    String? documentType,
    List<String>? keywords,
    List<String>? mainSubjects,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? pdf,
    List<String>? references,
    String? title,
    String? journalId,
    String? status,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      abstractString: abstractString ?? this.abstractString,
      authors: authors ?? this.authors,
      journalId: journalId ?? this.journalId,
      issueId: issueId ?? this.issueId,
      volumeId: volumeId ?? this.volumeId,
      documentType: documentType ?? this.documentType,
      keywords: keywords ?? this.keywords,
      mainSubjects: mainSubjects ?? this.mainSubjects,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pdf: pdf ?? this.pdf,
      references: references ?? this.references,
      title: title ?? this.title,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        journalId,
        abstractString,
        authors,
        issueId,
        volumeId,
        documentType,
        keywords,
        mainSubjects,
        createdAt,
        updatedAt,
        pdf,
        references,
        title,
        status
      ];
}

enum ArticleStatus {
  pending('Pending'),
  accepted('Published'),
  rejected('Rejected');

  final String value;
  const ArticleStatus(this.value);
}
