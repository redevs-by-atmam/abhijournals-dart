class SocialLinkModel {
  final String facebook;
  final String x;
  final String instagram;
  final String linkedin;
  final String youtube;

  SocialLinkModel({
    required this.facebook,
    required this.x,
    required this.instagram,
    required this.linkedin,
    required this.youtube,
  });

  factory SocialLinkModel.fromJson(Map<String, dynamic> json) {
    return SocialLinkModel(
      facebook: json['facebook'],
      x: json['x'],
      instagram: json['instagram'],
      linkedin: json['linkedin'],
      youtube: json['youtube'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebook': facebook,
      'x': x,
      'instagram': instagram,
      'linkedin': linkedin,
      'youtube': youtube,
    };
  }

  // copyWith
  SocialLinkModel copyWith({
    String? facebook,
    String? x,
    String? instagram,
    String? linkedin,
    String? youtube,
  }) {
    return SocialLinkModel(
      facebook: facebook ?? this.facebook,
      x: x ?? this.x,
      instagram: instagram ?? this.instagram,
      linkedin: linkedin ?? this.linkedin,
      youtube: youtube ?? this.youtube,
    );
  }
}
