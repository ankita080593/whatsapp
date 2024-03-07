import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../Model/usermodal.dart';
import '../../../comman/globlevariable.dart';
import '../../../comman/utils.dart';
import '../../../myLayout.dart';
import '../views/OTPScreen.dart';
import '../views/ceateprofile.dart';
import 'firebasestoreclass.dart';

final authClassProvider = Provider(
  (ref) => AuthClass(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  ),
);

class AuthClass {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthClass(
    this.auth,
    this.firestore,
  );

  Future<usermodal?> getUserLogindata() async {
    var userdata = await firestore
        .collection('users')
        .doc(
          auth.currentUser?.uid,
        )
        .get();

    usermodal? user;

    if (userdata.data() != null) {
      user = usermodal.fromJson(userdata.data()!);
    }
    return user;
  }

  Stream<usermodal> getUserdatafromid(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => usermodal.fromJson(event.data()!));
  }

  void signInWithPhone(BuildContext context, String phonenumber) async {
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phonenumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (e) {
            throw Exception(e.message);
          },
          codeSent: (String verificationId, int? resendToken) async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  verificationId: verificationId,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, message: e.message!);
    }
  }

//}
  void verifyOTP(
    BuildContext context,
    String verificationId,
    String userOTP,
  ) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOTP,
      );
      await auth.signInWithCredential(credential);
      Get.defaultDialog(
          title: 'Authorization completed',
          actions: [
            CircleAvatar(
              child: IconButton(
                onPressed: () {
                  print("OTP: $userOTP");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const createprofile(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.black,
                ),
                color: Colors.white,
              ),
              backgroundColor: Colors.white,
            )
          ],
          backgroundColor: Colors.white,
          titleStyle: TextStyle(
            color: Colors.black,
          ),
          radius: 30);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, message: e.message!);
    }
  }

  void createUserProfile(
    String name,
    File? profilePic,
    ProviderRef ref,
    BuildContext context,
  ) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl = userprofilePic;
      if (profilePic != null) {
        photoUrl = await ref.read(firebaseStorageClassProvider).uploadFiles(
              'profilePic/$uid',
              profilePic,
            );
      }
      var user = usermodal(
        name: name,
        uid: uid,
        photoUrl: photoUrl,
        isOnline: true,
        phoneNumber: auth.currentUser!.phoneNumber!,
        groupId: [],
      );
      await firestore.collection("users").doc(uid).set(user.toJson());
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const myLayout()),
        // (route) => false,
      );
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

  void changeUserstate(bool isOnline) {
    firestore.collection('users').doc(auth.currentUser?.uid).update({
      'isOnline': isOnline,
    });
  }
}
