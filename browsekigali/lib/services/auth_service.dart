import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up new user
  Future<UserModel?> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      //Create user with email & password
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      //send verification email
      await user.sendEmailVerification();

      //create Firestore user profile
      UserModel userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        name: name,
        createdAt: Timestamp.now(),
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toFirestore());
      return userModel;
    } on FirebaseAuthException catch (e) {
      print('SignUp Error:${e.message}');
      rethrow;
    }
  }
  //login existing user

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;
      //check if email is verified
      if (!user.emailVerified) {
        await user.sendEmailVerification();
         await _auth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'please verify your email first. Verification email sent.',
        );
      }
      //fetch user profile from firestore
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return UserModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print('login error: ${e.message}');
      rethrow;
    }
  }

  //logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  //currently logged in user
  User? get currentUser => _auth.currentUser;
  //refresh user info
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }
}
