import 'package:flutter/material.dart';
import 'package:ridebuddy/utils/eco_impact_calculator.dart';

class ImpactSummary extends StatelessWidget {
  final double totalEmissionsSaved;
  final int totalTrips;
  final int totalRiders;

  const ImpactSummary({
    super.key,
    required this.totalEmissionsSaved,
    required this.totalTrips,
    required this.totalRiders,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.eco_outlined,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Environmental Impact',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.dark_mode,
                color: colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildImpactCard(
                context,
                Icons.eco,
                EcoImpactCalculator.formatEmissions(totalEmissionsSaved),
                'CO₂ Saved',
                Colors.green,
              ),
            ),
            Expanded(
              child: _buildImpactCard(
                context,
                Icons.directions_car_outlined,
                totalTrips.toString(),
                'Total Trips',
                colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 32,
          decoration: BoxDecoration(
            color: Colors.yellow[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: List.generate(
              20,
              (index) => Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: Colors.yellow[800]!,
                        width: 2,
                      ),
                    ),
                    color: index < (totalTrips / 2).floor()
                        ? Colors.yellow[800]
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (totalTrips == 0)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Add your first trip to start tracking your environmental impact!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildImpactCard(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
