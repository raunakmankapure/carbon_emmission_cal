import 'package:flutter/material.dart';
import 'package:ridebuddy/models/trip.dart';

class EmissionsCalculator {
  static const double baseEmissionRate = 251.0;

  static const double dieselAdjustment = 1.15;
  static const double moderateTrafficAdjustment = 1.10;
  static const double heavyTrafficAdjustment = 1.20;
  static const double nightTimeReduction = 0.95;
  static const double idleEmissionsPerMinute = 10.0;

  static double calculateEmissions({
    required double distance,
    required FuelType fuelType,
    required TrafficCondition trafficCondition,
    required int idleTime,
    required TimeOfDay tripTime,
    int numberOfRiders = 1,
  }) {
    double emissions = distance * baseEmissionRate;

    emissions *= _getFuelTypeMultiplier(fuelType);
    emissions *= _getTrafficConditionMultiplier(trafficCondition);

    if (numberOfRiders > 1) {
      emissions *= (1 - (1.0 / numberOfRiders));
    }

    emissions += _calculateIdleEmissions(idleTime);

    if (_isNightTime(tripTime)) {
      emissions *= nightTimeReduction;
    }
    return emissions;
  }

  static double _calculateIdleEmissions(int idleTimeMinutes) {
    return idleTimeMinutes * idleEmissionsPerMinute;
  }

  static double _getFuelTypeMultiplier(FuelType fuelType) {
    switch (fuelType) {
      case FuelType.diesel:
        return dieselAdjustment;
      case FuelType.ev:
        return 0.0;
      case FuelType.petrol:
        return 1.0;
    }
  }

  static double _getTrafficConditionMultiplier(TrafficCondition condition) {
    switch (condition) {
      case TrafficCondition.light:
        return 1.0;
      case TrafficCondition.moderate:
        return moderateTrafficAdjustment;
      case TrafficCondition.heavy:
        return heavyTrafficAdjustment;
    }
  }

  static bool _isNightTime(TimeOfDay time) {
    final hour = time.hour;
    return hour >= 20 || hour < 6;
  }

  static String formatEmissions(double emissions) {
    if (emissions >= 1000) {
      return '${(emissions / 1000).toStringAsFixed(2)} kg';
    }
    return '${emissions.toStringAsFixed(2)} g';
  }
}
