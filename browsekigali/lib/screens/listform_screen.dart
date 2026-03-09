import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/listing_model.dart';
import '../state_management.dart/listing_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingForm extends StatefulWidget {
  final ListingModel? listing;

  const ListingForm({Key? key, this.listing}) : super(key: key);

  @override
  State<ListingForm> createState() => _ListingFormState();
}

class _ListingFormState extends State<ListingForm> {
  static const List<String> _categories = [
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'construction',
    'Tourist Attraction',
  ];

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  String? _selectedCategory;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _descriptionController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.listing?.name ?? '');
    _selectedCategory = widget.listing?.category;
    _addressController = TextEditingController(
      text: widget.listing?.address ?? '',
    );
    _contactController = TextEditingController(
      text: widget.listing?.contactNumber ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.listing?.description ?? '',
    );
    _latitudeController = TextEditingController(
      text: widget.listing?.latitude.toString() ?? '',
    );
    _longitudeController = TextEditingController(
      text: widget.listing?.longitude.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final listing = ListingModel(
      id: widget.listing?.id ?? '',
      name: _nameController.text.trim(),
      category: _selectedCategory?.trim() ?? '',
      address: _addressController.text.trim(),
      contactNumber: _contactController.text.trim(),
      description: _descriptionController.text.trim(),
      latitude: double.tryParse(_latitudeController.text.trim()) ?? 0.0,
      longitude: double.tryParse(_longitudeController.text.trim()) ?? 0.0,
      createdBy: FirebaseAuth.instance.currentUser!.uid,
      createdAt: widget.listing?.createdAt ?? Timestamp.now(),
    );

    final provider = context.read<ListingProvider>();

    try {
      if (widget.listing == null) {
        await provider.addListing(listing);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Listing created')));
      } else {
        await provider.updateListing(listing);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Listing updated')));
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = [..._categories];
    if (_selectedCategory != null &&
        _selectedCategory!.isNotEmpty &&
        !categories.contains(_selectedCategory)) {
      categories.add(_selectedCategory!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.listing == null ? 'Create Listing' : 'Update Listing',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Place/Service Name',
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter name' : null,
                ),
                DropdownButtonFormField<String>(
                  initialValue:
                      _selectedCategory != null && _selectedCategory!.isNotEmpty
                      ? _selectedCategory
                      : null,
                  items: categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() {
                    _selectedCategory = value;
                  }),
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Select category' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter address' : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter contact' : null,
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter description' : null,
                  maxLines: 3,
                ),
                TextFormField(
                  controller: _latitudeController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter latitude' : null,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: _longitudeController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter longitude' : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.listing == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
