import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whattsup/Model/usermodal.dart';
import '../../../Model/statusModel.dart';
import '../../../comman/utils.dart';
import '../../auth/class/firebasestoreclass.dart';

final statusClassProvider = Provider(
  (ref) => StatusClass(
    firebaseFirestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusClass {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusClass({
    required this.firebaseFirestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
    required String type,
    required int x,
    required String text,
  }) async {
    try {
      print("Hello");



      firebaseFirestore.collection('status').doc();

      print("Part 1");
      print("status class =${statusImage}");
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String uploadUrl = '';
      List<String> types = [];
      List<String> text_list=[];

      int colorndex;
      List<int> colors=[];
      types.add(type);
      if (type == "text") {
        uploadUrl = text;
        colorndex=x;
      } else {
        colorndex=5000;
        uploadUrl = await ref.read(firebaseStorageClassProvider).uploadFiles(
              'status/$statusId/$uid',
              statusImage,
            );
      }

      print("upload url = $uploadUrl");

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );

        print("Part 3");

        List<String> whoCanSee = [];

        /****** Who Can See ****/
        // for (var i = 0; i < contacts.length; i++) {
        var userCollection = await firebaseFirestore
            .collection("users")
            .where(
              'phoneNumber',
              isEqualTo: auth.currentUser!.phoneNumber!.replaceAll(
                ' ',
                '',
              ),
            )
            .get();

        print("Part 4");

        if (userCollection.docs.isNotEmpty) {
          var userData = usermodal.fromJson(userCollection.docs[0].data());
          whoCanSee.add(userData.uid.toString());
        }
        // }

        print("Part 5");

        List<String> photoUrl = [];
        var statusData = await firebaseFirestore
            .collection('status')
            .where(
              'uid',
              isEqualTo: auth.currentUser!.uid,
            )
            .get();

        print("Part 6");

        if (statusData.docs.isNotEmpty) {
          print("Part 7");
          print(statusData.docs);
          StatusModel statusModel = StatusModel.fromMap(
            statusData.docs[0].data(),
          );

          photoUrl = statusModel.photoUrl;
          photoUrl.add(uploadUrl);

          text_list = statusModel.text;
          text_list.add(text);


          List<String> types = statusModel.type;
          types.add(type);

          colors=statusModel.x;
          colors.add(colorndex);

          await firebaseFirestore
              .collection('status')
              .doc(
                statusData.docs[0].id,
              )
              .update({
            'photoUrl': photoUrl,
            'type': types,
            'x':colors,
            'text':text_list,
          });

          print("Part 9");
        } else {
          print("Part 8");
          photoUrl.add(uploadUrl); //new uploaded url
          colors.add(colorndex);
          text_list.add(text);

          StatusModel status = StatusModel(
            uid: uid,
            username: username,
            phoneNumber: phoneNumber,
            photoUrl: photoUrl,
            createdAt: DateTime.now(),
            profilePic: profilePic,
            statusId: statusId,
            whoCanSee: whoCanSee,
            text: text_list,
            type: types,
            x: colors,
          );

          await firebaseFirestore
              .collection('status')
              .doc(statusId)
              .set(status.toMap());

          print("Part 10");
        }
      } else {
        FlutterContacts.requestPermission();
      }
    } catch (e) {
      print("Error =  ${e.toString()}");

      showSnackBar(
        context: context,
        message: e.toString(),
      );
    }
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      // for (int i = 0; i < contacts.length; i++) {

      // if(contacts[i].phones.isNotEmpty){

      var statusesSnapshot = await firebaseFirestore
          .collection('status')
          .where(
            'phoneNumber',
            isEqualTo: auth.currentUser!.phoneNumber!.replaceAll(
              ' ',
              '',
            ),
          )
          .where(
            'createdAt',
            isGreaterThan: DateTime.now()
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
          )
          .get();

      for (var tempData in statusesSnapshot.docs) {
        StatusModel tempStatus = StatusModel.fromMap(tempData.data());
        if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
          statusData.add(tempStatus);
        }
      }
      print("Statusdtata= ${statusData}");

      // }
      //
      // }
    } catch (e) {
      if (kDebugMode) print(e);
      showSnackBar(
        context: context,
        message: e.toString(),
      );
    }

    return statusData;
  }
}
