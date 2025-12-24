import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final String feedbackId;
  final String complaintId;
  final String userId;
  final int rating;
  final String message;
  final DateTime createdAt;

  FeedbackModel({
    required this.feedbackId,
    required this.complaintId,
    required this.userId,
    required this.rating,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'feedbackId': feedbackId,
      'complaintId': complaintId,
      'userId': userId,
      'rating': rating,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      feedbackId: map['feedbackId'] ?? '',
      complaintId: map['complaintId'] ?? '',
      userId: map['userId'] ?? '',
      rating: map['rating']?.toInt() ?? 0,
      message: map['message'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  FeedbackModel copyWith({
    String? feedbackId,
    String? complaintId,
    String? userId,
    int? rating,
    String? message,
    DateTime? createdAt,
  }) {
    return FeedbackModel(
      feedbackId: feedbackId ?? this.feedbackId,
      complaintId: complaintId ?? this.complaintId,
      userId: userId ?? this.userId,
      rating: rating ?? this.rating,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
