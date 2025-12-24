import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/complaint.dart';

class ComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Create a new complaint
  Future<Complaint> createComplaint({
    required String userId,
    required String category,
    required String description,
    required File? imageFile,
    required Position position,
  }) async {
    try {
      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String address = placemarks.isNotEmpty
          ? '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea} ${placemarks.first.postalCode}'
          : '${position.latitude}, ${position.longitude}';

      // Create complaint document first
      final docRef = _firestore.collection('complaints').doc();
      String? imageUrl;

      // Upload image if available
      if (imageFile != null && await imageFile.exists()) {
        try {
          final ref = _storage
              .ref()
              .child('complaints')
              .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
          await ref.putFile(imageFile);
          imageUrl = await ref.getDownloadURL();
        } catch (e) {
          debugPrint('Error uploading image: $e');
          // Continue without image if upload fails
        }
      }

      final complaint = Complaint(
        complaintId: docRef.id,
        userId: userId,
        category: category,
        description: description,
        photoUrl: imageUrl,
        location: GeoPoint(position.latitude, position.longitude),
        address: address,
        status: 'pending',
        assignedTo: null,
        progressImages: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await docRef.set(complaint.toMap());
      return complaint;
    } catch (e) {
      debugPrint('Error creating complaint: $e');
      rethrow;
    }
  }

  // Get stream of user's complaints
  Stream<List<Complaint>> streamUserComplaints(String userId) {
    return _firestore
        .collection('complaints')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Complaint.fromMap(doc.data()!))
            .toList());
  }

  // Get stream of worker's assigned complaints
  Stream<List<Complaint>> streamWorkerComplaints(String workerId) {
    return _firestore
        .collection('complaints')
        .where('assignedTo', isEqualTo: workerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Complaint.fromMap(doc.data()!))
            .toList());
  }

  // Get stream of all pending complaints (for admin/worker assignment)
  Stream<List<Complaint>> streamPendingComplaints() {
    return _firestore
        .collection('complaints')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Complaint.fromMap(doc.data()!))
            .toList());
  }

  // Update complaint status
  Future<void> updateComplaintStatus({
    required String complaintId,
    required String status,
    String? assignedTo,
  }) async {
    try {
      await _firestore.collection('complaints').doc(complaintId).update({
        'status': status,
        if (assignedTo != null) 'assignedTo': assignedTo,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating complaint status: $e');
      rethrow;
    }
  }

  // Add progress image to complaint
  Future<void> addProgressImage({
    required String complaintId,
    required File imageFile,
  }) async {
    try {
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist');
      }

      // Upload image to storage
      final ref = _storage
          .ref()
          .child('complaints')
          .child('progress')
          .child('$complaintId')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();

      // Add to complaint's progress images
      await _firestore.collection('complaints').doc(complaintId).update({
        'progressImages': FieldValue.arrayUnion([imageUrl]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error adding progress image: $e');
      rethrow;
    }
  }

  // Get stream of a single complaint
  Stream<Complaint> streamComplaint(String complaintId) {
    return _firestore
        .collection('complaints')
        .doc(complaintId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception('Complaint not found');
      }
      return Complaint.fromMap(doc.data()!);
    });
  }

  // Get a single complaint by ID
  Future<Complaint?> getComplaintById(String complaintId) async {
    try {
      final doc = await _firestore.collection('complaints').doc(complaintId).get();
      if (!doc.exists) {
        return null;
      }
      return Complaint.fromMap(doc.data()!);
    } catch (e) {
      debugPrint('Error getting complaint by ID: $e');
      rethrow;
    }
  }

  // Delete a complaint
  Future<void> deleteComplaint(String complaintId) async {
    try {
      await _firestore.collection('complaints').doc(complaintId).delete();
    } catch (e) {
      debugPrint('Error deleting complaint: $e');
      rethrow;
    }
  }
}