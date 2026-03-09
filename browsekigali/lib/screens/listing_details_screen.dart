import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../models/listing_model.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'mapview.dart';

class ListingDetailsScreen extends StatelessWidget {
  final ListingModel listing;

  const ListingDetailsScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    final createdAtFormatted = DateFormat(
      'yyyy-MM-dd – kk:mm',
    ).format(listing.createdAt.toDate());
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(listing.name),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.category, color: Colors.blueAccent),
                title: const Text('Category'),
                subtitle: Text(listing.category),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.redAccent),
                title: const Text('Address'),
                subtitle: Text(listing.address),
                trailing: const Icon(Icons.map),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Mapview(
                        location: LatLng(listing.latitude, listing.longitude),
                        title: listing.name,
                      ),
                    ),
                  );
                },
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text('Contact'),
                subtitle: Text(listing.contactNumber),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.description, color: Colors.orange),
                title: const Text('Description'),
                subtitle: Text(listing.description),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.map, color: Colors.purple),
                title: const Text('Coordinates'),
                subtitle: Text('${listing.latitude}, ${listing.longitude}'),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.brown),
                title: const Text('Created By'),
                subtitle: Text(listing.id),
              ),
            ),
            Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(
                  Icons.calendar_today,
                  color: Colors.blueGrey,
                ),
                title: const Text('Created At'),
                subtitle: Text(createdAtFormatted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
