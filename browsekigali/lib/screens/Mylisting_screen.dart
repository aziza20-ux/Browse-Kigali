import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management.dart/listing_provider.dart';
import '../models/listing_model.dart';
import 'listform_screen.dart';
import 'listing_details_screen.dart';

class MyListingsScreen extends StatelessWidget {
  final String currentUserId;

  const MyListingsScreen({super.key, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Listings')),
      body: Consumer<ListingProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final userListings = provider.listings
              .where((l) => l.createdBy == currentUserId)
              .toList();

          if (userListings.isEmpty) {
            return const Center(child: Text('No listings yet. Tap + to add.'));
          }

          return ListView.builder(
            itemCount: userListings.length,
            itemBuilder: (context, index) {
              final listing = userListings[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: ListTile(
                  title: Text(listing.name),
                  subtitle: Text('${listing.category}\n${listing.address}'),
                  isThreeLine: true,
                  //tap gesture
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListingDetailsScreen(listing: listing),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ListingForm(listing: listing),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await context.read<ListingProvider>().deleteListing(
                            listing.id,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Listing deleted')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ListingForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
