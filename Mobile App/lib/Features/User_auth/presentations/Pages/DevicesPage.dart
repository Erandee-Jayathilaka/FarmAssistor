import 'package:firebase/Features/User_auth/presentations/Pages/add_device.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DevicesPage extends StatefulWidget {
  const DevicesPage({Key? key}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late User? _currentUser;
  late String _userId;
  List<Map<String, dynamic>> _devices = [];

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      _userId = _currentUser!.uid;
      _fetchDevices();
    }
  }

 Future<void> _fetchDevices() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('devices')
          .get();

      setState(() {
        _devices = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching devices: $e');
    }
  }

  Future<void> _deleteDevice(String deviceId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('devices')
          .where('deviceId', isEqualTo: deviceId)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      // After deletion, fetch updated list of devices
      await _fetchDevices();
    } catch (e) {
      print('Error deleting device: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text("Devices",style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  _showAddDeviceScreen(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.green.shade900,
                  ),
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  "+ Add a device",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          Expanded(
  child: ListView.builder(
    itemCount: _devices.length,
    itemBuilder: (context, index) {
      final device = _devices[index];
      String deviceId = device['deviceId'];
      String plantType = device['plantType'];
      int soilMoistureChecked = device['soilMoistureChecked'] ?? 0;
      int soilTemperatureChecked = device['soilTemperatureChecked'] ?? 0;
      int soilNutrientChecked = device['soilNutrientChecked'] ?? 0;

      return Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4, // Optional: add elevation for a shadow effect
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Device ID: $deviceId'),
              Text('Plant Type: $plantType'),
              Text('Soil Moisture: $soilMoistureChecked %'),
              Text('Soil Temperature: $soilTemperatureChecked °C'),
              Text('Soil Nutrition: $soilNutrientChecked %'),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Delete Device'),
                    content: Text('Are you sure you want to delete device $deviceId?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _deleteDevice(deviceId); // Call delete function
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      );
    },
  ),
),
        ],
      ),
    );
  }

  Future<void> _showAddDeviceScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDeviceScreen()),
    );

    if (result != null) {
      String deviceId = result['deviceId'];
      String plantType = result['plantType'];
      int soilMoistureChecked = result['soilMoistureChecked'];
      int soilTemperatureChecked = result['soilTemperatureChecked'];
      int soilNutrientChecked = result['soilNutrientChecked'];

      try {
        // Save the new device to Firestore
        await _firestore
            .collection('users')
            .doc(_userId)
            .collection('devices')
            .add({
          'deviceId': deviceId,
          'plantType': plantType,
          'soilMoistureChecked': soilMoistureChecked,
          'soilTemperatureChecked': soilTemperatureChecked,
          'soilNutrientChecked': soilNutrientChecked,
        });


        // Fetch updated devices list after adding a new device
        await _fetchDevices();
      } catch (e) {
        print('Error adding device: $e');
      }
    }
  }
}