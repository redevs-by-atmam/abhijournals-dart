import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class IssueModel extends Equatable {
  final String id;
  final String title;
  final String issueNumber;
  final String volumeNumber;
  final String volumeId;
  final String journalId;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;
  final bool isActive;
  const IssueModel({
    required this.id,
    required this.title,
    required this.issueNumber,
    required this.volumeId,
    required this.journalId,
    required this.volumeNumber,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.isActive,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      title: json['title'],
      issueNumber: json['issueNumber'],
      volumeId: json['volumeId'],
      volumeNumber: json['volumeNumber'] ?? '',
      journalId: json['journalId'],
      description: json['description'],
      fromDate: DateTime.parse(json['fromDate']),
      toDate: DateTime.parse(json['toDate']),
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'issueNumber': issueNumber,
      'volumeId': volumeId,
      'journalId': journalId,
      'description': description,
      'fromDate': DateFormat('dd, MMMM yyyy').format(fromDate),
      'toDate': DateFormat('dd, MMMM yyyy').format(toDate),
      'isActive': isActive,
      'volumeNumber': volumeNumber,
    };
  }

  IssueModel copyWith({
    String? id,
    String? title,
    String? issueNumber,
    String? volumeId,
    String? journalId,
    String? description,
    String? volumeNumber,
    DateTime? fromDate,
    DateTime? toDate,
    bool? isActive,
  }) {
    return IssueModel(
      id: id ?? this.id,
      title: title ?? this.title,
      issueNumber: issueNumber ?? this.issueNumber,
      volumeId: volumeId ?? this.volumeId,
      journalId: journalId ?? this.journalId,
      description: description ?? this.description,
      volumeNumber: volumeNumber ?? this.volumeNumber,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        issueNumber,
        volumeId,
        journalId,
        description,
        fromDate,
        toDate,
        isActive,
        volumeNumber,
      ];
}
