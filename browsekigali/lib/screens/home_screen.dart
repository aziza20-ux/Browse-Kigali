import 'package:browsekigali/screens/Mylisting_screen.dart';
import 'package:browsekigali/screens/directory.dart';
import 'package:browsekigali/screens/mapview.dart';
import 'package:browsekigali/screens/settings.dart';
import 'package:browsekigali/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  int myIndex = 0;
  //list of screens to show bottom navigation
  final List<Widget> screens = [
    HomeScreene(),
    MyListingsScreen(currentUserId: AuthService().currentUser!.uid),
    Mapview(location: LatLng(-1.9505, 29.8739), title: 'Kigali'),
    Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: myIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        currentIndex: myIndex,
        onTap: (index) {
          setState(() {
            myIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: 'MyListings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'MapView'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
