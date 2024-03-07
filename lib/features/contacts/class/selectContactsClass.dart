import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whattsup/Model/usermodal.dart';
import 'package:flutter/material.dart';
import 'package:whattsup/features/chats/view/message.dart';
import '../../../Model/contactmodal.dart';
import '../../../comman/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:core';
final selectContactsClassProvider = Provider(
      (ref) => SelectContactsClass(
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class SelectContactsClass {
  final FirebaseFirestore firebaseFirestore;

  SelectContactsClass({
    required this.firebaseFirestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> tmpcontacts = [];
    List<Contact> contacts = [];
    List names=[];
    try {


      if (await FlutterContacts.requestPermission()) {
        tmpcontacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );

        int i=0;
         tmpcontacts.forEach((element) {
           if(names.contains(element.name)){
           }else{
             // if(i<50){
                 names.add(element.name);
                 contacts.add(element);
             // }
             i++;
           }
         });

      } else {
        FlutterContacts.requestPermission();
      }

    } catch (e) {
     print(e.toString());
    }

    return contacts;
  }

  void selectContact(Contact selectedcontact, BuildContext context,String displayName) async {
    try {
      var userCollection = await firebaseFirestore.collection("users").get();
      bool isRegisterd = false;
      usermodal userData;
      for (var document in userCollection.docs) {
        userData = usermodal.fromJson(document.data());
        String selectedNumber = selectedcontact.phones[0].number.replaceAll(
          ' ',
          '',
        );
        if (userData.phoneNumber == selectedNumber) {
          isRegisterd = true;
          Navigator.push(context,MaterialPageRoute(builder: (context)=>message(
            uid: userData.uid!,
            name: displayName,
            isGroup: false,
            members: userData.name.toString(),
            groupPic: '',
            members_name: userData.name.toString(),
          ),
          ),
          );
         break;

        }
      }
      if (isRegisterd == false) {
        showSnackBar(
          context: context,
          message: "This User is not Registered in this app.",
        );
      }
    } catch (e) {
      showSnackBar(
        context: context,
        message: e.toString(),
      );
    }
  }
}