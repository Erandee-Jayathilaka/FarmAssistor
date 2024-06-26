import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase/Features/User_auth/FirebaseAuthImplementation/FirebaseAuthServices.dart';
import 'package:firebase/Features/User_auth/presentations/Pages/dropdown.dart'; // Adjust the import path as per your project structure
import 'package:firebase/Features/User_auth/presentations/Pages/Gauges.dart'; // Adjust the import path as per your project structure
import 'package:firebase/Features/User_auth/presentations/Pages/DevicesPage.dart'; // Adjust the import path as per your project structure






class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Map<String, dynamic>? selectedPlantType;
  double soilMoisture = 0.85;
  double soilNutrition = 0.76;
  double soilTemperature = 30;

  final FirebaseAuthService _authService = FirebaseAuthService(); // Initialize your FirebaseAuthService instance

  @override
  void initState() {
    super.initState();
    _fetchPlantTypes();
  }

  Future<void> _fetchPlantTypes() async {
    String? userId = _authService.getCurrentUserId();
    if (userId != null) {
      try {
        List<Map<String, dynamic>> devices = await _authService.getDevices(userId);
        if (devices.isNotEmpty) {
          setState(() {
            selectedPlantType = devices.first; // Initialize with the first device data
            soilMoisture = (devices.first['soilMoisture'] ?? 0).toDouble();
            soilNutrition = (devices.first['soilNutrient'] ?? 0).toDouble();
            soilTemperature = (devices.first['soilTemperature'] ?? 0).toDouble();
          });
        }
      } catch (e) {
        print('Error fetching plant types: $e');
      }
    }
  }

  void _onPlantTypeChanged(Map<String, dynamic> newPlantType) {
    setState(() {
      selectedPlantType = newPlantType;
      // Optionally, you can fetch new device data based on the selected plant type here
      // Example: _fetchDeviceData(selectedPlantType);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Colors.green.shade900,
              title: Text(
                "Home Page",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, "/login");
                  },
                ),
              ],
              automaticallyImplyLeading: false, // Removes the back button
            )
          : null,
      body: _selectedIndex == 0
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 30), // Add SizedBox with height 30 only on HomePage
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: PlantTypeDropdown(
                      onPlantTypeChanged: _onPlantTypeChanged,
                    ),
                  ),
                  SizedBox(height: 20), // Add SizedBox with height 20 for spacing
                  Container( // Wrap with a container to add padding
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SoilMoistureGauge(value: 0.85),
                        SizedBox(height: 20),
                        SoilNutritionGauge(value: 0.76),
                        SizedBox(height: 20),
                        SoilTemperatureGauge(value: 30),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : DevicesPage(), // Show DevicesPage when _selectedIndex is not 0
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.devices),
            label: 'Devices',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade900,
        onTap: _onItemTapped,
      ),
    );
  }
}

