import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsModel {
  final bool locationNotificationsEnabled;

  SettingsModel({
    required this.locationNotificationsEnabled,
  });

  // Convert Map → SettingsModel
  factory SettingsModel.fromMap(Map<String, dynamic> data) {
    return SettingsModel(
      locationNotificationsEnabled:
          data['locationNotificationsEnabled'] ?? false,
    );
  }

  // Convert SettingsModel → Map
  Map<String, dynamic> toMap() {
    return {
      'locationNotificationsEnabled': locationNotificationsEnabled,
    };
  }
}