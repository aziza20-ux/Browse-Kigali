import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing_model.dart';

class ListingService {
  final CollectionReference _listingCollection = FirebaseFirestore.instance
      .collection('listings');
  //create new listing

  Future<void> creatingListing(ListingModel listing) async {
    await _listingCollection.add(listing.toFirestore());
  }

  //get all listings as stream
  Stream<List<ListingModel>> getAllListingings() {
    return _listingCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ListingModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  //updating existing ID
  Future<void> updateListing(String id, ListingModel listing) async {
    await _listingCollection.doc(id).update(listing.toFirestore());
  }

  //deleting a listing by ID
  Future<void> deleteListing(String id) async {
    await _listingCollection.doc(id).delete();
  }
}
