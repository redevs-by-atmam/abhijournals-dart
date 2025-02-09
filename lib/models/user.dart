class MyUser {
  String? role;
  String? email;
  String? password;
  String? name;
  String? id;
  String? designation;
  List<String>? journalIds;
  MyUser({
    this.role,
    this.email,
    this.password,
    this.name,
    this.id,
    this.designation,
    this.journalIds,
  });

  Map<String, dynamic> toJson() => {
        'role': role,
        'email': email,
        'password': password,
        'name': name,
        'id': id,
        'designation': designation,
        'journalIds': journalIds,
      };

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
        role: json['role'],
        email: json['email'],
        password: json['password'],
        name: json['name'],
        id: json['id'],
        designation: json['designation'],
        journalIds: json['journalIds'] != null
            ? List<String>.from(json['journalIds'])
            : [],
      );
}
