import 'package:flutter/material.dart';
import 'package:whattsup/Model/ChatContactModel.dart';
import 'package:whattsup/features/chats/view/message.dart';
import 'package:whattsup/Mywidget/staticdata/staticcontact.dart';

import '../../Model/contactmodal.dart';
import '../../features/auth/views/verification.dart';
import '../staticdata/webmessage.dart';

class webLayout extends StatefulWidget {
  webLayout({this.friends, super.key});

  final ChatContactModel? friends;

  @override
  State<webLayout> createState() => _webLayoutState();
}

class _webLayoutState extends State<webLayout> {
  TextEditingController serch = TextEditingController();
  bool isShow = true;
  FocusNode focusNode = FocusNode();
  late bool hideserch = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          hideserch = false;
        });
      } else {
        setState(() {
          hideserch = true;
        });
      }
    });
    serch.addListener(() {
      if (serch.text != '') {
        setState(() {
          isShow = true;
        });
      } else {
        setState(() {
          isShow = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var length = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: length / 2.9,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 8,
                  width: length / 2.9,
                  color: Colors.blueGrey.shade50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/images/imgankita.jpg',
                          ),
                          radius: 30,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.people)),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.adjust_rounded)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.add_comment)),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_vert))
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 15,
                        width: length / 3.4,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.shade50,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Visibility(
                              visible:hideserch,
                              replacement: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.arrow_back),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.search),
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 3.9,
                                child: TextFormField(
                                  onTap: () {
                                    setState(() {
                                      isShow = true;
                                    });
                                  },
                                  controller: serch,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Serch and start new chat',
                                  suffixIcon: Visibility(visible: isShow,
                                    child: IconButton(onPressed: (){},
                                    icon: Icon(Icons.close),),
                                  )),
                                ))
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.filter_list,
                            color: Colors.grey,
                          ))
                    ],
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
               // Expanded(
                //     child: staticcontact(
                //   device: 'web',
                // )
                //)
              ],
            ),
          ),
          Expanded(
            child: Visibility(
              visible: widget.friends != null,
              replacement: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/1384/1384023.png',
                      height: 90,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'WhatsApp for Windows',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'Send and receive messages without keeping your phone online.',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      'Use WhatsApp on up to 4 linked devices and 1 phone at the same time. ',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
              ),
              child: webmessage(
                friends: widget.friends,
              ),
            ),
          )
        ],
      ),
    );
  }
}
