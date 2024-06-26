import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static FirebaseAuthService get instance => FirebaseAuthService(); // Define static instance getter


  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  

  Future<void> saveDeviceInformation(String userId, String deviceId, String plantType, Map<String, dynamic> deviceInfo) async {
    try {
      await _firestore.collection('users').doc(userId).collection('devices').add({
        'deviceId': deviceId,
        'plantType': plantType,
        'soilMoistureChecked': deviceInfo['soilMoistureChecked'] ?? false,
        'soilTemperatureChecked': deviceInfo['soilTemperatureChecked'] ?? false,
        'soilNutrientChecked': deviceInfo['soilNutrientChecked'] ?? false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving device: $e');
      // Handle error, show error dialog, etc.
    }
  }

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print("Some error occurred");
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print("Some error occurred");
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
      return null;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<List<Map<String, dynamic>>> getDevices(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('devices')
          .get();

      // Convert QuerySnapshot to List<Map<String, dynamic>>
      List<Map<String, dynamic>> devicesList = querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

      return devicesList;
    } catch (e) {
      print('Error fetching devices: $e');
      return []; // Return an empty list on error
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showToast({required String message}) {
    print(message); // Placeholder for actual toast notification
  }
}
