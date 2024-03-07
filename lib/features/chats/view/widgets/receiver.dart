import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../enum/enum12.dart';
import '../../../auth/controller/AuthController.dart';
import 'comsendarecev.dart';

class receiver extends ConsumerWidget {
  final String message;
  final String time;
  final bool isSeen;
  final MessageEnum type;

  const receiver(
      {required this.message,
      required this.time,
      required this.isSeen,
      required this.type,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.topRight,
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
