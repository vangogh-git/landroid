import 'package:flutter/material.dart';

class AppLocale {
  static Locale _locale = const Locale('en');

  static Locale get locale => _locale;

  static void setLocale(Locale locale) {
    _locale = locale;
  }

  static bool get isTamil => _locale.languageCode == 'ta';

  static String get(String key) {
    return _translations[key]?[_locale.languageCode] ?? key;
  }

  static final Map<String, Map<String, String>> _translations = {
    'My Parcel': {'en': 'My Parcel', 'ta': 'என் ஏக்கர்'},
    'Consultant Panel': {'en': 'Consultant Panel', 'ta': 'ஆலோசனை பலகை'},
    'Parcels Managed': {
      'en': 'Parcels Managed',
      'ta': 'நிர்வகிக்கப்படும் ஏக்கர்கள்'
    },
    'Alerts': {'en': 'Alerts', 'ta': 'விழிப்பூட்டல்கள்'},
    'Active': {'en': 'Active', 'ta': 'சுறுசும'},
    'Health Status': {'en': 'Health Status', 'ta': 'ஆரோக்கிய நிலை'},
    'Health Score': {'en': 'Health Score', 'ta': 'ஆரோக்கிய மதிப்பு'},
    'Parcel Area': {'en': 'Parcel Area', 'ta': 'ஏக்கர் பகுதி'},
    'Tools': {'en': 'Tools', 'ta': 'கருவிகள்'},
    'AI Modules': {'en': 'AI Modules', 'ta': 'AI தொகுதிகள்'},
    'GIS Parcel Map': {'en': 'GIS Parcel Map', 'ta': 'GIS ஏக்கர் வரைபடம்'},
    'Boundary, satellite, layers': {
      'en': 'Boundary, satellite, layers',
      'ta': 'எல்லை, செய்மதி, அடுக்குகள்'
    },
    'Land Health Dashboard': {
      'en': 'Land Health Dashboard',
      'ta': ' நில ஆரோக்கிய பலகை'
    },
    'Composite score · Soil · NDVI · Rainfall': {
      'en': 'Composite score · Soil · NDVI · Rainfall',
      'ta': 'கூட்டு மதிப்பு · மண் · NDVI · மழை'
    },
    'Plant Health Zones': {
      'en': 'Plant Health Zones',
      'ta': 'தாவர ஆரோக்கிய மண்டலங்கள்'
    },
    'NDVI zone classification': {
      'en': 'NDVI zone classification',
      'ta': 'NDVI மண்டல வகைப்படுத்தல்'
    },
    'Land Valuation': {'en': 'Land Valuation', 'ta': 'நில மதிப்பு'},
    'Value estimate · Price bands · Factors': {
      'en': 'Value estimate · Price bands · Factors',
      'ta': 'மதிப்பு மதிப்பீடு · விலை அதிரவை · காரணிகள்'
    },
    'Moderate': {'en': 'Moderate', 'ta': 'மிதமான'},
    'Fetching land intelligence...': {
      'en': 'Fetching land intelligence...',
      'ta': 'நல்லதோர் தகவல்களைப் பெறுகிறோம்...'
    },
    'Signal Breakdown': {'en': 'Signal Breakdown', 'ta': 'குறியீடு விளக்கம்'},
    'NDVI Vegetation': {'en': 'NDVI Vegetation', 'ta': 'NDVI காய்ப்பு'},
    'Rainfall Adequacy': {'en': 'Rainfall Adequacy', 'ta': 'மழையின் போதுமானது'},
    'Soil Quality': {'en': 'Soil Quality', 'ta': 'மண் தரம்'},
    'Temperature': {'en': 'Temperature', 'ta': 'வெப்பநிலை'},
    'Soil Details': {'en': 'Soil Details', 'ta': 'மண் விவரங்கள்'},
    'pH': {'en': 'pH', 'ta': 'pH'},
    'Organic Carbon': {'en': 'Organic Carbon', 'ta': 'கரிம கார்பன்'},
    'Texture': {'en': 'Texture', 'ta': 'அமைப்பு'},
    'Data Confidence': {'en': 'Data Confidence', 'ta': 'தர நம்பக்கருத்து'},
    'Last fetched': {'en': 'Last fetched', 'ta': 'கடைசியாக பெறப்பட்ட'},
    'Coords': {'en': 'Coords', 'ta': 'அடைவு'},
    'Estimated Value Range': {
      'en': 'Estimated Value Range',
      'ta': 'மதிப்பிடப்பட்ட வரம்பு'
    },
    'Low': {'en': 'Low', 'ta': 'குறைந்த'},
    'Mid': {'en': 'Mid', 'ta': 'நடு'},
    'High': {'en': 'High', 'ta': 'உயர்ந்த'},
    'Composite Score': {'en': 'Composite Score', 'ta': 'கூட்டு மதிப்பு'},
    'Confidence': {'en': 'Confidence', 'ta': 'நம்பக்கருத்து'},
    'Top Factors': {'en': 'Top Factors', 'ta': 'முக்கிய காரணிகள்'},
    'Soil Quality Factor': {'en': 'Soil Quality', 'ta': 'மண் தரம்'},
    'Rainfall': {'en': 'Rainfall', 'ta': 'மழை'},
    'OSM Proximity': {'en': 'OSM Proximity', 'ta': 'OSM அருகாமை'},
    'Night Light': {'en': 'Night Light', 'ta': 'இரவு வெளிச்சம்'},
    'Access restricted to consultants only.': {
      'en': 'Access restricted to consultants only.',
      'ta': 'ஆலோசனைக்கு மட்டுமான அணுகல்.'
    },
    'Select Role': {'en': 'Select Role', 'ta': 'வகையைத் தேர்ந்தெடுக்கவும்'},
    'Land Consultant': {'en': 'Land Consultant', 'ta': 'நில ஆலோசகர்'},
    'Farmer': {'en': 'Farmer', 'ta': 'விவசாயி'},
    'Land Health': {'en': 'Land Health', 'ta': 'நல ஆரோக்கியம்'},
  };
}
