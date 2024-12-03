import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ridebuddy/screens/add_trip_screen.dart';
import 'package:ridebuddy/screens/home_screen.dart';
import 'package:ridebuddy/screens/splash_screen.dart';
import 'package:ridebuddy/providers/theme_provider.dart';
import 'package:ridebuddy/providers/trip_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
      ],
      child: const RideBuddyApp(),
    ),
  );
}

class RideBuddyApp extends StatelessWidget {
  const RideBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'RideBuddy',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
