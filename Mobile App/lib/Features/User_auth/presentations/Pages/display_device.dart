import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addDevice(String userId, Map<String, dynamic> deviceInfo) async {
    try {
      await _firestore.collection('users').doc(userId).collection('devices').add({
        'deviceId': deviceInfo['deviceId'],
        'plantType': deviceInfo['plantType'],
        'soilMoistureChecked': deviceInfo['soilMoistureChecked'] ? 1 : 0, // Convert boolean to numeric
        'soilTemperatureChecked': deviceInfo['soilTemperatureChecked'] ? 1 : 0, // Convert boolean to numeric
        'soilNutrientChecked': deviceInfo['soilNutrientChecked'] ? 1 : 0, // Convert boolean to numeric
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding device: $e");
      // Handle error as needed
    }
  }
}