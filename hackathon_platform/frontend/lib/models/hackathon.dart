class Hackathon {
  final String id;
  final String name;
  final String title; // For backward compatibility
  final String description;
  final String? type;
  final String? theme;
  final String? location;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? applicationStartDate;
  final DateTime? applicationEndDate;
  final int? maxParticipants;
  final int maxTeamSize;
  final String status;
  final String? prizePool;
  final String? prizes; // For backward compatibility
  final String? rules;
  final String? requirements;
  final String? judgingCriteria;
  final String? eligibility;
  final String? submissionRequirements;
  final String? evaluationCriteria;
  final String? communicationChannels;
  final String? sponsors;
  final bool isFeatured;
  final String? landingPageType;
  final String? customLandingUrl;
  final String? landingColorScheme;
  final String? landingLogoUrl;
  final bool hasSponsors;
  final String? sponsorsData;
  final Map<String, dynamic>? landingPageConfig;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int participantCount;
  final int teamCount;
  final int submissionCount;

  Hackathon({
    required this.id,
    required this.name,
    required this.description,
    this.type,
    this.theme,
    this.location,
    required this.startDate,
    required this.endDate,
    this.applicationStartDate,
    this.applicationEndDate,
    this.maxParticipants,
    required this.maxTeamSize,
    required this.status,
    this.prizePool,
    this.rules,
    this.requirements,
    this.judgingCriteria,
    this.eligibility,
    this.submissionRequirements,
    this.evaluationCriteria,
    this.communicationChannels,
    this.sponsors,
    this.isFeatured = false,
    this.landingPageType,
    this.customLandingUrl,
    this.landingColorScheme,
    this.landingLogoUrl,
    this.hasSponsors = false,
    this.sponsorsData,
    this.landingPageConfig,
    required this.createdAt,
    required this.updatedAt,
    this.participantCount = 0,
    this.teamCount = 0,
    this.submissionCount = 0,
  }) : title = name, // For backward compatibility
       prizes = prizePool; // For backward compatibility

  factory Hackathon.fromJson(Map<String, dynamic> json) {
    return Hackathon(
      id: json['id'].toString(),
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      type: json['type'],
      theme: json['theme'] ?? json['theme_focus_area'],
      location: json['location'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      applicationStartDate: json['application_start_date'] != null 
          ? DateTime.parse(json['application_start_date']) 
          : null,
      applicationEndDate: json['application_end_date'] != null 
          ? DateTime.parse(json['application_end_date']) 
          : null,
      maxParticipants: json['max_participants'],
      maxTeamSize: json['max_team_size'] ?? 4,
      status: json['status'] ?? 'draft',
      prizePool: json['prize_pool'] ?? json['prize_pool_details'],
      rules: json['rules'],
      requirements: json['requirements'],
      judgingCriteria: json['judging_criteria'],
      eligibility: json['eligibility'],
      submissionRequirements: json['submission_requirements'],
      evaluationCriteria: json['evaluation_criteria'],
      communicationChannels: json['communication_channels'],
      sponsors: json['sponsors'],
      isFeatured: json['is_featured'] ?? false,
      landingPageType: json['landing_page_type'],
      customLandingUrl: json['custom_landing_url'],
      landingColorScheme: json['landing_color_scheme'],
      landingLogoUrl: json['landing_logo_url'],
      hasSponsors: json['has_sponsors'] ?? false,
      sponsorsData: json['sponsors_data'],
      landingPageConfig: json['landing_page_config'],
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      participantCount: json['participant_count'] ?? 0,
      teamCount: json['team_count'] ?? 0,
      submissionCount: json['submission_count'] ?? 0,
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
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? maxParticipants,
    int? maxTeamSize,
    String? status,
    String? prizePool,
    String? rules,
    String? requirements,
    String? judgingCriteria,
    Map<String, dynamic>? landingPageConfig,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Hackathon(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      maxTeamSize: maxTeamSize ?? this.maxTeamSize,
      status: status ?? this.status,
      prizePool: prizePool ?? this.prizePool,
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
