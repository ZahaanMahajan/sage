import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/constants/enums.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /*---------------------- Check Invite Code ----------------------*/
  Future<InviteCodeStatus> checkInviteCode(String inviteCode) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('invitation_code').doc(inviteCode).get();

      if (doc.exists) {
        if (doc['uid'] != null) {
          return InviteCodeStatus.userExist;
        } else {
          return InviteCodeStatus.valid;
        }
      } else {
        return InviteCodeStatus.invalid;
      }
    } catch (e) {
      return InviteCodeStatus.invalid;
    }
  }

  /*---------------------- Sign up ----------------------*/
  Future<String?> signUpUser(
    String email,
    String username,
    String password,
    int age,
    bool hadCounsellingBefore,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? userId = userCredential.user?.uid;

      if (userId != null) {
        await saveUserInDatabase(
          userId,
          email,
          username,
          age,
          hadCounsellingBefore,
        );
      }

      return userId;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      } else {
        return e.message;
      }
    } catch (e) {
      return 'An unknown error occurred.';
    }
  }

  /*---------------------- Login ----------------------*/
  Future<String?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        return 'The email address is not valid.';
      } else if (e.code == 'user-disabled') {
        return 'This user account has been disabled.';
      } else if (e.code == 'too-many-requests') {
        return 'Too many login attempts. Try again later.';
      } else {
        return e.message ?? 'An authentication error occurred.';
      }
    } catch (e) {
      return 'An unknown error occurred. Please try again.';
    }
  }

  /*---------------------- Link User & Invite Code ----------------------*/
  Future<void> linkUserWithInviteCode(String userID, String inviteCode) async {
    try {
      await _firestore
          .collection('invitation_code')
          .doc(inviteCode)
          .update({'uid': userID});
    } catch (e) {
      throw Exception('Failed to save user in database: $e');
    }
  }

  /*---------------------- Save User Data ----------------------*/
  Future<void> saveUserInDatabase(
    String userID,
    String email,
    String username,
    int age,
    bool hadCounsellingBefore,
  ) async {
    try {
      await _firestore.collection('users').doc(userID).set({
        'age': age,
        'email': email,
        'uid': userID,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'had_counselling_before': hadCounsellingBefore,
      });
    } catch (e) {
      throw Exception('Failed to save user in database: $e');
    }
  }

  /*---------------- Send Verification Mail --------------------*/
  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> saveDataToProfile(String inviteCode, String userID) async {
    try {
      String profession = '';
      String gender = '';
      final documentSnapshot =
          await _firestore.collection('invitation_code').doc(inviteCode).get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data();
        if (data != null) {
          profession = data['profession'];
          gender = data['gender'];
        }
      }
      await _firestore.collection('users').doc(userID).update({
        'profession': profession,
        'gender': gender,
      });
    } catch (e) {
      throw 'Failed to save user data';
    }
  }
}
