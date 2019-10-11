// main.dart

import 'package:flutter/material.dart';

import 'screens/WelcomeScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/SignInScreen.dart';
import 'screens/TakePhotoScreen.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      theme: ThemeData(primarySwatch: Colors.red),
      routes: <String, WidgetBuilder> {
        '/' : (BuildContext context) => HomeScreen(),

        '/welcome': (BuildContext context) => WelcomeScreen(),

        '/sign-in': (BuildContext context) => SignInScreen(),

        '/take-photo': (BuildContext context) => TakePhotoScreen(),
      },
    );
  }
}
