import 'package:browsekigali/state_management.dart/directory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state_management.dart/listing_provider.dart';
import '../models/listing_model.dart';

class HomeScreene extends StatefulWidget {
  const HomeScreene({super.key});

  @override
  State<HomeScreene> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreene> {

  final List<String> categories = [
    'All',
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'construction',
    'Tourist Attraction'
  ];

  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
     context.read<ListingProvide>().listenToListings();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Browse Kigali"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Categories Horizontal List
            SizedBox(
              height: 45,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                 physics: const AlwaysScrollableScrollPhysics(),
                child: Row(
                  children: categories.map((category) {
                    final isSelected = category == selectedCategory;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                        context.read<ListingProvide>().filterByCategory(category);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Search Input
            TextField(
              decoration: InputDecoration(
                hintText: "Search services...",
                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onChanged: (value) {
                context.read<ListingProvide>().search(value);
              },
            ),

            const SizedBox(height: 20),

            /// Listings from Firestore
            Expanded(
              child: Consumer<ListingProvide>(
                builder: (context, provider, child) {

                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final listings = provider.listings;

                  if (listings.isEmpty) {
                    return const Center(
                      child: Text("No listings found"),
                    );
                  }

                  return ListView.builder(
                    itemCount: listings.length,

                    itemBuilder: (context, index) {

                      ListingModel listing = listings[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),

                        child: ListTile(
                          title: Text(listing.name),

                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(listing.category),

                              Text(listing.address),
                            ],
                          ),

                          trailing: const Icon(Icons.arrow_forward),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



