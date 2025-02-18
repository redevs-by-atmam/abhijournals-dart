import 'package:equatable/equatable.dart';

class SocialLink extends Equatable {
  final String name;
  final String url;

  const SocialLink({
    required this.name,
    required this.url,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      name: json['name'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  @override
  List<Object?> get props => [name, url];
} 