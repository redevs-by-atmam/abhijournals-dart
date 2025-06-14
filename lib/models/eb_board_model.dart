import 'package:intl/intl.dart';

class EditorialBoardModel {
  final String id;
  final String journalId;
  final String name;
  final String email;
  final String role;
  final String profileLink;
  final String institution;
  final DateTime createdAt;

  EditorialBoardModel({
    required this.id,
    required this.journalId,
    required this.name,
    required this.email,
    required this.role,
    required this.profileLink,
    required this.institution,
    required this.createdAt,
  });

  factory EditorialBoardModel.empty() {
    return EditorialBoardModel(
      id: '',
      journalId: '',
      name: '',
      email: '',
      role: '',
      profileLink: '',
      institution: '',
      createdAt: DateTime.now(),
    );
  }

  factory EditorialBoardModel.fromJson(Map<String, dynamic> json) {
    return EditorialBoardModel(
      id: json['id'],
      journalId: json['journalId'] ?? '',
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profileLink: json['profileLink'] ?? 'https://www.google.com',
      institution: json['institution'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'journalId': journalId,
      'name': name,
      'email': email,
      'role': role,
      'profileLink': profileLink,
      'institution': institution,
      'createdAt': DateFormat('dd, MMMM yyyy').format(createdAt),
    };
  }

  @override
  String toString() {
    return 'EditorialBoardModel(id: $id, name: $name, email: $email, role: $role, institution: $institution, createdAt: $createdAt)';
  }

  EditorialBoardModel copyWith({
    String? id,
    String? journalId,
    String? name,
    String? email,
    String? role,
    String? institution,
    DateTime? createdAt,
    String? profileLink,
  }) {
    return EditorialBoardModel(
      id: id ?? this.id,
      journalId: journalId ?? this.journalId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileLink: profileLink ?? this.profileLink,
      institution: institution ?? this.institution,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

enum EditorialBoardRole {
  chiefEditor('Chief Editor'),
  associateEditor('Associate Editor'),
  editor('Editor');

  final String value;
  const EditorialBoardRole(this.value);
}
