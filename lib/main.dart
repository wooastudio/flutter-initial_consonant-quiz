import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:initconsquiz/models/constants.dart';
import 'package:initconsquiz/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // splash screen keep remaining
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferences prefs;
  bool isLoading = true;

  Future initPrefs() async {
    SharedPreferences.getInstance().then(
      (value) {
        setState(
          () {
            // whenever your initialization is completed, remove the splash screen:
            FlutterNativeSplash.remove();
            isLoading = false;
            prefs = value;

            if (prefs.getInt(Constants.preferenceCount) == null) {
              prefs.setInt(Constants.preferenceCount, 30);
            }
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: isLoading == false
          ? HomeScreen(
              prefs: prefs,
              isFirstLaunch: true,
            )
          : null,
    );
  }
}
