import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whattsup/comman/gif.dart';
import 'package:whattsup/comman/utils.dart';
import 'package:whattsup/enum/enum12.dart';
import '../../../main.dart';
import '../controller/chatClassConroller.dart';
import 'gallery.dart';

class bottommodal extends ConsumerStatefulWidget {
  String uid;
  final bool isGroup;

  bottommodal({required this.uid, required this.isGroup, super.key});

  @override
  ConsumerState<bottommodal> createState() => _bottommodalState();
}

class _bottommodalState extends ConsumerState<bottommodal> {
  File? pickedFile;
  TextEditingController textarea = TextEditingController();
  FocusNode messagefocus = FocusNode();
  FocusNode focusNode = FocusNode();
  late bool hideemoji = true;
  bool isShow = true;
  FlutterSoundRecorder? _flutterSoundRecorder;
  bool isrecordinit = false;
  bool isrecording = false;
  bool isshowsendbtn = false;

  void sendTextmessage(BuildContext context) async {
    // textarea.text != ''
    if (!isShow) {
        ref.read(chatClassControllerProvider).sendTextmessage(
          context: context,
          message: textarea.text.trim(),
          reciveruid: widget.uid.toString(),
          isGroup: widget.isGroup,
          //groupId: widget.uid.toString(),
        );
        textarea.text = '';
    } else {
      if (!isrecordinit) {
        return;
      }
      var tmpPath = await getTemporaryDirectory();
      var path = '${tmpPath.path}/watshapclone.aac';
      if (isrecording) {
        await _flutterSoundRecorder!.stopRecorder();
        sendFilemessage(context, File(path), ref, MessageEnum.audio);
      } else {
        _flutterSoundRecorder!.startRecorder(toFile: path);
      }
      setState(() {
        isrecording = !isrecording;
      });
    }
  }

  void sendFilemessage(
      BuildContext context, pickedFile, WidgetRef ref, messageEnum) {
    ref.read(chatClassControllerProvider).sendFilemessage(
        context: context,
        file: pickedFile,
        reciveruid: widget.uid,
        messageEnum: messageEnum,
        isGroup: widget.isGroup);
    if (messageEnum != MessageEnum.audio) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  // Future<GiphyGif?> pickGif(BuildContext context) async {
  //  GiphyGif? gif;
  //   try {
  //     gif = await Giphy.getGif(
  //       context: context,
  //       apiKey: '9MgjoVw0j4G2l1tgdWMnnQXxi17fyo90',
  //     );
  //   } catch (e) {
  //     showSnackBar(
  //       context: context,
  //       message: e.toString(),
  //     );
  //   }
  //
  //   return gif;
  // }

  void sendGifmessage(
    BuildContext context,
  ) async {
    final gif = await pickGif(context);

    if (gif != null) {
      ref.read(chatClassControllerProvider).sendGifmessage(
          context: context,
          gifurl: gif.url!,
          reciveruid: widget.uid,
          isGroup: widget.isGroup);
    }
  }

  void openAudio() {
    Permission.microphone.request().then((permissionstatus) {
      if (permissionstatus.isGranted) {
        _flutterSoundRecorder!.openRecorder().then((_) {
          isrecordinit = true;
        }).catchError((e) {
          print("Error is here ");
          print(e);
        });
      } else if (permissionstatus.isPermanentlyDenied) {
        openAppSettings();
      } else {
        Permission.microphone.request();
        showSnackBar(
            context: context, message: "Please Provide Microphone Permission");
      }
    }).catchError((e) {
      Permission.microphone.request();
      showSnackBar(
          context: context, message: "Please Provide Microphone Permission");
    });
  }

  @override
  void initState() {
    super.initState();
    _flutterSoundRecorder = FlutterSoundRecorder();
    openAudio();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.black12),
                width: MediaQuery.of(context).size.width - 50,
                child: TextFormField(
                  onTap: () {},
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  controller: textarea,
                  textAlignVertical: TextAlignVertical.center,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                      hintText: 'Messge',
                      contentPadding: EdgeInsets.only(left: 3, right: 3),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Bottommodal(),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)));
                              },
                              icon: Icon(Icons.attach_file)),
                          Visibility(
                            visible: isShow,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              camera(uid: widget.uid)));
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
                      )),
                ),
              ),
              Visibility(
                visible: isShow,
                replacement: CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      sendTextmessage(context);
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
                child: CircleAvatar(
                  child: GestureDetector(
                      //   onLongPress: () {
                      // //print("object");

                      //   },
                      //   child:Icon(Icons.mic),
                      //
                      //   onLongPressEnd: (_){
                      //       //print('sdfswwf');
                      //     sendTextmessage(context);
                      //   },
                      //   onLongPressCancel: (){
                      //     print('slide to cancle');
                      //   },
                      //   onLongPressUp: (){
                      //     showBottomSheet(context: context, builder: (context)=>audiobottom());
                      //   },

                      onLongPressStart: (_) {
                        sendTextmessage(context);
                      },
                      onLongPressEnd: (_) {
                        sendTextmessage(context);
                      },
                      onTap: () {
                        if (isshowsendbtn) {
                          sendTextmessage(context);
                        }
                      },
                      child: isshowsendbtn
                          ? Icon(Icons.send)
                          : isrecording
                              ? Icon(Icons.close)
                              : Icon(Icons.mic)),
                ),
              )
            ],
          ),
          MyEmoji()
        ],
      ),
    );
  }

  Widget audiobottom() {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width / 0.5,
      child: Column(
        children: [
          SizedBox(
            height: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1:20'),
              Image.network(
                  height: 40,
                  width: 300,
                  'https://images.squarespace-cdn.com/content/v1/5a31637c9f8dce65cff235b7/1533248423344-8GM20XJR69AAA4WQ6TG9/SOUND_again.jpg?format=2500w')
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.pause_circle_outline)),
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.teal,
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.send)))
            ],
          )
        ],
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
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width / 0.5,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.description),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                      backgroundColor: Colors.deepPurpleAccent,
                      radius: 30,
                    ),
                    Text('Document')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => camera(
                                        uid: widget.uid,
                                      )));
                        },
                        icon: Icon(Icons.camera_alt),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                      backgroundColor: Colors.pinkAccent,
                      radius: 30,
                    ),
                    Text('Camera')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          getfromgallery();
                        },
                        icon: Icon(Icons.photo),
                        color: Colors.white,
                        iconSize: 30,
                      ),
                      backgroundColor: Colors.purpleAccent,
                      radius: 30,
                    ),
                    Text('Gallery')
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.headphones,
                        color: Colors.white,
                        size: 30,
                      ),
                      backgroundColor: Colors.deepOrangeAccent,
                      radius: 30,
                    ),
                    Text('Audio')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          sendGifmessage(context);
                        },
                        icon: Icon(Icons.gif_box),
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.green,
                      radius: 30,
                    ),
                    Text('Gif')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          getfromgalleryvideo();
                        },
                        icon: Icon(Icons.videocam),
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blue,
                      radius: 30,
                    ),
                    Text('video')
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  getfromgallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
    } else {
      File imageFile = File(pickedFile.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => gallery(
            pickedFile: imageFile,
            uid: widget.uid,
            messageEnum: MessageEnum.image,
            text: '',
            type: 'text',
            x: 5000,
            isGroup: widget.isGroup,
          ),
        ),
      );
    }
  }

  getfromgalleryvideo() async {
    final pickedFile = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
    } else {
      File videoFile = File(pickedFile.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => gallery(
            pickedFile: videoFile,
            uid: widget.uid,
            messageEnum: MessageEnum.video,
            text: '',
            type: 'text',
            x: 5000,
            isGroup: widget.isGroup,
          ),
        ),
      );
    }
  }
}
