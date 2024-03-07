import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whattsup/Model/VideoCallModel.dart';
import 'package:agora_uikit/agora_uikit.dart';
import '../../../comman/krmLoader.dart';
import '../../../config/AgoraConfig.dart';
import '../controller/VideoCallController.dart';
class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final VideoCall videoCall;
  final bool isGroupChat;

  const CallScreen({super.key,required this.channelId,
    required this.videoCall,
    required this.isGroupChat,});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String hosturl = 'https://ntce-ad8e47b5a79c.herokuapp.com/';
  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: hosturl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: client == null
        ? const krmLoader()
        : SafeArea(
      child: Stack(
        children: [
          AgoraVideoViewer(client: client!),
          AgoraVideoButtons(
            client: client!,
            disconnectButtonChild: IconButton(
              icon: const Icon(
                Icons.call_end,
              ),
              onPressed: () async {
                await client!.engine.leaveChannel();
                ref.read(videocallClasscontrollerProvider).endCall(
                  widget.videoCall.callerId,
                  widget.videoCall.receiverId,
                  context,
                  isGroupChat:widget.isGroupChat,
                );
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    ),);
  }
}
