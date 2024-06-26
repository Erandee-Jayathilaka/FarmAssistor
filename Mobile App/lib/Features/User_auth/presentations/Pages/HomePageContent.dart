// HomePageContent.dart

import 'package:flutter/material.dart';
import 'package:firebase/Features/User_auth/presentations/Pages/Gauges.dart';

class HomePageContent extends StatelessWidget {
  final String selectedPlantType;

  const HomePageContent({Key? key, required this.selectedPlantType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double soilMoisture = 75.0; // Replace with actual values
    double soilNutrient = 60.0; // Replace with actual values
    double soilTemperature = 25.0; // Replace with actual values

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Text(
          'Gauges for $selectedPlantType',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularGauge(parameter: 'Soil Moisture', value: soilMoisture),
            CircularGauge(parameter: 'Soil Nutrient', value: soilNutrient),
            VerticalLinearGauge(parameter: 'Soil Temperature', value: soilTemperature),
          ],
        ),
      ],
    );
  }
}
