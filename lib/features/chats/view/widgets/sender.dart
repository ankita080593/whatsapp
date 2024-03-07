import 'package:flutter/material.dart';
import 'package:whattsup/enum/enum12.dart';
import 'package:whattsup/features/chats/view/message.dart';

import 'comsendarecev.dart';

class sender extends StatelessWidget {
  final String message;
  final String time;
  final bool isSeen;
  final MessageEnum type;

  const sender({
    required this.message,
    required this.time,
    required this.isSeen,
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.40),
        child: Card(
          color: Colors.white,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: comman(message: message,type: type,time: time,isSeen: isSeen,),
              )
            ],
          ),
        ),
      ),
    );
  }
}
