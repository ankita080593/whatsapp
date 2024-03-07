

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'features/auth/class/firebasestoreclass.dart';
class TestWdget extends ConsumerStatefulWidget {
  const TestWdget({super.key});

  @override
  ConsumerState<TestWdget> createState() => _TestWdgetState();
}

class _TestWdgetState extends ConsumerState<TestWdget> {

@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(

          child: Text("Clck Me"),
          onPressed: () async{

              final pickedFile = await ImagePicker().pickImage(
                source: ImageSource.gallery,
              );
              if (pickedFile == null) {
              } else {
              File  imageFile = File(pickedFile.path);
                String fileUrl = await ref.read(firebaseStorageClassProvider).uploadFiles(
                  'mihir/camera',imageFile,
                );
                print("fleurl= $fileUrl");



            }
          },
        ),
      ),
    );
  }
}
