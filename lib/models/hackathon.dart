import 'dart:convert';

enum HackathonType {
  online,
  offline,
  hybrid,
}

extension HackathonTypeExtension on HackathonType {
  String get value {
    switch (this) {
      case HackathonType.online:
        return 'online';
      case HackathonType.offline:
        return 'offline';
      case HackathonType.hybrid:
        return 'hybrid';
    }
  }

  String get displayName {
    switch (this) {
      case HackathonType.online:
        return 'Online';
      case HackathonType.offline:
        return 'Offline';
      case HackathonType.hybrid:
        return 'Hybrid';
    }
  }

  static HackathonType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'online':
        return HackathonType.online;
      case 'offline':
        return HackathonType.offline;
      case 'hybrid':
        return HackathonType.hybrid;
      default:
        throw ArgumentError('Invalid hackathon type: $value');
    }
  }
}

class HackathonCreationData {
  // General Information
  String name = '';
  String description = '';
  HackathonType? type;
  String themeFocusArea = '';

  // Event Details
  DateTime? startDate;  // Hackathon event start
  DateTime? endDate;    // Hackathon event end
  DateTime? applicationOpenDate;   // Keep for backward compatibility
  DateTime? applicationCloseDate;  // Keep for backward compatibility
  DateTime? applicationStartDate;  // When applications open
  DateTime? applicationEndDate;    // When applications close
  String prizePoolDetails = '';
  String timezone = 'UTC';
  String location = '';

  // Participant Settings
  String rules = '';
  int minTeamSize = 1;
  int maxTeamSize = 6;

  // Landing Page Configuration
  String landingPageType = 'template'; // 'template' or 'custom'
  String customLandingUrl = '';
  String landingColorScheme = '#1976d2';
  String landingLogoUrl = '';
  bool hasSponsors = false;
  List<Map<String, String>> sponsors = []; // [{name: '', logo: ''}]

  HackathonCreationData();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': type?.value,
      'theme_focus_area': themeFocusArea,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'application_open': applicationStartDate?.toIso8601String() ?? applicationOpenDate?.toIso8601String(),
      'application_close': applicationEndDate?.toIso8601String() ?? applicationCloseDate?.toIso8601String(),
      'application_start_date': applicationStartDate?.toIso8601String(),
      'application_end_date': applicationEndDate?.toIso8601String(),
      'prize_pool_details': prizePoolDetails,
      'timezone': timezone,
      'location': location,
      'rules': rules,
      'min_team_size': minTeamSize,
      'max_team_size': maxTeamSize,
      'landing_page_type': landingPageType,
      'custom_landing_url': customLandingUrl.isNotEmpty ? customLandingUrl : null,
      'landing_color_scheme': landingColorScheme,
      'landing_logo_url': landingLogoUrl.isNotEmpty ? landingLogoUrl : null,
      'has_sponsors': hasSponsors,
      'sponsors_data': hasSponsors && sponsors.isNotEmpty ? jsonEncode(sponsors) : null,
    };
  }

  bool isGeneralInfoValid() {
    return name.isNotEmpty && 
           description.isNotEmpty && 
           type != null;
  }

  bool isEventDetailsValid() {
    final appStart = applicationStartDate ?? applicationOpenDate;
    final appEnd = applicationEndDate ?? applicationCloseDate;
    
    return startDate != null && 
           endDate != null && 
           appStart != null &&
           appEnd != null &&
           prizePoolDetails.isNotEmpty &&
           appStart.isBefore(appEnd) &&
           appEnd.isBefore(startDate!) &&
           startDate!.isBefore(endDate!);
  }

  bool isParticipantSettingsValid() {
    return rules.isNotEmpty && 
           minTeamSize > 0 && 
           maxTeamSize >= minTeamSize;
  }

  bool isLandingPageValid() {
    if (landingPageType == 'custom') {
      return customLandingUrl.isNotEmpty;
    }
    // For template type, we just need basic info which is already validated
    return true;
  }
}

// For future use - basic hackathon model for display
class Hackathon {
  final String id;
  final String name;
  final String description;
  final HackathonType type;
  final String? themeFocusArea;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? applicationOpenDate;
  final DateTime? applicationCloseDate;
  final DateTime? applicationStartDate;  // New: When applications start
  final DateTime? applicationEndDate;    // New: When applications end
  final String prizePoolDetails;
  final String timezone;
  final String? location;
  final String rules;
  final int minTeamSize;
  final int maxTeamSize;
  final String status;
  final bool isFeatured;
  final int participantCount;
  final int teamCount;
  final int submissionCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  // Landing page configuration
  final String landingPageType;
  final String? customLandingUrl;
  final String landingColorScheme;
  final String? landingLogoUrl;
  final bool hasSponsors;
  final String? sponsorsData;

  Hackathon({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.themeFocusArea,
    required this.startDate,
    required this.endDate,
    this.applicationOpenDate,
    this.applicationCloseDate,
    this.applicationStartDate,
    this.applicationEndDate,
    required this.prizePoolDetails,
    required this.timezone,
    this.location,
    required this.rules,
    required this.minTeamSize,
    required this.maxTeamSize,
    required this.status,
    required this.isFeatured,
    required this.participantCount,
    required this.teamCount,
    required this.submissionCount,
    required this.createdAt,
    required this.updatedAt,
    this.landingPageType = 'template',
    this.customLandingUrl,
    this.landingColorScheme = '#1976d2',
    this.landingLogoUrl,
    this.hasSponsors = false,
    this.sponsorsData,
  });

  factory Hackathon.fromJson(Map<String, dynamic> json) {
    return Hackathon(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] != null 
          ? HackathonTypeExtension.fromString(json['type'])
          : HackathonType.online,
      themeFocusArea: json['theme_focus_area'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      applicationOpenDate: json['application_open'] != null 
          ? DateTime.parse(json['application_open'])
          : null,
      applicationCloseDate: json['application_close'] != null 
          ? DateTime.parse(json['application_close'])
          : null,
      applicationStartDate: json['application_start_date'] != null 
          ? DateTime.parse(json['application_start_date'])
          : null,
      applicationEndDate: json['application_end_date'] != null 
          ? DateTime.parse(json['application_end_date'])
          : null,
      prizePoolDetails: json['prize_pool_details'] ?? '',
      timezone: json['timezone'] ?? 'UTC',
      location: json['location'],
      rules: json['rules'] ?? '',
      minTeamSize: json['min_team_size'] ?? 1,
      maxTeamSize: json['max_team_size'] ?? 4,
      status: json['status'] ?? 'upcoming',
      isFeatured: json['is_featured'] ?? false,
      participantCount: json['participant_count'] ?? 0,
      teamCount: json['team_count'] ?? 0,
      submissionCount: json['submission_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      landingPageType: json['landing_page_type'] ?? 'template',
      customLandingUrl: json['custom_landing_url'],
      landingColorScheme: json['landing_color_scheme'] ?? '#1976d2',
      landingLogoUrl: json['landing_logo_url'],
      hasSponsors: json['has_sponsors'] ?? false,
      sponsorsData: json['sponsors_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.value,
      'theme_focus_area': themeFocusArea,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'application_open': applicationOpenDate?.toIso8601String(),
      'application_close': applicationCloseDate?.toIso8601String(),
      'application_start_date': applicationStartDate?.toIso8601String(),
      'application_end_date': applicationEndDate?.toIso8601String(),
      'prize_pool_details': prizePoolDetails,
      'timezone': timezone,
      'location': location,
      'rules': rules,
      'min_team_size': minTeamSize,
      'max_team_size': maxTeamSize,
      'status': status,
      'is_featured': isFeatured,
      'participant_count': participantCount,
      'team_count': teamCount,
      'submission_count': submissionCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'landing_page_type': landingPageType,
      'custom_landing_url': customLandingUrl,
      'landing_color_scheme': landingColorScheme,
      'landing_logo_url': landingLogoUrl,
      'has_sponsors': hasSponsors,
      'sponsors_data': sponsorsData,
    };
  }
}
