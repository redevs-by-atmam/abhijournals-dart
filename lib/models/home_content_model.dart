import 'dart:developer';

import 'package:equatable/equatable.dart';

class HomeCountsModel {
  final int totalArticles;
  final int totalJournals;
  final int totalVolumes;
  final int totalIssues;
  final int totalAuthors;

  HomeCountsModel({
    required this.totalArticles,
    required this.totalJournals,
    required this.totalVolumes,
    required this.totalIssues,
    required this.totalAuthors,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalArticles': totalArticles,
      'totalJournals': totalJournals,
      'totalVolumes': totalVolumes,
      'totalIssues': totalIssues,
      'totalAuthors': totalAuthors,
    };
  }

  HomeCountsModel copyWith({
    int? totalArticles,
    int? totalJournals,
    int? totalVolumes,
    int? totalIssues,
    int? totalAuthors,
  }) {
    return HomeCountsModel(
      totalArticles: totalArticles ?? this.totalArticles,
      totalJournals: totalJournals ?? this.totalJournals,
      totalVolumes: totalVolumes ?? this.totalVolumes,
      totalIssues: totalIssues ?? this.totalIssues,
      totalAuthors: totalAuthors ?? this.totalAuthors,
    );
  }
  
}

class JournalMetaDataModel {
  String editorInChief;
  String fullEditionTitle;
  String publisher;
  String since;

  JournalMetaDataModel(
      {required this.editorInChief,
      required this.fullEditionTitle,
      required this.publisher,
      required this.since});

  factory JournalMetaDataModel.fromJson(Map<String, dynamic> json) {
    return JournalMetaDataModel(
        editorInChief: json['editorInChief'] ?? 'N/A',
        fullEditionTitle: json['fullEditionTitle'] ?? 'N/A',
        publisher: json['publisher'] ?? 'N/A',
        since: json['since'] != null 
            ? DateTime.parse(json['since']).toString().substring(0,4)
            : DateTime.now().toString().substring(0,4));
  }

  Map<String, dynamic> toJson() {
    return {
      'editorInChief': editorInChief,
      'fullEditionTitle': fullEditionTitle,
      'publisher': publisher,
      'since': since,
    };
  }

  JournalMetaDataModel copyWith({
    String? editorInChief,
    String? fullEditionTitle,
    String? publisher,
    String? since,
  }) {
    return JournalMetaDataModel(
      editorInChief: editorInChief ?? this.editorInChief,
      fullEditionTitle: fullEditionTitle ?? this.fullEditionTitle,
      publisher: publisher ?? this.publisher,
      since: since ?? this.since,
    );
  }
}

class HomeContentModel extends Equatable {
  final String htmlContent;
  final List<QuickLinksModel> quickLinks;
  final JournalMetaDataModel journalMetaData;
  final PublisherModel publisher;
  final List<PatronModel> patrons;
  final String mode;
  final String language;
  final String frequency;

  const HomeContentModel({
    required this.htmlContent,
    required this.quickLinks,
    required this.journalMetaData,
    required this.publisher,
    required this.patrons,
    required this.mode,
    required this.language,
    required this.frequency,
  });

  factory HomeContentModel.fromJson(Map<String, dynamic> json) {
    return HomeContentModel(
      htmlContent:
          (json['htmlContent'] as String?)?.replaceAll('<p><br></p>', '') ?? '',
      quickLinks: (json['quickLinks'] as List<dynamic>?)
              ?.map((link) =>
                  QuickLinksModel.fromJson(link as Map<String, dynamic>))
              .toList() ??
          [],
      journalMetaData:
          JournalMetaDataModel.fromJson(json['journalMetaData'] ?? {}),
      publisher: PublisherModel.fromJson(json['publisher'] ?? {}),
      patrons: (json['patrons'] as List<dynamic>?)
              ?.map((patron) =>
                  PatronModel.fromJson(patron as Map<String, dynamic>))
              .toList() ??
          [],
      mode: json['mode'] ?? 'N/A',
      language: json['language'] ?? 'N/A',
      frequency: json['frequency'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'htmlContent': htmlContent,
      'quickLinks': quickLinks.map((link) => link.toJson()).toList(),
      'journalMetaData': journalMetaData.toJson(),
      'publisher': publisher.toJson(),
      'patrons': patrons.map((patron) => patron.toJson()).toList(),
      'mode': mode,
      'language': language,
      'frequency': frequency,
    };
  }

  @override
  List<Object?> get props => [
        htmlContent,
        quickLinks,
        journalMetaData,
        publisher,
        patrons,
        mode,
        language,
        frequency
      ];
}

class JournalMetaData extends Equatable {
  final String issn;
  final String eIssn;
  final String impact;
  final String frequency;
  final String language;

  const JournalMetaData({
    required this.issn,
    required this.eIssn,
    required this.impact,
    required this.frequency,
    required this.language,
  });

  factory JournalMetaData.fromJson(Map<String, dynamic> json) {
    return JournalMetaData(
      issn: json['issn'] ?? '',
      eIssn: json['eIssn'] ?? '',
      impact: json['impact'] ?? '',
      frequency: json['frequency'] ?? '',
      language: json['language'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'issn': issn,
      'eIssn': eIssn,
      'impact': impact,
      'frequency': frequency,
      'language': language,
    };
  }

  @override
  List<Object?> get props => [issn, eIssn, impact, frequency, language];
}

class PublisherModel {
  String name;
  String address;
  String institute;
  String email;

  PublisherModel({
    required this.name,
    required this.address,
    required this.institute,
    required this.email,
  });

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      name: json['name'] ?? 'N/A',
      address: json['address'] ?? 'N/A',
      institute: json['institute'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'institute': institute,
      'email': email
    };
  }

  PublisherModel copyWith(
      {String? name, String? address, String? institute, String? email}) {
    return PublisherModel(
        name: name ?? this.name,
        address: address ?? this.address,
        institute: institute ?? this.institute,
        email: email ?? this.email);
  }
}

class PatronModel {
  String name;
  String address;
  String institute;
  String email;

  PatronModel({
    required this.name,
    required this.address,
    required this.institute,
    required this.email,
  });

  factory PatronModel.fromJson(Map<String, dynamic> json) {
    return PatronModel(
        name: json['name'] ?? 'N/A',
        address: json['address'] ?? 'N/A',
        institute: json['institute'] ?? 'N/A',
        email: json['email'] ?? 'N/A');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'institute': institute,
      'email': email
    };
  }

  PatronModel copyWith(
      {String? name, String? address, String? institute, String? email}) {
    return PatronModel(
        name: name ?? this.name,
        address: address ?? this.address,
        institute: institute ?? this.institute,
        email: email ?? this.email);
  }
}

class QuickLinksModel {
  String title;
  String url;

  QuickLinksModel({
    required this.title,
    required this.url,
  });

  factory QuickLinksModel.fromJson(Map<String, dynamic> json) {
    return QuickLinksModel(
        title: json['title'] ?? 'N/A', url: json['url'] ?? 'N/A');
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'url': url};
  }

  QuickLinksModel copyWith({String? title, String? url}) {
    return QuickLinksModel(
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }
}
