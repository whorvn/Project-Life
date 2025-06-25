class Hackathon {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int? maxParticipants;
  final int maxTeamSize;
  final String status;
  final String? prizes;
  final String? rules;
  final String? requirements;
  final String? judgingCriteria;
  final Map<String, dynamic>? landingPageConfig;
  final DateTime createdAt;
  final DateTime updatedAt;

  Hackathon({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    this.maxParticipants,
    required this.maxTeamSize,
    required this.status,
    this.prizes,
    this.rules,
    this.requirements,
    this.judgingCriteria,
    this.landingPageConfig,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Hackathon.fromJson(Map<String, dynamic> json) {
    return Hackathon(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      maxParticipants: json['max_participants'],
      maxTeamSize: json['max_team_size'],
      status: json['status'],
      prizes: json['prizes'],
      rules: json['rules'],
      requirements: json['requirements'],
      judgingCriteria: json['judging_criteria'],
      landingPageConfig: json['landing_page_config'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'max_participants': maxParticipants,
      'max_team_size': maxTeamSize,
      'status': status,
      'prizes': prizes,
      'rules': rules,
      'requirements': requirements,
      'judging_criteria': judgingCriteria,
      'landing_page_config': landingPageConfig,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Hackathon copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? maxParticipants,
    int? maxTeamSize,
    String? status,
    String? prizes,
    String? rules,
    String? requirements,
    String? judgingCriteria,
    Map<String, dynamic>? landingPageConfig,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Hackathon(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      maxTeamSize: maxTeamSize ?? this.maxTeamSize,
      status: status ?? this.status,
      prizes: prizes ?? this.prizes,
      rules: rules ?? this.rules,
      requirements: requirements ?? this.requirements,
      judgingCriteria: judgingCriteria ?? this.judgingCriteria,
      landingPageConfig: landingPageConfig ?? this.landingPageConfig,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Hackathon(id: $id, title: $title, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hackathon &&
        other.id == id &&
        other.title == title &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ status.hashCode;
  }
}
