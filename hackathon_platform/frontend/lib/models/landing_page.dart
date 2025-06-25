class LandingPageData {
  // Visual Branding
  String landingPageType;
  String? customLandingUrl;
  Map<String, String>? landingColorScheme;
  String landingPrimaryColor;
  String landingSecondaryColor;
  String landingAccentColor;
  String? landingLogoUrl;
  String landingLogoPosition;
  String? landingHeroBannerUrl;
  String? landingHeroOverlayText;
  String landingTypographyHeading;
  String landingTypographyBody;
  String landingBackgroundType;
  Map<String, dynamic>? landingBackgroundConfig;
  String landingButtonStyle;

  // Sponsor Management
  bool hasSponsors;
  List<SponsorData>? sponsorsData;

  // Event Highlights & Content
  List<String>? landingKeyFeatures;
  VenueInfo? landingVenueInfo;
  List<String>? landingVenuePhotos;

  // Interactive Elements
  List<FAQItem>? landingFaqData;
  ContactInfo? landingContactInfo;
  SocialMediaInfo? landingSocialMedia;
  bool landingRegistrationPreview;

  // Technical Features
  bool landingAnalyticsEnabled;
  String? landingSeoTitle;
  String? landingSeoDescription;
  String? landingSeoKeywords;
  bool landingMobileOptimized;
  int? landingPageViews;
  int? landingRegistrationClicks;

  LandingPageData({
    this.landingPageType = 'template',
    this.customLandingUrl,
    this.landingColorScheme,
    this.landingPrimaryColor = '#1976d2',
    this.landingSecondaryColor = '#424242',
    this.landingAccentColor = '#ff4081',
    this.landingLogoUrl,
    this.landingLogoPosition = 'center',
    this.landingHeroBannerUrl,
    this.landingHeroOverlayText,
    this.landingTypographyHeading = 'Roboto',
    this.landingTypographyBody = 'Open Sans',
    this.landingBackgroundType = 'solid',
    this.landingBackgroundConfig,
    this.landingButtonStyle = 'rounded',
    this.hasSponsors = false,
    this.sponsorsData,
    this.landingKeyFeatures,
    this.landingVenueInfo,
    this.landingVenuePhotos,
    this.landingFaqData,
    this.landingContactInfo,
    this.landingSocialMedia,
    this.landingRegistrationPreview = true,
    this.landingAnalyticsEnabled = true,
    this.landingSeoTitle,
    this.landingSeoDescription,
    this.landingSeoKeywords,
    this.landingMobileOptimized = true,
    this.landingPageViews,
    this.landingRegistrationClicks,
  });

  factory LandingPageData.fromJson(Map<String, dynamic> json) {
    return LandingPageData(
      landingPageType: json['landing_page_type'] ?? 'template',
      customLandingUrl: json['custom_landing_url'],
      landingColorScheme: json['landing_color_scheme'] != null
          ? Map<String, String>.from(json['landing_color_scheme'])
          : null,
      landingPrimaryColor: json['landing_primary_color'] ?? '#1976d2',
      landingSecondaryColor: json['landing_secondary_color'] ?? '#424242',
      landingAccentColor: json['landing_accent_color'] ?? '#ff4081',
      landingLogoUrl: json['landing_logo_url'],
      landingLogoPosition: json['landing_logo_position'] ?? 'center',
      landingHeroBannerUrl: json['landing_hero_banner_url'],
      landingHeroOverlayText: json['landing_hero_overlay_text'],
      landingTypographyHeading: json['landing_typography_heading'] ?? 'Roboto',
      landingTypographyBody: json['landing_typography_body'] ?? 'Open Sans',
      landingBackgroundType: json['landing_background_type'] ?? 'solid',
      landingBackgroundConfig: json['landing_background_config'],
      landingButtonStyle: json['landing_button_style'] ?? 'rounded',
      hasSponsors: json['has_sponsors'] ?? false,
      sponsorsData: json['sponsors_data'] != null
          ? (json['sponsors_data'] as List).map((e) => SponsorData.fromJson(e)).toList()
          : null,
      landingKeyFeatures: json['landing_key_features'] != null
          ? List<String>.from(json['landing_key_features'])
          : null,
      landingVenueInfo: json['landing_venue_info'] != null
          ? VenueInfo.fromJson(json['landing_venue_info'])
          : null,
      landingVenuePhotos: json['landing_venue_photos'] != null
          ? List<String>.from(json['landing_venue_photos'])
          : null,
      landingFaqData: json['landing_faq_data'] != null
          ? (json['landing_faq_data'] as List).map((e) => FAQItem.fromJson(e)).toList()
          : null,
      landingContactInfo: json['landing_contact_info'] != null
          ? ContactInfo.fromJson(json['landing_contact_info'])
          : null,
      landingSocialMedia: json['landing_social_media'] != null
          ? SocialMediaInfo.fromJson(json['landing_social_media'])
          : null,
      landingRegistrationPreview: json['landing_registration_preview'] ?? true,
      landingAnalyticsEnabled: json['landing_analytics_enabled'] ?? true,
      landingSeoTitle: json['landing_seo_title'],
      landingSeoDescription: json['landing_seo_description'],
      landingSeoKeywords: json['landing_seo_keywords'],
      landingMobileOptimized: json['landing_mobile_optimized'] ?? true,
      landingPageViews: json['landing_page_views'],
      landingRegistrationClicks: json['landing_registration_clicks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'landing_page_type': landingPageType,
      'custom_landing_url': customLandingUrl,
      'landing_color_scheme': landingColorScheme,
      'landing_primary_color': landingPrimaryColor,
      'landing_secondary_color': landingSecondaryColor,
      'landing_accent_color': landingAccentColor,
      'landing_logo_url': landingLogoUrl,
      'landing_logo_position': landingLogoPosition,
      'landing_hero_banner_url': landingHeroBannerUrl,
      'landing_hero_overlay_text': landingHeroOverlayText,
      'landing_typography_heading': landingTypographyHeading,
      'landing_typography_body': landingTypographyBody,
      'landing_background_type': landingBackgroundType,
      'landing_background_config': landingBackgroundConfig,
      'landing_button_style': landingButtonStyle,
      'has_sponsors': hasSponsors,
      'sponsors_data': sponsorsData?.map((e) => e.toJson()).toList(),
      'landing_key_features': landingKeyFeatures,
      'landing_venue_info': landingVenueInfo?.toJson(),
      'landing_venue_photos': landingVenuePhotos,
      'landing_faq_data': landingFaqData?.map((e) => e.toJson()).toList(),
      'landing_contact_info': landingContactInfo?.toJson(),
      'landing_social_media': landingSocialMedia?.toJson(),
      'landing_registration_preview': landingRegistrationPreview,
      'landing_analytics_enabled': landingAnalyticsEnabled,
      'landing_seo_title': landingSeoTitle,
      'landing_seo_description': landingSeoDescription,
      'landing_seo_keywords': landingSeoKeywords,
      'landing_mobile_optimized': landingMobileOptimized,
      'landing_page_views': landingPageViews,
      'landing_registration_clicks': landingRegistrationClicks,
    };
  }
}

class SponsorData {
  String name;
  String tier; // 'gold', 'silver', 'bronze', 'platinum'
  String? logoUrl;
  String? bannerUrl;
  String? website;
  String? description;
  String? location;
  Map<String, String>? socialLinks;

  SponsorData({
    required this.name,
    required this.tier,
    this.logoUrl,
    this.bannerUrl,
    this.website,
    this.description,
    this.location,
    this.socialLinks,
  });

  factory SponsorData.fromJson(Map<String, dynamic> json) {
    return SponsorData(
      name: json['name'] ?? '',
      tier: json['tier'] ?? 'bronze',
      logoUrl: json['logo_url'],
      bannerUrl: json['banner_url'],
      website: json['website'],
      description: json['description'],
      location: json['location'],
      socialLinks: json['social_links'] != null
          ? Map<String, String>.from(json['social_links'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tier': tier,
      'logo_url': logoUrl,
      'banner_url': bannerUrl,
      'website': website,
      'description': description,
      'location': location,
      'social_links': socialLinks,
    };
  }
}

class VenueInfo {
  String? name;
  String? address;
  String? description;
  List<String>? photos;
  bool? accessibilityInfo;
  String? parkingInfo;
  Map<String, dynamic>? coordinates; // lat, lng

  VenueInfo({
    this.name,
    this.address,
    this.description,
    this.photos,
    this.accessibilityInfo,
    this.parkingInfo,
    this.coordinates,
  });

  factory VenueInfo.fromJson(Map<String, dynamic> json) {
    return VenueInfo(
      name: json['name'],
      address: json['address'],
      description: json['description'],
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      accessibilityInfo: json['accessibility_info'],
      parkingInfo: json['parking_info'],
      coordinates: json['coordinates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'description': description,
      'photos': photos,
      'accessibility_info': accessibilityInfo,
      'parking_info': parkingInfo,
      'coordinates': coordinates,
    };
  }
}

class FAQItem {
  String question;
  String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });

  factory FAQItem.fromJson(Map<String, dynamic> json) {
    return FAQItem(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class ContactInfo {
  String? organizerName;
  String? email;
  String? phone;
  String? supportEmail;
  String? address;

  ContactInfo({
    this.organizerName,
    this.email,
    this.phone,
    this.supportEmail,
    this.address,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      organizerName: json['organizer_name'],
      email: json['email'],
      phone: json['phone'],
      supportEmail: json['support_email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organizer_name': organizerName,
      'email': email,
      'phone': phone,
      'support_email': supportEmail,
      'address': address,
    };
  }
}

class SocialMediaInfo {
  String? eventHashtag;
  String? twitter;
  String? linkedin;
  String? facebook;
  String? instagram;
  String? discord;
  String? slack;
  String? website;

  SocialMediaInfo({
    this.eventHashtag,
    this.twitter,
    this.linkedin,
    this.facebook,
    this.instagram,
    this.discord,
    this.slack,
    this.website,
  });

  factory SocialMediaInfo.fromJson(Map<String, dynamic> json) {
    return SocialMediaInfo(
      eventHashtag: json['event_hashtag'],
      twitter: json['twitter'],
      linkedin: json['linkedin'],
      facebook: json['facebook'],
      instagram: json['instagram'],
      discord: json['discord'],
      slack: json['slack'],
      website: json['website'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_hashtag': eventHashtag,
      'twitter': twitter,
      'linkedin': linkedin,
      'facebook': facebook,
      'instagram': instagram,
      'discord': discord,
      'slack': slack,
      'website': website,
    };
  }
}
