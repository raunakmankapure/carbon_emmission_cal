import 'package:intl/intl.dart';

class EcoImpactCalculator {
  static const double co2PerTreePerYear = 21770;

  static String formatEmissions(double emissions) {
    if (emissions >= 1000000) {
      return '${(emissions / 1000000).toStringAsFixed(2)} t';
    } else if (emissions >= 1000) {
      return '${(emissions / 1000).toStringAsFixed(2)} kg';
    }
    return '${emissions.toStringAsFixed(2)} g';
  }

  static int calculateTreesEquivalent(double totalEmissions) {
    double yearlyEmissions = totalEmissions * (365 / 30);
    return (yearlyEmissions / co2PerTreePerYear).ceil();
  }

  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return NumberFormat('#,##0').format(number);
  }

  static List<String> getMilestoneMessages(double totalEmissions) {
    final List<String> messages = [];

    if (totalEmissions >= 1000000) {
      messages.add('You\'ve saved a ton of CO₂! Literally! 🌍');
    }
    if (totalEmissions >= 500000) {
      messages.add('Your impact equals planting a small forest! 🌳');
    }
    if (totalEmissions >= 100000) {
      messages.add('You\'re making a real difference! 🌱');
    }
    if (totalEmissions >= 50000) {
      messages.add('Keep up the great work! Every ride counts! 🚗');
    }

    return messages;
  }

  static String getMotivationalMessage(int totalTrips) {
    if (totalTrips == 0) {
      return 'Start your eco-friendly journey today!';
    } else if (totalTrips < 5) {
      return 'Great start! Keep those green rides coming!';
    } else if (totalTrips < 10) {
      return 'You\'re becoming a sustainability champion!';
    } else if (totalTrips < 20) {
      return 'Amazing progress! You\'re making Earth smile!';
    } else {
      return 'You\'re a true eco-warrior! Outstanding!';
    }
  }
}
