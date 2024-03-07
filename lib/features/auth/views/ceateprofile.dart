import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/AuthController.dart';

class createprofile extends ConsumerStatefulWidget {
  const createprofile({super.key});

  @override
  ConsumerState<createprofile> createState() => _createprofileState();
}

class _createprofileState extends ConsumerState<createprofile> {
  File? _imageFile;
  TextEditingController name = TextEditingController();
  final Key = GlobalKey<FormState>();

  void createUserProfile(String name, BuildContext context) {
    ref.read(authControllerProvider).createUserProfile(
          name,
          _imageFile,
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: Key,
        child: Container(
          height: MediaQuery.of(context).size.height / 2.5,
          width: MediaQuery.of(context).size.width,
          child: Center(
            //widthFactor: 100,heightFactor: 100,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  //SizedBox(height: 0,width: 450,),
                  Container(
                      child: _imageFile == null
                          ? IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              getfromcamera();
                                            },
                                            leading: Icon(Icons.camera_alt),
                                            title: Text('Camera'),
                                          ),
                                          ListTile(
                                              onTap: () {
                                                getfromgallery();
                                              },
                                              leading: Icon(Icons.image),
                                              title: Text('Gallery')),
                                        ],
                                      );
                                    });
                              },
                              icon: Stack(children: [
                                CircleAvatar(
                                  radius: 40,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/user.png"),
                                    backgroundColor: Colors.white,
                                    radius: 40,
                                  ),
                                ),
                                Positioned(
                                    left: 45,
                                    bottom: 5,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.add_a_photo),
                                    ))
                              ]))
                          : CircleAvatar(
                              radius: 40,
                              child: CircleAvatar(
                                backgroundImage: Image.file(
                                  _imageFile!,
                                  fit: BoxFit.cover,
                                ).image,
                                radius: 40,
                              ))),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: TextFormField(
                          controller: name,
                          decoration:
                              InputDecoration(hintText: 'Enter Your Name'),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (Key.currentState!.validate()) {
                              createUserProfile(name.text.toString(), context);
                            }
                          },
                          icon: Icon(Icons.check))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getfromgallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 200,
      maxHeight: 150,
    );
    if (pickedFile == null) return;
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  getfromcamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 100,
      maxHeight: 100,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}
