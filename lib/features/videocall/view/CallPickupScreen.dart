import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Model/VideoCallModel.dart';
import '../controller/VideoCallController.dart';
import 'CallScreen.dart';

class CallPickup extends ConsumerWidget {
  final Widget scaffold;

  const CallPickup({required this.scaffold, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(videocallClasscontrollerProvider).callstream,
      builder: (context, snapshots) {
        if (snapshots.hasData && snapshots.data?.data() != null) {
          VideoCall videoCall =
              VideoCall.fromMap(snapshots.data!.data() as Map<String, dynamic>);
          if (!videoCall.hasDialled) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    CircleAvatar(
                      backgroundImage: NetworkImage(videoCall.callerPic),
                      radius: 60,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      videoCall.callerName,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallScreen(
                                  channelId: videoCall.callId,
                                  videoCall: videoCall,
                                  isGroupChat: false,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
