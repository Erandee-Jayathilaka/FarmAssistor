import 'package:flutter/material.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  _AddDeviceScreenState createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  bool soilMoistureChecked = true;
  bool soilTemperatureChecked = true;
  bool soilNutrientChecked = true;

  final TextEditingController deviceIdController = TextEditingController();
  final TextEditingController plantTypeController = TextEditingController();

  String? deviceIdError;
  String? plantTypeError;

  bool isAddButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Initially, the "Add" button should be disabled and colorless
    updateAddButtonEnabledState();
  }

  void updateAddButtonEnabledState() {
    // Enable the button if at least one checkbox is checked and both fields are not empty
    bool isAtLeastOneCheckboxChecked =
        soilMoistureChecked || soilTemperatureChecked || soilNutrientChecked;
    bool isFieldsNotEmpty =
        deviceIdController.text.isNotEmpty && plantTypeController.text.isNotEmpty;
    setState(() {
      isAddButtonEnabled = isAtLeastOneCheckboxChecked && isFieldsNotEmpty;
    });
  }

  int _convertBoolToNumeric(bool value) {
    return value ? 1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Device'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: deviceIdController,
              onChanged: (value) {
                setState(() {
                  deviceIdError = value.isEmpty ? 'Device ID cannot be empty' : null;
                  updateAddButtonEnabledState();
                });
              },
              decoration: InputDecoration(
                labelText: 'Device ID',
                errorText: deviceIdError,
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: plantTypeController,
              onChanged: (value) {
                setState(() {
                  plantTypeError = value.isEmpty ? 'Plant Type cannot be empty' : null;
                  updateAddButtonEnabledState();
                });
              },
              decoration: InputDecoration(
                labelText: 'Plant Type',
                errorText: plantTypeError,
              ),
            ),
            SizedBox(height: 60),
            Text(
              'Parameters to measure:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: Text('Soil Moisture Level'),
              value: soilMoistureChecked,
              onChanged: (value) {
                setState(() {
                  soilMoistureChecked = value ?? false;
                  updateAddButtonEnabledState();
                });
              },
            ),
            CheckboxListTile(
              title: Text('Soil Temperature'),
              value: soilTemperatureChecked,
              onChanged: (value) {
                setState(() {
                  soilTemperatureChecked = value ?? false;
                  updateAddButtonEnabledState();
                });
              },
            ),
            CheckboxListTile(
              title: Text('Soil Nutrient Level'),
              value: soilNutrientChecked,
              onChanged: (value) {
                setState(() {
                  soilNutrientChecked = value ?? false;
                  updateAddButtonEnabledState();
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cancel button action
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red), // Red button
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white), // White text
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isAddButtonEnabled
                      ? () {
                          // Return the entered values and checkbox preferences to the previous screen
                          Navigator.pop(context, {
                            'deviceId': deviceIdController.text,
                            'plantType': plantTypeController.text,
                            'soilMoistureChecked': _convertBoolToNumeric(soilMoistureChecked),
                            'soilTemperatureChecked': _convertBoolToNumeric(soilTemperatureChecked),
                            'soilNutrientChecked': _convertBoolToNumeric(soilNutrientChecked),
                          });
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Colorless when disabled
                      }
                      return Colors.green.shade900; // Green when enabled
                    }),
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ), // White text
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                  ),
                  child: Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}