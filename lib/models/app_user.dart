import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:math';

class AppUser {
  final String uid;
  final String publicId;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? photoUrl;
  final String? fcmToken;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    String? publicId,
    required this.name,
    required this.email,
    this.phone = "",
    required this.role,
    this.photoUrl,
    this.fcmToken,
    required this.createdAt,
  }) : publicId = publicId ?? _generatePublicId();

  static String _generatePublicId() {
    final now = DateTime.now();
    final year = now.year.toString().substring(2); // Get last 2 digits of year
    final month = now.month.toString().padLeft(2, '0'); // Ensure 2-digit month
    
    final random = Random();
    const chars = '0123456789';
    final randomString = String.fromCharCodes(Iterable.generate(
      4, // 4-digit random number
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
    
    return 'SB-U-$year$month-$randomString';
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'publicId': publicId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'photoUrl': photoUrl,
      'fcmToken': fcmToken,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      publicId: map['publicId'] ?? _generatePublicId(),
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'user',
      photoUrl: map['photoUrl'],
      fcmToken: map['fcmToken'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  AppUser copyWith({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? fcmToken,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role,
      photoUrl: photoUrl ?? this.photoUrl,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt,
    );
  }
}
