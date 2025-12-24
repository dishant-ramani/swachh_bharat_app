import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  
  // Set the current user (used after login)
  set currentUser(AppUser? user) {
    _currentUser = user;
    notifyListeners();
  }

  // Sign up with email and password
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      // Create user with email and password
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      final user = AppUser(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        role: role,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(user.toMap());

      // Notify listeners about the user change
      _currentUser = user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An error occurred. Please try again.';
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    _currentUser = null;
  }

  // Get current user data from Firestore
  Future<AppUser?> getCurrentUserData() async {
    if (_auth.currentUser == null) return null;
    
    try {
      final doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
          
      if (doc.exists) {
        _currentUser = AppUser.fromMap(doc.data()!..['uid'] = doc.id);
        return _currentUser;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      return null;
    }
  }

  // Update user profile
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
  }) async {
    if (_currentUser == null) return;

    try {
      final userData = _currentUser!.toMap()..remove('uid');
      
      if (name != null) userData['name'] = name;
      if (phone != null) userData['phone'] = phone;
      if (photoUrl != null) userData['photoUrl'] = photoUrl;

      await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .update(userData);

      // Update current user
      _currentUser = _currentUser!.copyWith(
        name: name ?? _currentUser!.name,
        phone: phone ?? _currentUser!.phone,
        photoUrl: photoUrl ?? _currentUser!.photoUrl,
      );
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      rethrow;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument({
    required String uid,
    required String email,
    required String name,
    required String role,
  }) async {
    final user = AppUser(
      uid: uid,
      name: name,
      email: email,
      role: role,
      phone: '',
      createdAt: DateTime.now(),
    );

    await _firestore.collection('users').doc(uid).set(user.toMap());
    _currentUser = user;
  }

  // Handle authentication errors
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
