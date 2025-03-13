import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peso_tracker/screens/dashboard/dashboard_screen.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 157, 162, 126));
var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 122, 127, 90),
  brightness: Brightness.dark,
);
var kExpensesColor = const Color.fromARGB(255, 216, 53, 41);
var kIncomeColor = const Color.fromARGB(255, 25, 117, 28);
void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
    

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Peso Tracker',
        theme: ThemeData().copyWith(
          textTheme: GoogleFonts.quicksandTextTheme(),
          colorScheme: kColorScheme,
          appBarTheme: AppBarTheme(
            backgroundColor: kColorScheme.primary,
            foregroundColor: kColorScheme.onPrimary,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.primary,
                foregroundColor: Colors.white),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: kDarkColorScheme,
          textTheme: GoogleFonts.quicksandTextTheme().apply(
            displayColor: Colors.white,
            bodyColor: Colors.white
          ),
          iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle().copyWith(
              iconColor: WidgetStatePropertyAll<Color>(Colors.white70)
            )
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimary,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: kDarkColorScheme.primary,
                foregroundColor: Colors.black),
          ),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
