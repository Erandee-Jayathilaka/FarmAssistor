import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class SoilMoistureGauge extends StatelessWidget {
  final double value;

  const SoilMoistureGauge({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularGauge(
      value: value * 100, // Assuming `value` is in the range of 0 to 1
      title: 'Soil Moisture Level',
      unit: '%',
      ranges: [
        GaugeRange(startValue: 0, endValue: 33, color: Colors.red),
        GaugeRange(startValue: 33, endValue: 66, color: Colors.yellow),
        GaugeRange(startValue: 66, endValue: 100, color: Colors.green),
      ],
    );
  }
}

class SoilNutritionGauge extends StatelessWidget {
  final double value;

  const SoilNutritionGauge({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularGauge(
      value: value * 100, // Assuming `value` is in the range of 0 to 1
      title: 'Soil Nutrition Content',
      unit: '%',
      ranges: [
        GaugeRange(startValue: 0, endValue: 33, color: Colors.red),
        GaugeRange(startValue: 33, endValue: 66, color: Colors.yellow),
        GaugeRange(startValue: 66, endValue: 100, color: Colors.green),
      ],
    );
  }
}

class SoilTemperatureGauge extends StatelessWidget {
  final double value;

  const SoilTemperatureGauge({Key? key, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularGauge(
      value: value,
      title: 'Soil Temperature',
      unit: '°C',
      ranges: [
        GaugeRange(startValue: 0, endValue: 10, color: Colors.blue),
        GaugeRange(startValue: 10, endValue: 20, color: Colors.green),
        GaugeRange(startValue: 20, endValue: 30, color: Colors.orange),
        GaugeRange(startValue: 30, endValue: 50, color: Colors.red),
      ],
    );
  }
}

class CircularGauge extends StatelessWidget {
  final double value;
  final String title;
  final String unit;
  final List<GaugeRange> ranges;

  const CircularGauge({
    Key? key,
    required this.value,
    required this.title,
    required this.unit,
    required this.ranges,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 100,
          pointers: <GaugePointer>[
            NeedlePointer(value: value),
          ],
          ranges: ranges,
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                '${value.toStringAsFixed(1)} $unit',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              angle: 90,
              positionFactor: 0.5,
            ),
            GaugeAnnotation(
              widget: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              angle: 90,
              positionFactor: 1.1,
            ),
          ],
        ),
      ],
    );
  }
}
