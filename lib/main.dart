import 'package:flutter/material.dart';
import 'package:project/Tester.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      navigatorKey: navigatorKey,
      home: Placeholder(),
    );
  }
}