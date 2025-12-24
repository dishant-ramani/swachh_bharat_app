import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get user data by UID
  /// This is an alias for [getUser] to maintain backward compatibility
  Future<AppUser?> getUserData(String uid) async => getUser(uid);

  /// Get user data by UID
  Future<AppUser?> getUser(String uid) async {
    try {
      if (uid.isEmpty) return null;
      
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return AppUser.fromMap(doc.data()!..['uid'] = doc.id);
      }
      return null;
    } catch (e) {
      throw 'Error fetching user data: $e';
    }
  }

  /// Get current user data
  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return getUser(user.uid);
  }

  /// Update user data
  Future<void> updateUser({
    required String uid,
    String? name,
    String? phone,
    String? photoUrl,
    String? fcmToken,
  }) async {
    try {
      final userData = <String, dynamic>{};
      
      if (name != null) userData['name'] = name;
      if (phone != null) userData['phone'] = phone;
      if (photoUrl != null) userData['photoUrl'] = photoUrl;
      if (fcmToken != null) userData['fcmToken'] = fcmToken;

      await _firestore.collection('users').doc(uid).update(userData);
    } catch (e) {
      throw 'Error updating user data: $e';
    }
  }

  /// Update current user's FCM token for push notifications
  Future<void> updateFcmToken(String? token) async {
    if (token == null || _auth.currentUser == null) return;
    
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'fcmToken': token,
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Error updating FCM token: $e';
    }
  }


  /// Get all workers
  Stream<List<AppUser>> getWorkers() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'worker')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppUser.fromMap(doc.data()..['uid'] = doc.id))
            .toList());
  }

  /// Get stream of the current authenticated user
  Stream<AppUser?> userStream() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return await getUser(user.uid);
    });
  }

  /// Get user data stream by UID
  Stream<AppUser?> getUserStream(String uid) {
    if (uid.isEmpty) {
      return Stream.value(null);
    }
    
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? AppUser.fromMap(doc.data()!..['uid'] = doc.id) : null);
  }

  /// Update user's last active timestamp
  Future<void> updateLastActive(String uid) async {
    if (uid.isEmpty) return;
    
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating last active: $e');
    }
  }
}
