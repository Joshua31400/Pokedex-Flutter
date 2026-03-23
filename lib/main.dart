import 'package:flutter/material.dart';
import 'data/DataManager.dart';
import 'ui/homme_screen/HomeScreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _loadData();
  }

  Future<void> _loadData() async {
    await DataManager().loadPokemonList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemon App',
      home: const Homescreen(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
    );
  }
}

