import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridebuddy/models/trip.dart';
import 'package:ridebuddy/providers/trip_provider.dart';
import 'package:ridebuddy/widgets/loading_overlay.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  double _distance = 0;
  FuelType _fuelType = FuelType.petrol;
  TrafficCondition _trafficCondition = TrafficCondition.light;
  int _idleTime = 0;
  TimeOfDay _tripTime = TimeOfDay.now();
  int _numberOfRiders = 1;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      final trip = Trip(
        date: DateTime.now(),
        distance: _distance,
        fuelType: _fuelType,
        trafficCondition: _trafficCondition,
        idleTime: _idleTime,
        tripTime: _tripTime,
        numberOfRiders: _numberOfRiders,
      );

      if (!mounted) return;
      context.read<TripProvider>().addTrip(trip);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Center(
              child: Text(
                'Add New Trip',
                style: TextStyle(
                  color: isDark ? colorScheme.onSurface : Colors.black,
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDark ? colorScheme.onSurface : Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.surface,
                  colorScheme.surface,
                ],
              ),
            ),
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.surface.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    _buildInputField(
                      icon: Icons.directions_car,
                      label: 'Distance (km)',
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter distance';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _distance = double.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      icon: Icons.local_gas_station,
                      label: 'Fuel Type',
                      child: DropdownButtonFormField<FuelType>(
                        value: _fuelType,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        items: FuelType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(
                            () {
                              _fuelType = value!;
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      icon: Icons.traffic,
                      label: 'Traffic Condition',
                      child: DropdownButtonFormField<TrafficCondition>(
                        value: _trafficCondition,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        items: TrafficCondition.values.map((condition) {
                          return DropdownMenuItem(
                            value: condition,
                            child: Text(condition.toString().split('.').last),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _trafficCondition = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      icon: Icons.timer,
                      label: 'Idle Time (minutes)',
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _idleTime = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      icon: Icons.people,
                      label: 'Number of Riders',
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          filled: true,
                          fillColor: colorScheme.surface,
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: '1',
                        validator: (value) {
                          final riders = int.tryParse(value ?? '');
                          if (riders == null || riders < 1) {
                            return 'Must have at least 1 rider';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _numberOfRiders = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      tileColor: colorScheme.surface,
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Trip Time'),
                      trailing: Text(_tripTime.format(context)),
                      onTap: () async {
                        final TimeOfDay? newTime = await showTimePicker(
                          context: context,
                          initialTime: _tripTime,
                        );
                        if (newTime != null) {
                          setState(() {
                            _tripTime = newTime;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _isLoading ? null : _submitForm,
                      child: Text(
                        'Add Trip',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_isLoading) const LoadingOverlay(),
      ],
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required String label,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
