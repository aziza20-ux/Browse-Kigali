import 'package:flutter/material.dart';
import '../models/listing_model.dart';
import '../services/listing_service.dart';

class ListingProvide extends ChangeNotifier {
  final ListingService _listingService = ListingService();

  List<ListingModel> _allListings = [];
  List<ListingModel> _filteredListings = [];

  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';

  bool get isLoading => _isLoading;

  List<ListingModel> get listings => _filteredListings;

  String get selectedCategory => _selectedCategory;

  String get searchQuery => _searchQuery;

  // Fetch listings from Firestore
  void listenToListings() {
    _isLoading = true;
    notifyListeners();

    _listingService.getAllListingings().listen(
      (listingsList) {
        _allListings = listingsList;
        _applyFilters();
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Stream error: $e');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Search by name
  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  // Filter by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  // Apply both search + category filters
  void _applyFilters() {
    final selectedCategoryLower = _selectedCategory.trim().toLowerCase();
    final searchQueryLower = _searchQuery.trim().toLowerCase();

    _filteredListings = _allListings.where((listing) {
      final matchesSearch = listing.name.toLowerCase().contains(
        searchQueryLower,
      );

      final listingCategoryLower = listing.category.trim().toLowerCase();
      final matchesCategory =
          _selectedCategory == 'All' ||
          listingCategoryLower == selectedCategoryLower;

      return matchesSearch && matchesCategory;
    }).toList();

    notifyListeners();
  }
}
