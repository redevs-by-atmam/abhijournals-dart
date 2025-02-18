import 'package:equatable/equatable.dart';

class PaperStatus extends Equatable {
  final String paperId;
  final String title;
  final String currentStatus;
  final DateTime lastUpdated;
  final List<StatusHistoryItem> statusHistory;

  const PaperStatus({
    required this.paperId,
    required this.title,
    required this.currentStatus,
    required this.lastUpdated,
    required this.statusHistory,
  });

  factory PaperStatus.fromJson(Map<String, dynamic> json) {
    return PaperStatus(
      paperId: json['paperId'],
      title: json['title'],
      currentStatus: json['currentStatus'],
      lastUpdated: DateTime.parse(json['lastUpdated']),
      statusHistory: (json['statusHistory'] as List)
          .map((item) => StatusHistoryItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paperId': paperId,
      'title': title,
      'currentStatus': currentStatus,
      'lastUpdated': lastUpdated.toIso8601String(),
      'statusHistory': statusHistory.map((item) => item.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [paperId, title, currentStatus, lastUpdated, statusHistory];
}

class StatusHistoryItem extends Equatable {
  final DateTime date;
  final String status;
  final String? note;

  const StatusHistoryItem({
    required this.date,
    required this.status,
    this.note,
  });

  factory StatusHistoryItem.fromJson(Map<String, dynamic> json) {
    return StatusHistoryItem(
      date: DateTime.parse(json['date']),
      status: json['status'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'status': status,
      'note': note,
    };
  }

  @override
  List<Object?> get props => [date, status, note];
} 