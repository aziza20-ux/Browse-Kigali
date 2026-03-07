import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? name;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  //convert firestore document => UserModel
  factory UserModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  //convert UserModel => map(FireStore)
  Map<String, dynamic> toFirestore() {
    return {'email': email, 'name': name, 'createdAt': createdAt};
  }
}
