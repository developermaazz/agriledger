import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.phoneE164,
    required this.isVerified,
    this.createdAt,
  });

  final String name;
  final String email;
  final String phoneE164;
  final bool isVerified;
  final DateTime? createdAt;

  static UserProfile? fromMap(Map<String, dynamic>? data) {
    if (data == null) return null;
    final created = data['createdAt'];
    DateTime? createdAt;
    if (created is Timestamp) {
      createdAt = created.toDate();
    }
    return UserProfile(
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      phoneE164: data['phoneE164'] as String? ?? '',
      isVerified: data['isVerified'] as bool? ?? false,
      createdAt: createdAt,
    );
  }
}
