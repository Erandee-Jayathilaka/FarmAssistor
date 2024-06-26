import 'package:flutter/material.dart';
import 'package:firebase/Features/User_auth/FirebaseAuthImplementation/FirebaseAuthServices.dart';

class PlantTypeDropdown extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onPlantTypeChanged;

  const PlantTypeDropdown({Key? key, required this.onPlantTypeChanged}) : super(key: key);

  @override
  _PlantTypeDropdownState createState() => _PlantTypeDropdownState();
}

class _PlantTypeDropdownState extends State<PlantTypeDropdown> {
  FirebaseAuthService _authService = FirebaseAuthService();
  List<Map<String, dynamic>> plantTypes = [];
  Map<String, dynamic>? selectedPlantType;

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
        setState(() {
          plantTypes = devices.map((device) {
            return {
              ...device,
              'soilMoisture': (device['soilMoisture'] ?? 0).toDouble(),
            };
          }).toList();
        });
      } catch (e) {
        print('Error fetching plant types: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Map<String, dynamic>>(
      value: selectedPlantType,
      icon: Icon(Icons.arrow_drop_down),
      iconEnabledColor: Colors.black,
      style: TextStyle(color: Colors.black),
      dropdownColor: Color.fromARGB(255, 234, 249, 235),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade900),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green.shade900),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: plantTypes.map((Map<String, dynamic> value) {
        return DropdownMenuItem<Map<String, dynamic>>(
          value: value,
          child: Text(value['plantType'] ?? ''),
        );
      }).toList(),
      onChanged: (Map<String, dynamic>? newValue) {
        setState(() {
          selectedPlantType = newValue;
          if (newValue != null) {
            widget.onPlantTypeChanged(newValue);
          }
        });
      },
    );
  }
}
