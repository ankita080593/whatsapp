import 'dart:io';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/statusControllerprovider.dart';

class textstory extends ConsumerStatefulWidget {
  String uid;

  textstory({required this.uid, super.key});

  @override
  ConsumerState<textstory> createState() => _textstoryState();
}

class _textstoryState extends ConsumerState<textstory> {
  bool isshow = true;
  late bool hideemoji = true;
  TextEditingController textarea = TextEditingController();
  FocusNode focusNode = FocusNode();
  // void sendTextmessage(BuildContext context) {
  //   if (textarea.text != '') {
  //     ref.read(chatClassControllerProvider).sendTextmessage(
  //       context: context,
  //       message: textarea.text.trim(),
  //       reciveruid: widget.uid.toString(),
  //     );
  //     textarea.text = '';
  //   }
  // }
  String ?f;
    List font=['sans-serif','cursive','Times New Roman',
      'Georgia','Verdana','Arial','Helvetica','fantasy','Times'];
  int x=Random().nextInt(Colors.primaries.length);
  void getfont(){
    setState(() {
f=font[Random().nextInt(font.length)];
    });
  }
  @override
  void initState() {
    // TODO: implement initState
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
          isshow = false;
        });
      } else {
        setState(() {
          isshow = true;
        });
      }
    });
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textarea.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      if (hideemoji == true) {
        Navigator.pop(context);
      } else {
        setState(() {
          hideemoji = !hideemoji;
        });
      }
      return Future.value();
    },
       child: Scaffold(
      body: SingleChildScrollView(
          child: Column(children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width, color:Colors.primaries[x]
                ),
                Positioned(
                    top: 30,
                    left: 10,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ))),
                Positioned(
                  top: 30,
                  left: 250,
                    child: Visibility(visible: isshow,
                      //replacement:,
                      child: IconButton(
                          onPressed: () {
                            focusNode.unfocus();
                            focusNode.canRequestFocus = true;
                            setState(() {
                              hideemoji = !hideemoji;
                            });
                          },
                          icon: hideemoji?Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.white,
                          ):Icon(Icons.keyboard,color: Colors.white,)
                      ),
                    ),
                ),
                Positioned(
                  top: 30,
                  right: 50,
                  child: TextButton(onPressed: (){
                    getfont();
                  },
                    child: Text('T',style: TextStyle(fontFamily: f,color: Colors.white),),)

                ),
                Positioned(
                    top: 30,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          x=Random().nextInt(Colors.primaries.length);
                        });                    },
                      icon: Icon(
                        Icons.color_lens,
                        color: Colors.white,
                      ),
                    )),
                Center(
                    heightFactor: 12,
                    child: TextFormField(
                      controller: textarea,
                      textAlign: TextAlign.center,
                      showCursor: true,
                      cursorColor: Colors.white,
                      autofocus: true,
                      focusNode: focusNode,
                      cursorHeight: 30,
                      decoration: InputDecoration(
                          hintText: 'Type a Status',
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 30,fontFamily: f)),
                    )),
                // Center(heightFactor:26,child: Container(height: 60,width: 500,color: Colors.black12,))
              Positioned(bottom:50,left:0,child: MyEmoji())
              ],
            ),

          ]
    ),
        ),
        bottomSheet: Container(
          height: 55,
          color: Colors.black26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 30,
                width: 150,
                child: Text('Status (80 included)'),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.blueAccent,
                ),
              ),
              Visibility(
                  visible: isshow,
                  replacement: CircleAvatar(
                    child: IconButton(
                      onPressed: () {


                        ref.read(statusControllerProvider).uploadStatus(
                              statusImage: File(''),
                              context: context,
                              type: 'text',
                              text: textarea.text,
                               x: x
                            );
                Navigator.pop(context);
                      },
                      icon: Icon(Icons.send),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  child: CircleAvatar(
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.mic),
                    ),
                    backgroundColor: Colors.green,
                  ))
            ],
          ),
        ),),
   );
  }
  Widget MyEmoji() {
    return Container(
      child: Offstage(
        offstage: hideemoji,
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width - 1,
          height: 200,
          child: EmojiPicker(
            textEditingController: textarea,
          ),
        ),
      ),
    );
  }
}
