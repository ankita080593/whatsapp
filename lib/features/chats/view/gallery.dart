import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whattsup/enum/statusenum.dart';
import 'package:whattsup/features/status%20d/class/statusClassProvider.dart';
import 'package:whattsup/features/status%20d/view/status.dart';
import 'dart:io';
import '../../../enum/enum12.dart';
import '../../auth/controller/AuthController.dart';
import '../../status d/controller/statusControllerprovider.dart';
import '../controller/chatClassConroller.dart';
import 'Myvideoplayer.dart';

class gallery extends ConsumerWidget {
  final File pickedFile;
  final uid;
  final MessageEnum messageEnum;
  final bool istsatus;
final isGroup;
  gallery({required this.pickedFile,
    required this.uid,
    required this.messageEnum,
    required type,
    required text,
    required int x,
    this.istsatus = false,
    required this.isGroup,
    super.key});

  TextEditingController area = TextEditingController();

  void sendFilemessage(BuildContext context, pickedFile, WidgetRef ref) {
    if (istsatus) {
      ref.read(statusControllerProvider).uploadStatus(
            statusImage: pickedFile,
            context: context,
            type: 'image',
            x:5000,
            text: area.text,
          );

    } else {
      ref.read(chatClassControllerProvider).sendFilemessage(
        context: context,
        file: pickedFile,
        reciveruid: uid,
        messageEnum: messageEnum,
        isGroup: isGroup
      );
    }

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body:
      // Container(height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.height,
      //   decoration:
      // BoxDecoration(image: DecorationImage(image:Image.file(
      //   pickedFile!,
      //   fit: BoxFit.fill,
      // ).image,)),
      //
      // )
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Stack(
            children: [
              messageEnum == MessageEnum.image
                  ? Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.90,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: Image.file((pickedFile!), fit: BoxFit.cover),
              )
                  : Myvideoplayer(
                  videotype: 1, videopath: pickedFile!, videourl: ''),
              Positioned(
                  top: 30,
                  left: 10,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ))),
              Positioned(
                  top: 30,
                  left: 200,
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.crop_rotate,
                        color: Colors.white,
                      ))),
              Positioned(
                top: 30,
                left: 250,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.white,
                    )),
              ),
              Positioned(
                top: 30,
                right: 50,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.title,
                      color: Colors.white,
                    )),
              ),
              Positioned(
                  top: 30,
                  right: 10,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                  bottom: 140,
                  left: 180,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.keyboard_arrow_up_outlined,
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                  bottom: 130,
                  left: 187,
                  child: Text(
                    'Filter',
                    style: TextStyle(color: Colors.white),
                  )),
              Positioned(
                bottom: 75,
                left: 5,
                child: Container(
                  height: 40,
                  width: 380,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.grey.shade800),
                  child: TextFormField(
                    controller: area,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        hintText: 'Add a caption...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                        prefixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.white,
                          ),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.av_timer,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ),
              ),
              Positioned(
                bottom: -10,
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 8,
                      width: 10,
                    ),
                    Container(
                      height: 30,
                      width: 60,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.grey.shade800,
                      ),
                      child: Text(
                        'Tushar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 20,
                      width: 265,
                    ),
                    CircleAvatar(
                      child: IconButton(
                          onPressed: () {
                            sendFilemessage(
                              context,
                              pickedFile,
                              ref,
                            );

                            // ref.read(statusControllerProvider).uploadStatus(
                            //     statusImage: File(''),
                            //     context: context,
                            //     type: 'image',
                            //     text: area.text,
                            //     x: 1000,
                            // );

                          },
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          )),
                      backgroundColor: Colors.green,
                      radius: 25,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
