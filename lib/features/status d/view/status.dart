import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:whattsup/Model/statusModel.dart';
import 'package:whattsup/Mywidget/staticdata/staticcontact.dart';
import 'package:whattsup/comman/globlevariable.dart';
import 'package:whattsup/comman/krmLoader.dart';
import 'package:whattsup/enum/statusenum.dart';
import 'package:whattsup/features/status%20d/controller/statusControllerprovider.dart';
import 'package:whattsup/features/status%20d/view/openstory.dart';

import '../../../enum/enum12.dart';
import '../../auth/class/firebasestoreclass.dart';
import '../../auth/controller/AuthController.dart';
import '../../chats/controller/chatClassConroller.dart';
import '../../chats/view/gallery.dart';
import '../class/statusClassProvider.dart';

class status extends ConsumerStatefulWidget {
  final uid;
final isGroup;
  status({required this.uid,required this.isGroup, super.key});

  @override
  ConsumerState<status> createState() => _statusState();
}

class _statusState extends ConsumerState<status> {
  File? pickedFile;
  var imageFile;

  void sendFilemessage(
      BuildContext context, pickedFile, WidgetRef ref, messageEnum) {
    ref.read(chatClassControllerProvider).sendFilemessage(
          context: context,
          file: pickedFile,
          reciveruid: widget.uid,
          messageEnum: messageEnum,
      isGroup: widget.isGroup,
        );
    if (messageEnum != MessageEnum.audio) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/imgankita.jpg'),
              radius: 30,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.red),
                ),
                child: IconButton(
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
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                padding: const EdgeInsets.only(top: 30, left: 30),
              ),
            ),
            title: Text('My status'),
            subtitle: Text('just now'),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            child: Text(
              'recent updates',
            ),
          ),

          SizedBox(
            height: 10,
          ),

          SizedBox(
            height: 200,
            child: FutureBuilder<List<StatusModel>>(
                future: ref.read(statusControllerProvider).getStatus(context),
                builder: (context, snapshots) {
                  // if(snapshots.connectionState==ConnectionState.waiting){
                  //   return const krmLoader();
                  // }
                  //
                  if (snapshots.hasData) {
                    print("Data Found = ${snapshots.data} ");

                    return ListView.builder(
                        itemCount: snapshots.data!.length,
                        itemBuilder: (context, index) {
                          StatusModel status = snapshots.data![index];
                          StatusModel contactlist = snapshots.data![index];
                          var timeSent =
                              DateFormat.Hm().format(contactlist.createdAt);
                          return ListTile(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => openstory(
                                    status: status.photoUrl,
                                    type: status.type,
                                    x: status.x,
                                    message: status.text,
                                  ),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(status.profilePic),
                              radius: 40,
                            ),
                            title: Text(status.username),
                            subtitle: Text(timeSent),
                          );
                        });
                  } else {
                    return Text("No Data Found");
                  }
                }),
          )
          // SizedBox(height:MediaQuery.of(context).size.height,child: staticcontact()),
        ],
      ),
    ));
  }

  getfromgallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
    } else {
      imageFile = File(pickedFile.path);

      // ref.watch(userLogindataProvider).whenData((logindata) {
      //   ref.read(statusClassProvider).uploadStatus(
      //     username: logindata!.name.toString(),
      //     profilePic: logindata.photoUrl.toString(),
      //     phoneNumber: logindata.phoneNumber.toString(),
      //     statusImage: imageFile,
      //     context: context,
      //     text: '',
      //     type: 'text',
      //   );
      // });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => gallery(
            pickedFile: imageFile,
            uid: widget.uid,
            messageEnum: MessageEnum.image,
            text: '',
            type: 'text',
            istsatus: true,
            x: 50000,
            isGroup: widget.isGroup,
          ),
        ),
      );
    }
  }

  getfromcamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile == null) {
    } else {
      imageFile = File(pickedFile.path);
      // String fileUrl = await ref.read(firebaseStorageClassProvider).uploadFiles(
      //   'mihir/camera',imageFile ,
      // );
      // print("fleurl= $fileUrl");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => gallery(
            pickedFile: imageFile,
            uid: widget.uid,
            messageEnum: MessageEnum.image,
            text: '',
            type: 'text',
            istsatus: true,
            x: 5000,
            isGroup: widget.isGroup,
          ),
        ),
      );
    }
  }
}
