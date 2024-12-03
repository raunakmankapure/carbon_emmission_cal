import 'package:flutter/material.dart';
import 'package:ridebuddy/models/trip.dart';
import 'package:intl/intl.dart';

class TripDetails extends StatelessWidget {
  final Trip trip;

  const TripDetails({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMMM dd, yyyy').format(trip.date),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(
            context,
            'Distance',
            '${trip.distance} km',
            Icons.directions_car,
          ),
          _buildDetailRow(
            context,
            'Fuel Type',
            trip.fuelType.toString().split('.').last,
            Icons.local_gas_station,
          ),
          _buildDetailRow(
            context,
            'Traffic',
            trip.trafficCondition.toString().split('.').last,
            Icons.traffic,
          ),
          _buildDetailRow(
            context,
            'Time',
            trip.tripTime.format(context),
            Icons.access_time,
          ),
          _buildDetailRow(
            context,
            'Riders',
            trip.numberOfRiders.toString(),
            Icons.people,
          ),
          Divider(
            height: 32,
            color: colorScheme.outlineVariant,
          ),
          _buildDetailRow(
            context,
            'Emissions Saved',
            trip.formattedEmissions,
            Icons.eco,
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    bool isHighlighted = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: isHighlighted
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: isHighlighted ? FontWeight.bold : null,
              color:
                  isHighlighted ? colorScheme.primary : colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
