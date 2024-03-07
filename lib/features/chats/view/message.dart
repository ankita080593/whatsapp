import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whattsup/Model/MessageModel.dart';
import 'package:whattsup/comman/krmLoader.dart';
import 'package:whattsup/features/auth/controller/AuthController.dart';
import 'package:whattsup/features/chats/view/widgets/receiver.dart';
import 'package:whattsup/features/chats/view/widgets/sender.dart';
import 'package:whattsup/features/videocall/controller/VideoCallController.dart';
import '../../../enum/enum12.dart';
import '../controller/chatClassConroller.dart';
import 'dart:io';
import 'bottommodal.dart';

class message extends ConsumerStatefulWidget {
  String uid;
  String name;
  bool isGroup;
  final String members;
  final groupPic;
  final String members_name;

//String groupId;
  message(
      {required this.uid,
      required this.name,
      required this.isGroup,
      required this.members,
      required this.groupPic,
      required this.members_name,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<message> createState() => _messageState();
}

class _messageState extends ConsumerState<message> {
  ScrollController msgscrollController = ScrollController();
  TextEditingController textarea = TextEditingController();

  // FocusNode messagefocus = FocusNode();
  FocusNode focusNode = FocusNode();
  late bool hideemoji = true;
  bool isShow = true;
  File? _imageFile;

  void sendTextmessage(BuildContext context) {
    if (textarea.text != '') {
      ref.read(chatClassControllerProvider).sendTextmessage(
          context: context,
          message: textarea.text.trim(),
          reciveruid: widget.uid.toString(),
          isGroup: widget.isGroup
          // groupId: widget.uid.toString(),
          );
      textarea.text = '';
    }
  }

  void startcall() {
    ref.read(videocallClasscontrollerProvider).startCall(
          context,
          widget.name,
          widget.uid,
          widget.groupPic,
          widget.isGroup,
        );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   focusNode.addListener(() {
  //     if (focusNode.hasFocus) {
  //       setState(() {
  //         hideemoji = true;
  //       });
  //     } else {
  //       setState(() {
  //         hideemoji = false;
  //       });
  //     }
  //   });
  //
  //   textarea.addListener(() {
  //     if (textarea.text != '') {
  //       setState(() {
  //         isShow = false;
  //       });
  //     } else {
  //       setState(() {
  //         isShow = true;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.groupPic), radius: 40),
        title: Column(
          children: [
            widget.isGroup
                ? Column(
                    children: [Text(widget.name), Text(widget.members_name)],
                  )
                : Column(
                    children: [
                      Text(widget.name),
                      StreamBuilder(
                          stream: ref
                              .read(authControllerProvider)
                              .getUserdatafromid(widget.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.data!.isOnline) {
                              return Text('Online');
                            }
                            return Text('Ofline');
                          }),
                    ],
                  )
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: IconButton(
                    onPressed: () {
                      startcall();
                    },
                    icon: Icon(Icons.videocam)),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.call),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: PopupMenuButton(
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                          PopupMenuItem(child: Text("View contact")),
                          PopupMenuItem(child: Text("Media, links and docs")),
                          PopupMenuItem(child: Text("Search")),
                          PopupMenuItem(child: Text("mute notifications")),
                          PopupMenuItem(child: Text("Disappearing message")),
                          PopupMenuItem(child: Text("Wallpaper")),
                          PopupMenuItem(child: Text('More')),
                        ]),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.blueGrey.shade50,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/img_1.png'),
                fit: BoxFit.fill)),
        child: Stack(
          children: [
            widget.isGroup
                ? StreamBuilder<List<MessageModel>>(
                    stream: ref
                        .watch(chatClassControllerProvider)
                        .getGroupMessages(widget.uid),
                    builder: (context, snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const krmLoader();
                      }
                      List<MessageModel> chatmessage = snapshots.data!;

                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        msgscrollController.jumpTo(
                          msgscrollController.position.maxScrollExtent,
                        );
                      });
                      return ListView.builder(
                        controller: msgscrollController,
                        shrinkWrap: true,
                        itemCount: chatmessage.length,
                        itemBuilder: (context, index) {
                          MessageModel groupModel = chatmessage[index];
                          var timeSent =
                              DateFormat.Hm().format(groupModel.time);

                          if (groupModel.type == MessageEnum.gif) {
                            print(" url = ${groupModel.message}");
                          }
                          // return Text(contactlist.message);
                          if (groupModel.reciverId ==
                              FirebaseAuth.instance.currentUser?.uid) {
                            return sender(
                              message: groupModel.message,
                              time: timeSent,
                              isSeen: true,
                              type: groupModel.type,
                            );
                          }
                          return receiver(
                            message: groupModel.message,
                            time: timeSent,
                            isSeen: true,
                            type: groupModel.type,
                          );
                        },
                      );
                      // return ListView.builder(
                      //   controller: msgscrollController,
                      //   itemCount: snapshots.data?.length,
                      //   itemBuilder: ((context, index) {
                      //     MessageModel messages = snapshots.data![index];
                      //     var messagedate = DateFormat.Hm().format(messages.time);
                      //
                      //     if (!messages.isSeen &&
                      //         messages.senderId !=
                      //             FirebaseAuth.instance.currentUser!.uid) {
                      //       ref.read(chatClassControllerProvider).setMessageSeen(
                      //         context,
                      //         messages.reciverId,
                      //         messages.messageId,
                      //       );
                      //     }
                      //
                      //     if (messages.senderId ==
                      //         FirebaseAuth.instance.currentUser!.uid) {
                      //       return sendMessage(
                      //         isSeen: messages.isSeen,
                      //         message: messages.message,
                      //         messagedate: messagedate,
                      //         messageType: messages.type,
                      //         repliedMessage: messages.repliedMessage,
                      //         replierUserame: messages.repliedTo,
                      //         repliedMessagetype: messages.repliedMessageType,
                      //         onLeftSwipe: () => onMessageReply(
                      //           messages.message,
                      //           true,
                      //           messages.type,
                      //         ),
                      //       );
                      //     }
                      //     return receiveMessage(
                      //       isSeen: messages.isSeen,
                      //       message: messages.message,
                      //       messagedate: messagedate,
                      //       messageType: messages.type,
                      //       repliedMessage: messages.repliedMessage,
                      //       replierUserame: messages.repliedTo,
                      //       repliedMessagetype: messages.repliedMessageType,
                      //       onRightSwipe: () => onMessageReply(
                      //         messages.message,
                      //         false,
                      //         messages.type,
                      //       ),
                      //     );
                      //   }),
                      // );
                    },
                  )
                : StreamBuilder<List<MessageModel>>(
                    stream: ref
                        .watch(chatClassControllerProvider)
                        .getMessages(widget.uid),
                    builder: (context, snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return krmLoader();
                      }
                      List<MessageModel> chatmessage = snapshots.data!;
                      {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          msgscrollController.jumpTo(
                            msgscrollController.position.maxScrollExtent,
                          );
                        });

                        return ListView.builder(
                          controller: msgscrollController,
                          shrinkWrap: true,
                          itemCount: chatmessage.length,
                          itemBuilder: (context, index) {
                            MessageModel contactlist = chatmessage[index];
                            var timeSent =
                                DateFormat.Hm().format(contactlist.time);

                            if (contactlist.type == MessageEnum.gif) {
                              print(" url = ${contactlist.message}");
                            }
                            // return Text(contactlist.message);
                            if (contactlist.reciverId ==
                                FirebaseAuth.instance.currentUser?.uid) {
                              return sender(
                                message: contactlist.message,
                                time: timeSent,
                                isSeen: true,
                                type: contactlist.type,
                              );
                            }
                            return receiver(
                              message: contactlist.message,
                              time: timeSent,
                              isSeen: true,
                              type: contactlist.type,
                            );
                          },
                        );
                      }
                    }),
            Align(
              alignment: Alignment.bottomLeft,
              child: bottommodal(
                uid: widget.uid,
                isGroup: widget.isGroup,
              ),

              //   WillPopScope(
              //     onWillPop: () {
              //       if (hideemoji == true) {
              //         Navigator.pop(context);
              //       } else {
              //         setState(() {
              //           hideemoji = !hideemoji;
              //         });
              //       }
              //       return Future.value();
              //     },
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         Row(
              //           children: [
              //             Container(
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(40),
              //                   color: Colors.black12),
              //               width: MediaQuery
              //                   .of(context)
              //                   .size
              //                   .width - 50,
              //               child: TextFormField(
              //                 onTap: () {},
              //                 keyboardType: TextInputType.multiline,
              //                 minLines: 1,
              //                 maxLines: 5,
              //                 controller: textarea,
              //                 textAlignVertical: TextAlignVertical.center,
              //                 focusNode: focusNode,
              //                 decoration: InputDecoration(
              //                     hintText: 'Messge',
              //                     contentPadding:
              //                     EdgeInsets.only(left: 3, right: 3),
              //                     suffixIcon: Row(
              //                       mainAxisSize: MainAxisSize.min,
              //                       children: [
              //                         IconButton(
              //                             onPressed: () {
              //                               showModalBottomSheet(
              //                                   context: context,
              //                                   builder: (context) =>
              //                                       Bottommodal(uid: widget.uid,),
              //                                   shape: RoundedRectangleBorder(
              //                                       borderRadius:
              //                                       BorderRadius.circular(
              //                                           20)));
              //                             },
              //                             icon: Icon(Icons.attach_file)),
              //                         Visibility(
              //                           visible: isShow,
              //                           child: IconButton(
              //                               onPressed: () {
              //                                 Navigator.push(
              //                                     context,
              //                                     MaterialPageRoute(
              //                                         builder: (context) =>
              //                                             camera(uid:widget.uid)));
              //                               },
              //                               icon: Icon(Icons.camera_alt)),
              //                         )
              //                       ],
              //                     ),
              //                     prefixIcon: IconButton(
              //                       onPressed: () {
              //                         focusNode.unfocus();
              //                         focusNode.canRequestFocus = true;
              //                         setState(() {
              //                           hideemoji = !hideemoji;
              //                         });
              //                       },
              //                       icon: Icon(Icons.emoji_emotions),
              //                     )),
              //               ),
              //             ),
              //             Visibility(
              //               visible: isShow,
              //               replacement: CircleAvatar(
              //                 child: IconButton(
              //                   onPressed: () {
              //                     sendTextmessage(context);
              //                   },
              //                   icon: Icon(Icons.send),
              //                 ),
              //               ),
              //               child: CircleAvatar(
              //                 child: IconButton(
              //                   onPressed: () {},
              //                   icon: Icon(Icons.mic),
              //                 ),
              //               ),
              //             )
              //           ],
              //         ),
              //         MyEmoji()
              //       ],
              //     ),
              //   ),
            )
          ],
        ),
      ),
    );
  }

// Widget MyEmoji() {
//   return Container(
//     child: Offstage(
//       offstage: hideemoji,
//       child: SizedBox(
//         width: MediaQuery
//             .of(context)
//             .size
//             .width - 20,
//         height: 200,
//         child: EmojiPicker(
//           textEditingController: textarea,
//         ),
//       ),
//     ),
//   );
// }

// Widget Bottommodal() {
//   return Container(
//     height: MediaQuery
//         .of(context)
//         .size
//         .height / 3,
//     width: MediaQuery
//         .of(context)
//         .size
//         .width / 0.5,
//     child: Column(
//       children: [
//         Row(
//           children: [
//             SizedBox(
//               width: 50,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     child: IconButton(
//                       onPressed: () {},
//                       icon: Icon(Icons.description),
//                       color: Colors.white,
//                       iconSize: 30,
//                     ),
//                     backgroundColor: Colors.deepPurpleAccent,
//                     radius: 30,
//                   ),
//                   Text('Document')
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     child: IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => camera(uid: widget.uid,)));
//                       },
//                       icon: Icon(Icons.camera_alt),
//                       color: Colors.white,
//                       iconSize: 30,
//                     ),
//                     backgroundColor: Colors.pinkAccent,
//                     radius: 30,
//                   ),
//                   Text('Camera')
//                 ],
//               ),
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     child: IconButton(
//                       onPressed: () {
//                         getfromgallery();
//                       },
//                       icon: Icon(Icons.photo),
//                       color: Colors.white,
//                       iconSize: 30,
//                     ),
//                     backgroundColor: Colors.purpleAccent,
//                     radius: 30,
//                   ),
//                   Text('Gallery')
//                 ],
//               ),
//             )
//           ],
//         ),
//         Row(
//           children: [
//             SizedBox(
//               width: 50,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     child: Icon(
//                       Icons.headphones,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                     backgroundColor: Colors.deepOrangeAccent,
//                     radius: 30,
//                   ),
//                   Text('Audio')
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     child: IconButton(
//                       onPressed: () {},
//                       icon: Icon(Icons.location_on),
//                       color: Colors.white,
//                     ),
//                     backgroundColor: Colors.green,
//                     radius: 30,
//                   ),
//                   Text('Location')
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// getfromgallery() async {
//   final pickedFile = await ImagePicker().pickImage(
//     source: ImageSource.gallery,
//
//   );
//   if (pickedFile == null) {
//     print("object 111");
//   }else{
//   File imageFile = File(pickedFile.path);
//   Navigator.push(context, MaterialPageRoute(builder: (context)=>gallery(pickedFile: imageFile,
//   uid: widget.uid)));
//   }
//
// }
}
