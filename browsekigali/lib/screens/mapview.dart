import 'package:flutter/material.dart';

class Mapview extends StatefulWidget {
  const Mapview({super.key});

  @override
  State<Mapview> createState() => _MapviewState();
}

class _MapviewState extends State<Mapview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Icon(Icons.circle),
      title: Text('Browse all services'),
      ),
      body: Center(child: Text('Map View'),),
    );
  }
}