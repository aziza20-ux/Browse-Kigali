import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/listing_service.dart';

class ListingProvider with ChangeNotifier {
  final ListingService _listingService = ListingService();
  List<ListingModel> _listings = [];
  bool _isLoading = true;

  List<ListingModel> get listings => _listings;
  bool get isLoading => _isLoading;

  ListingProvider() {
    _listenToListings();
  }

  void _listenToListings() {
    _listingService.getAllListingings().listen((updatedListings) {
      _listings = updatedListings;
      _isLoading = false;
      notifyListeners(); // notify ui to be updated 
    });
  }

  Future<void> addListing(ListingModel listing) async {
    await _listingService.creatingListing(listing);
    // Stream automatically updates _listings
  }

  Future<void> updateListing(ListingModel listing) async {
    await _listingService.updateListing(listing.id, listing);
  }

  Future<void> deleteListing(String id) async {
    await _listingService.deleteListing(id);
  }
}