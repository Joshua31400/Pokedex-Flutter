import 'package:flutter/material.dart';
import 'responsive/MobileContent.dart';
import 'responsive/TabletteContent.dart';

// Stateless Widget with no dynamic
class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  // StateLess have build methode
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B4CCA),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/pokeball.png'),
        ),
        title: const Text(
          "Poke Tracker",
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 767) {
            return MobileContent();
          } else {
            return Tablettecontent().buildTabletContent();
          }
        },
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        color: const Color(0xFF3B4CCA),
        child: Text(
          "Realised by Pedro MARTINS & Joshua BUDGEN",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
