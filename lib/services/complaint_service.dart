import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swachh_bharat_app/services/cloudinary_service.dart';

import '../models/complaint.dart';

class ComplaintService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService();

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
          imageUrl = await _cloudinaryService.uploadImage(imageFile);
        } catch (e) {
          debugPrint('Error uploading image: $e');
          // Continue without image if upload fails
        }
      }

      // Create GeoPoint for the location
      final geoPoint = GeoPoint(position.latitude, position.longitude);
      final now = DateTime.now();

      // Create the complaint
      final complaint = Complaint(
        complaintId: docRef.id,
        userId: userId,
        category: category,
        description: description,
        photoUrl: imageUrl,
        location: geoPoint,
        address: address,
        status: 'Pending',
        assignedTo: null,
        progressImages: const [],
        createdAt: now,
        updatedAt: now,
      );

      // Convert to map and ensure publicId is included
      final complaintData = complaint.toMap();
      if (complaint.publicId != null) {
        complaintData['publicId'] = complaint.publicId;
      }

      // Save to Firestore
      await docRef.set(complaintData);
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

      // Upload image to Cloudinary
      final imageUrl = await _cloudinaryService.uploadImage(imageFile);

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

  // Get worker complaints as a list (one-time fetch)
  Future<List<Complaint>> getWorkerComplaintsList(String workerId) async {
    try {
      final snapshot = await _firestore
          .collection('complaints')
          .where('assignedTo', isEqualTo: workerId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs
          .map((doc) => Complaint.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting worker complaints list: $e');
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