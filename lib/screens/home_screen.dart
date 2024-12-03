import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridebuddy/widgets/emissions_chart.dart';
import 'package:ridebuddy/widgets/trip_details.dart';
import 'package:ridebuddy/providers/theme_provider.dart';
import 'package:ridebuddy/providers/trip_provider.dart';
import 'package:ridebuddy/screens/add_trip_screen.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedTripIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _selectTrip(int index) {
    setState(() {
      selectedTripIndex = selectedTripIndex == index ? null : index;
    });
  }

  void _showUndoSnackBar(BuildContext context, TripProvider tripProvider,
      dynamic trip, int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Trip deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            tripProvider.insertTrip(index, trip);
            if (selectedTripIndex != null && selectedTripIndex! >= index) {
              setState(() {
                selectedTripIndex = selectedTripIndex! + 1;
              });
            }
          },
        ),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.1,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: colorScheme.onSurface,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primaryContainer,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          '🎉 Hooray, its Ridebuddy!',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: selectedTripIndex != null
                  ? colorScheme.onInverseSurface
                  : colorScheme.onSurface,
            ),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ],
      ),
      body: Consumer<TripProvider>(
        builder: (context, tripProvider, child) {
          final trips = tripProvider.trips;

          if (trips.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Lottie.asset(
                        'assets/empty.json',
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Ohh oh nothing is here 😰",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          colorScheme.primary,
                          colorScheme.primaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: selectedTripIndex != null && trips.isNotEmpty
                        ? EmissionsChart(
                            selectedIndex: selectedTripIndex,
                            onClose: () => _selectTrip(selectedTripIndex!),
                          )
                        : Center(
                            child: Text(
                              'Select a trip to view details',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurface,
                                  ),
                            ),
                          ),
                  ),
                ),
              ),
              if (selectedTripIndex != null && trips.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                      ),
                    ),
                    child: TripDetails(trip: trips[selectedTripIndex!]),
                  ),
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final trip = trips[index];
                    return Dismissible(
                      key: Key(trip.hashCode.toString()),
                      background: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        final removedTrip = tripProvider.removeTrip(index);
                        if (selectedTripIndex != null) {
                          if (selectedTripIndex == index) {
                            setState(() {
                              selectedTripIndex = null;
                            });
                          } else if (selectedTripIndex! > index) {
                            setState(() {
                              selectedTripIndex = selectedTripIndex! - 1;
                            });
                          }
                        }
                        _showUndoSnackBar(
                            context, tripProvider, removedTrip, index);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withOpacity(0.3),
                              offset: const Offset(2, 9),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _selectTrip(index),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:
                                          colorScheme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.directions_car,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Trip on ${DateFormat('MMM dd').format(trip.date)}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${trip.distance}km • ${trip.formattedEmissions} saved',
                                          style: TextStyle(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: trips.length,
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTripScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        final trips = tripProvider.trips;
        final totalEmissions = trips.fold<double>(
          0,
          (sum, trip) => sum + trip.emissionsSaved,
        );

        final moneySaved = totalEmissions * 0.15;
        final waterSaved = totalEmissions * 0.5;
        final electricitySaved = totalEmissions * 0.3;
        return Drawer(
          backgroundColor: colorScheme.surface,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
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
                '\$${moneySaved.toStringAsFixed(2)}',
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
