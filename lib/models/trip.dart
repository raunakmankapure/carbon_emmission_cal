import 'package:flutter/material.dart';
import 'package:ridebuddy/utils/emissions_calculator.dart';

enum FuelType { petrol, diesel, ev }

enum TrafficCondition { light, moderate, heavy }

class Trip {
  final DateTime date;
  final double distance;
  final FuelType fuelType;
  final TrafficCondition trafficCondition;
  final int idleTime;
  final TimeOfDay tripTime;
  final int numberOfRiders;
  late final double emissionsSaved;

  Trip({
    required this.date,
    required this.distance,
    required this.fuelType,
    required this.trafficCondition,
    required this.idleTime,
    required this.tripTime,
    this.numberOfRiders = 1,
  }) {
    emissionsSaved = EmissionsCalculator.calculateEmissions(
      distance: distance,
      fuelType: fuelType,
      trafficCondition: trafficCondition,
      idleTime: idleTime,
      tripTime: tripTime,
      numberOfRiders: numberOfRiders,
    );
  }

  String get formattedEmissions => 
      EmissionsCalculator.formatEmissions(emissionsSaved);
}