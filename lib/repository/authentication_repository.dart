import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oau_bike_service/exception/signup_email_password_failure.dart';
import 'package:oau_bike_service/animated_onboarding_screen.dart';
import 'package:oau_bike_service/models/user_models.dart';
import 'package:oau_bike_service/support/support.dart';
import '../dashboard.dart';
import '../home.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    // ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => Home()) : Get.offAll(() => Dashboard());
  }

  Future<void> createUserWithEmailAndPassword(
      String email,
      String password,
      String firstName,
      String lastName,
      String username,
      String phoneNo,
      String statusInTheUniversity,
      String confirmPassword,
      BuildContext context) async {
    try {
      Support.showLoader(context);

      print("email is $email");
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await addUsersDetails(
        firstName,
        lastName,
        username,
        email,
        int.parse(phoneNo),
        statusInTheUniversity,
      );
      print(firebaseUser.value!.email);
      Support.stopLoader();
      firebaseUser.value == null
          ? Get.offAll(() => const Home())
          : Get.offAll(() => const Dashboard());
    } on FirebaseAuthException catch (e) {
      Support.stopLoader();
      Support.stopLoader();

      final ex = SignUpWithEmailPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXECEPTION - ${ex.message}');
      throw ex;
    } catch (_) {
      final ex = SignUpWithEmailPasswordFailure();
      print('EXCEPTION - ${ex.message}');
      throw ex;
    }
  }

  Future addUsersDetails(String firstName, String lastName, String username,
      String email, int phoneNo, String statusInTheUniversity) async {
    await FirebaseFirestore.instance.collection('users').add({
      'first name': firstName,
      'last name': lastName,
      'username': username,
      'email': email,
      'phone number': phoneNo,
      'status in the university': statusInTheUniversity,
    });
  }

  Future<void> loginWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      Support.showLoader(context);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      //  print(firebaseUser.value!.email);
      firebaseUser.value == null
          ? Get.offAll(() => const Home())
          : Get.offAll(() => const Dashboard());
      Support.stopLoader();
    } on FirebaseAuthException catch (e) {
      Support.stopLoader();

      print(e);
    } catch (_) {
      Support.stopLoader();

      print(_);
    }
  }

  Future<UserModels?> getUserDetails() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.value!.uid)
          .get();
      log(userDoc.data().toString());
      // return userDoc.data() as Map<String, dynamic>?;
      return UserModels.fromJson(userDoc.data() as Map<String, dynamic>);
    } catch (e) {
      print("Error fetching user details: $e");
      return null;
    }
  }

  Future<void> logout() async => await _auth.signOut();
}
