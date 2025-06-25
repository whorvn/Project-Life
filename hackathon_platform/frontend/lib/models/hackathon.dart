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
  // Landing page data
  final String? landingPageType;
  final String? customLandingUrl;
  final String? landingPrimaryColor;
  final String? landingSecondaryColor;
  final String? landingAccentColor;
  final String? landingLogoUrl;
  final String? landingLogoPosition;
  final String? landingHeroBannerUrl;
  final String? landingHeroOverlayText;
  final String? landingTypographyHeading;
  final String? landingTypographyBody;
  final String? landingBackgroundType;
  final Map<String, dynamic>? landingBackgroundConfig;
  final String? landingButtonStyle;
  final bool hasSponsors;
  final List<Map<String, dynamic>>? sponsorsData;
  final List<String>? landingKeyFeatures;
  final Map<String, dynamic>? landingVenueInfo;
  final List<String>? landingVenuePhotos;
  final List<Map<String, dynamic>>? landingFaqData;
  final Map<String, dynamic>? landingContactInfo;
  final Map<String, dynamic>? landingSocialMedia;
  final bool? landingRegistrationPreview;
  final bool? landingAnalyticsEnabled;
  final String? landingSeoTitle;
  final String? landingSeoDescription;
  final String? landingSeoKeywords;
  final bool? landingMobileOptimized;
  final int? landingPageViews;
  final int? landingRegistrationClicks;
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
    // Landing page fields
    this.landingPageType,
    this.customLandingUrl,
    this.landingPrimaryColor,
    this.landingSecondaryColor,
    this.landingAccentColor,
    this.landingLogoUrl,
    this.landingLogoPosition,
    this.landingHeroBannerUrl,
    this.landingHeroOverlayText,
    this.landingTypographyHeading,
    this.landingTypographyBody,
    this.landingBackgroundType,
    this.landingBackgroundConfig,
    this.landingButtonStyle,
    this.hasSponsors = false,
    this.sponsorsData,
    this.landingKeyFeatures,
    this.landingVenueInfo,
    this.landingVenuePhotos,
    this.landingFaqData,
    this.landingContactInfo,
    this.landingSocialMedia,
    this.landingRegistrationPreview,
    this.landingAnalyticsEnabled,
    this.landingSeoTitle,
    this.landingSeoDescription,
    this.landingSeoKeywords,
    this.landingMobileOptimized,
    this.landingPageViews,
    this.landingRegistrationClicks,
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
      // Landing page fields
      landingPageType: json['landing_page_type'],
      customLandingUrl: json['custom_landing_url'],
      landingPrimaryColor: json['landing_primary_color'],
      landingSecondaryColor: json['landing_secondary_color'],
      landingAccentColor: json['landing_accent_color'],
      landingLogoUrl: json['landing_logo_url'],
      landingLogoPosition: json['landing_logo_position'],
      landingHeroBannerUrl: json['landing_hero_banner_url'],
      landingHeroOverlayText: json['landing_hero_overlay_text'],
      landingTypographyHeading: json['landing_typography_heading'],
      landingTypographyBody: json['landing_typography_body'],
      landingBackgroundType: json['landing_background_type'],
      landingBackgroundConfig: json['landing_background_config'],
      landingButtonStyle: json['landing_button_style'],
      hasSponsors: json['has_sponsors'] ?? false,
      sponsorsData: json['sponsors_data'] != null
          ? List<Map<String, dynamic>>.from(json['sponsors_data'])
          : null,
      landingKeyFeatures: json['landing_key_features'] != null
          ? List<String>.from(json['landing_key_features'])
          : null,
      landingVenueInfo: json['landing_venue_info'],
      landingVenuePhotos: json['landing_venue_photos'] != null
          ? List<String>.from(json['landing_venue_photos'])
          : null,
      landingFaqData: json['landing_faq_data'] != null
          ? List<Map<String, dynamic>>.from(json['landing_faq_data'])
          : null,
      landingContactInfo: json['landing_contact_info'],
      landingSocialMedia: json['landing_social_media'],
      landingRegistrationPreview: json['landing_registration_preview'],
      landingAnalyticsEnabled: json['landing_analytics_enabled'],
      landingSeoTitle: json['landing_seo_title'],
      landingSeoDescription: json['landing_seo_description'],
      landingSeoKeywords: json['landing_seo_keywords'],
      landingMobileOptimized: json['landing_mobile_optimized'],
      landingPageViews: json['landing_page_views'],
      landingRegistrationClicks: json['landing_registration_clicks'],
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
