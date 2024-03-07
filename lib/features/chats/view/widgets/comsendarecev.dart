import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:whattsup/comman/gif.dart';
import 'package:whattsup/features/chats/view/MyAudioPlayer.dart';

import '../../../../enum/enum12.dart';
import '../Myvideoplayer.dart';

class comman extends StatelessWidget {
  final String message;
  final String time;
  final bool isSeen;
  final MessageEnum type;

  const comman({required this.message,
    required this.time,
    required this.isSeen,
    required this.type, super.key});

  @override
  Widget build(BuildContext context) {
    bool isplaying=false;
    final AudioPlayer audioPlayer=AudioPlayer();
    String newgifurl='';
    if(type == MessageEnum.gif){
      int gifUrlPartIndex = message.lastIndexOf('-') + 1;
      String gifUrlPart = message.substring(gifUrlPartIndex);
     newgifurl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    }

    return Column(
      children: [
        type == MessageEnum.image
            ? CachedNetworkImage(imageUrl: message) :
        type == MessageEnum.gif ? CachedNetworkImage(imageUrl: newgifurl):
        type == MessageEnum.video ? Myvideoplayer(
            videotype: 2, videopath: File(''), videourl: message):
        type == MessageEnum.audio ?

        StatefulBuilder(builder: (context, setState) {
          return ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300,
              maxHeight: 50,
            ),
            child:
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // const Text(
                //   "Audo.mp3",
                //   style: TextStyle(
                //     fontSize: 20,
                //   ),
                // ),
                IconButton(
                  onPressed: () async {
                    if (isplaying) {
                      await audioPlayer.pause();
                      setState(() {
                        isplaying = false;
                      });
                    } else {
                      await audioPlayer.setUrl(
                        message,
                      );
                      audioPlayer.play();
                      setState(() {
                        isplaying = true;
                      });
                    }
                    },
                  icon: Icon(
                    isplaying ? Icons.pause_circle : Icons.play_circle,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
          );
        }) :

        SizedBox(width: 150, child: Text(message)),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: [Text(time), Icon(Icons.done_all)],
          ),
        ),
      ],
    );
  }
}
