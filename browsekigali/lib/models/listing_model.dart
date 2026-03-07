import 'package:cloud_firestore/cloud_firestore.dart';

class ListingModel {
  final String id;
  final String name;
  final String category;
  final String address;
  final String contactNumber;
  final String description;
  final double latitude;
  final double longitude;
  final String createdBy;
  final Timestamp createdAt;

  ListingModel({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.contactNumber,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.createdAt,
  });
  factory ListingModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return ListingModel(
      id: documentId,
      name: data['name'] ?? '',
      category: data['category'],
      address: data['address'],
      contactNumber: data['contactNumber'],
      description: data['description'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      createdBy: data['createdBy'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  //convert UserModel => map(FireStore)
  Map<String, dynamic> toFirestore() {
    return {
      'name': name, 
      'category': category,
      'address':address,
      'contactNumber':contactNumber,
      'description':description,
      'latitude':latitude,
      'longitude':longitude,
      'createdBy':createdBy,
      'createdAt': createdAt,
      };
  }
}
