import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class Complaint {
  final String complaintId;
  final String publicId;
  final String userId;
  final String category;
  final String description;
  final String? photoUrl;
  final GeoPoint location;
  final String address;
  final String status;
  final String? assignedTo;
  final List<String> progressImages;
  final DateTime createdAt;
  final DateTime updatedAt;

  Complaint({
    required this.complaintId,
    String? publicId,
    required this.userId,
    required this.category,
    required this.description,
    this.photoUrl,
    required this.location,
    required this.address,
    this.status = 'Pending',
    this.assignedTo,
    List<String>? progressImages,
    required this.createdAt,
    required this.updatedAt,
  }) : progressImages = progressImages ?? [],
       publicId = publicId ?? _generatePublicId(createdAt, location);

  static String _generatePublicId(DateTime createdAt, GeoPoint location) {
    // Create a hash from latitude and longitude (first 4 digits of each)
    final latStr = location.latitude.toString().replaceAll('.', '').padRight(8, '0').substring(0, 4);
    final longStr = location.longitude.toString().replaceAll('.', '').padRight(8, '0').substring(0, 4);
    final latLongHash = '$latStr$longStr';
    
    // Generate a 4-digit random number
    final random = Random();
    const digits = '0123456789';
    final randomString = String.fromCharCodes(Iterable.generate(
      4,
      (_) => digits.codeUnitAt(random.nextInt(digits.length)),
    ));
    
    return 'SC-$latLongHash-$randomString';
  }

  Map<String, dynamic> toMap() {
    return {
      'complaintId': complaintId,
      'publicId': publicId,
      'userId': userId,
      'category': category,
      'description': description,
      'photoUrl': photoUrl,
      'location': GeoPoint(location.latitude, location.longitude),
      'address': address,
      'status': status,
      'assignedTo': assignedTo,
      'progressImages': progressImages,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      publicId: map['publicId'],
      complaintId: map['complaintId'] ?? '',
      userId: map['userId'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      photoUrl: map['photoUrl'],
      location: map['location'] as GeoPoint,
      address: map['address'] ?? '',
      status: map['status'] ?? 'Pending',
      assignedTo: map['assignedTo'],
      progressImages: List<String>.from(map['progressImages'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Complaint copyWith({
    String? status,
    String? assignedTo,
    List<String>? progressImages,
    DateTime? updatedAt,
  }) {
    return Complaint(
      complaintId: complaintId,
      userId: userId,
      category: category,
      description: description,
      photoUrl: photoUrl,
      location: location,
      address: address,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      progressImages: progressImages ?? this.progressImages,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isResolved => status == 'Resolved';
  bool get isInProgress => status == 'InProgress';
  bool get isAssigned => status == 'Assigned';
  bool get isPending => status == 'Pending';
}
