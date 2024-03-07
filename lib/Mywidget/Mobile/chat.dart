import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whattsup/Model/ChatContactModel.dart';
import '../../Model/GroupModel.dart';
import '../../Model/MessageModel.dart';
import '../../comman/krmLoader.dart';
import '../../features/chats/controller/chatClassConroller.dart';
import 'package:intl/intl.dart';

import '../../features/chats/view/message.dart';
import '../web/webLayout.dart';

class chat extends ConsumerStatefulWidget {
  final String device;
  final bool isGroup;
  final String reciveruid;

  const chat(
      {required this.device,
      required this.isGroup,
      required this.reciveruid,
      super.key});

  @override
  ConsumerState<chat> createState() => _chatState();
}

class _chatState extends ConsumerState<chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<GroupModel>>(
              stream: ref.read(chatClassControllerProvider).getGroups(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const krmLoader();
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        snapshots.data != null ? snapshots.data!.length : 0,
                    itemBuilder: (context, index) {
                      GroupModel groupModel = snapshots.data![index];
                      var timeSent =
                          DateFormat.Hms().format(groupModel.timeSent);

                      String members_name = "";
                      if (groupModel.members_name.isNotEmpty) {
                        for (String value in groupModel.members_name)
                          if (value == "") {
                           // members_name+="You ,";
                          } else {
                            members_name+="$value ,";
                          }
                      }
                      return ListTile(
                        onTap: () {
                          if (widget.device == 'mobile') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => message(
                                        uid: groupModel.groupId,
                                        name: groupModel.name,
                                        isGroup: true,
                                        groupPic: groupModel.groupPic,
                                        members: groupModel.members.toString(),
                                        members_name: members_name,
                                      )),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => webLayout(),
                              ),
                            );
                          }
                        },
                        leading: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              groupModel.groupPic,
                            )),
                        title: Text(groupModel.name.toString() ?? ''),
                        subtitle: Text(groupModel.lastMessage ?? ''),
                        trailing: Text(timeSent.toString() ?? ''),
                        // child: Column(
                        //   children: [
                        //    child: ListTile(
                        //       leading: CircleAvatar(
                        //         radius: 30,
                        //         backgroundImage: NetworkImage(
                        //           groupModel.groupPic,
                        //         ),
                        //       ),
                        //       title: Text(
                        //         groupModel.name,
                        //         style: const TextStyle(fontSize: 18),
                        //       ),
                        //       subtitle: Padding(
                        //         padding: const EdgeInsets.only(top: 5.0),
                        //         child: Text(
                        //           groupModel.lastMessage,
                        //           style: const TextStyle(fontSize: 15),
                        //         ),
                        //       ),
                        //       trailing: Padding(
                        //         padding: const EdgeInsets.only(bottom: 8.0),
                        //         child: Text(
                        //           DateFormat.Hm().format(groupModel.timeSent),
                        //           style: const TextStyle(
                        //             fontSize: 15,
                        //             color: Colors.grey,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        // const Divider(
                        //   color: Colors.black,
                        // indent: 5,
                        //),
                        //   ],
                        // ),
                      );
                    });
              }),
          StreamBuilder<List<ChatContactModel>>(
              stream: ref.watch(chatClassControllerProvider).getChatcontacts(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return krmLoader();
                }
                List<ChatContactModel> chatcontacts = snapshots.data!;
                {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: chatcontacts.length,
                    itemBuilder: (context, index) {
                      ChatContactModel contactlist = chatcontacts[index];
                      var timeSent =
                          DateFormat.Hms().format(contactlist.timeSent);
                      return ListTile(
                        onTap: () {
                          if (widget.device == 'mobile') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => message(
                                  uid: contactlist.contactId,
                                  name: contactlist.name,
                                  isGroup: widget.isGroup,
                                  members: '',
                                  groupPic: contactlist.profilePic,
                                  members_name: '',
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => webLayout(
                                  friends: contactlist,
                                ),
                              ),
                            );
                            //window.location.href("google.com");
                          }
                        },
                        leading: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              contactlist.profilePic,
                            )),
                        title: Text(contactlist.name.toString() ?? ''),
                        subtitle: Text(contactlist.lastMessage ?? ''),
                        trailing: Text(timeSent.toString() ?? ''),
                      );
                    },
                  );
                }
              }),
        ],
      ),
    ));
  }
}
