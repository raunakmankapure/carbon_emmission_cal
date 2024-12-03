import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridebuddy/providers/trip_provider.dart';

class EcoSidebar extends StatelessWidget {
  const EcoSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        final trips = tripProvider.trips;
        final totalEmissions = trips.fold<double>(
          0,
          (sum, trip) => sum + trip.emissionsSaved,
        );

        final moneySaved = '₹${(totalEmissions * 0.15).toStringAsFixed(2)}';
        final waterSaved = totalEmissions * 0.5;
        final electricitySaved = totalEmissions * 0.3;

        return Drawer(
          backgroundColor: colorScheme.surface,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Eco Impact',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your Environmental Journey',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              _buildImpactTile(
                context,
                'Money Saved',
                moneySaved,
                Icons.savings,
                colorScheme.primary,
              ),
              _buildImpactTile(
                context,
                'Water Conserved',
                '${waterSaved.toStringAsFixed(1)}L',
                Icons.water_drop,
                Colors.blue,
              ),
              _buildImpactTile(
                context,
                'Energy Saved',
                '${electricitySaved.toStringAsFixed(1)} kWh',
                Icons.bolt,
                Colors.amber,
              ),
              _buildProgressSection(context, totalEmissions),
              const Divider(),
              _buildAchievementSection(context, trips.length),
              const Divider(),
              _buildMotivationalQuote(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImpactTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        value,
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, double totalEmissions) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = (totalEmissions / 1000000).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Carbon Reduction Goal',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% of 1 ton goal',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSection(BuildContext context, int totalTrips) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildAchievementBadge(
                context,
                'Beginner',
                Icons.eco,
                totalTrips >= 1,
              ),
              _buildAchievementBadge(
                context,
                'Regular',
                Icons.directions_car,
                totalTrips >= 10,
              ),
              _buildAchievementBadge(
                context,
                'Expert',
                Icons.star,
                totalTrips >= 50,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(
    BuildContext context,
    String label,
    IconData icon,
    bool isUnlocked,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isUnlocked
            ? colorScheme.primaryContainer
            : colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isUnlocked
                ? colorScheme.onPrimaryContainer
                : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isUnlocked
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMotivationalQuote(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.format_quote,
                color: colorScheme.onSecondaryContainer,
              ),
              const SizedBox(height: 8),
              Text(
                'Every sustainable choice you make today shapes a better tomorrow.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
