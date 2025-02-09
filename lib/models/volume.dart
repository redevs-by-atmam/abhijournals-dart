import 'package:equatable/equatable.dart';

class VolumeModel extends Equatable {
  final String id;
  final String journalId;
  final String description;
  final bool isActive;
  final String volumeNumber;
  final String title;
  final DateTime createdAt;
  const VolumeModel({
    required this.journalId,
    required this.description,
    required this.isActive,
    required this.id,
    required this.volumeNumber,
    required this.title,
    required this.createdAt,
  });


  factory VolumeModel.fromJson(Map<String, dynamic> json) {
    return VolumeModel(
      journalId: json['journalId'],
      id: json['id'],
      volumeNumber: json['volumeNumber'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'journalId': journalId,
      'title': title,
      'volumeNumber': volumeNumber,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
      'isActive': isActive,
    };
  }

  VolumeModel copyWith({
    String? journalId,
    String? description,
    bool? isActive,
    String? id,
    String? volumeNumber,
    String? title,
    DateTime? createdAt,
  }) {
    return VolumeModel(
      journalId: journalId ?? this.journalId,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      id: id ?? this.id,
      volumeNumber: volumeNumber ?? this.volumeNumber,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  List<Object?> get props => [id, journalId, description, isActive, volumeNumber, title, createdAt];
}
