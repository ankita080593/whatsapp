import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import '../../main.dart';

class webmessage extends StatefulWidget {
  final friends;
  const webmessage({required this.friends, Key? key}) : super(key: key);

  @override
  State<webmessage> createState() => _webmessageState();
}

class _webmessageState extends State<webmessage> {
  TextEditingController textarea = TextEditingController();
  FocusNode messagefocus = FocusNode();
  FocusNode focusNode = FocusNode();
  late bool hideemoji = true;
  bool isShow = true;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          hideemoji = true;
        });
      } else {
        setState(() {
          hideemoji = false;
        });
      }
    });

    textarea.addListener(() {
      if (textarea.text != '') {
        setState(() {
          isShow = false;
        });
      } else {
        setState(() {
          isShow = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.friends.profilePic ?? ''),
            radius: 40),
        title: Column(
          children: [
            Text(widget.friends.name ?? ''),
            Text(
              'online',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.videocam),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.call),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.more_vert),
              ),
            ],
          ),
        ],
        backgroundColor: Colors.blueGrey.shade50,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(fit: BoxFit.fill,
              image: AssetImage("assets/images/img.png"),
            )),
        child: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomLeft,
              child: WillPopScope(
                onWillPop: () {
                  if (hideemoji == true) {
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      hideemoji = !hideemoji;
                    });
                  }
                  return Future.value();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BottomAppBar(color: Colors.blueGrey.shade50,
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                          onPressed: () {
                            focusNode.unfocus();
                            focusNode.canRequestFocus = true;
                            setState(() {
                              hideemoji = !hideemoji;
                            });
                          },
                          icon: Icon(Icons.emoji_emotions),
                        ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) =>
                                        Bottommodal(),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            20)));
                              },
                              icon: Icon(Icons.add)),

                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white),
                            width: MediaQuery.of(context).size.width/2,
                            child: TextFormField(
                              onTap: () {},
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              controller: textarea,
                              textAlignVertical: TextAlignVertical.center,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                  hintText: 'Type a messge',
                                  contentPadding:
                                  EdgeInsets.all(20),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    Bottommodal(),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20)));
                                          },
                                          icon: Icon(Icons.attach_file)),
                                      Visibility(
                                        visible: isShow,
                                        child: IconButton(
                                            onPressed: () {

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>camera(uid: '',)));
                                            },
                                            icon: Icon(Icons.camera_alt)),
                                      )
                                    ],
                                  ),
                                   prefixIcon: IconButton(
                                    onPressed: () {
                                      focusNode.unfocus();
                                      focusNode.canRequestFocus = true;
                                      setState(() {
                                        hideemoji = !hideemoji;
                                      });
                                    },
                                    icon: Icon(Icons.emoji_emotions),
                                  ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isShow,
                            replacement: CircleAvatar(
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.send),
                              ),
                            ),
                            child: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.mic),
                              ),

                          )
                        ],
                      ),
                    ),
                    MyEmoji()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget MyEmoji() {
    return Container(
      child: Offstage(
        offstage: hideemoji,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 20,
          height: 200,
          child: EmojiPicker(
            textEditingController: textarea,
          ),
        ),
      ),
    );
  }

  Widget Bottommodal() {
    return Container(
      height: MediaQuery.of(context).size.height/2.5,
      width: MediaQuery.of(context).size.width / 8,
      child: Column(
        children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                        Icons.description,
                        color: Colors.purple,
                        size: 30,
                      ),
                    Text('Document')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                        Icons.camera_alt,
                        color: Colors.pinkAccent,
                        size: 30,
                      ),
                    Text('Camera')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                        Icons.photo,
                        color: Colors.blue,
                        size: 30,
                      ),
                    Text('photos & videos')
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                        Icons.person,
                        color: Colors.lightBlue,
                        size: 30,
                      ),
                    Text('Contact'),
              ],
    ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Icon(
                        Icons.bar_chart,
                        color: Colors.yellowAccent,
                        size: 30,
                      ),

                    Text('Poll')
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
