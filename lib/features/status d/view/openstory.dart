import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:whattsup/comman/krmLoader.dart';
import 'package:whattsup/features/chats/view/message.dart';

class openstory extends StatefulWidget {
  final List<String> status;
  final List<String> type;
  final List<int> x;
  final List<String> message;

  const openstory(
      {required this.status,
      required this.type,
      required this.x,
      required this.message,
      super.key,
      });

  @override
  State<openstory> createState() => _openstoryState();
}

class _openstoryState extends State<openstory> {
  final storyController = StoryController();
  List<StoryItem> storyItems = [];
  var type;

  void creeateStorytems() {
    for (int i = 0; i < widget.status.length; i++) {
      widget.type[i] == "image"
          ? storyItems.add(
              StoryItem.pageImage(
                url: widget.status[i],
                controller: storyController,
                caption: widget.message[i]
              ),
            )
          : storyItems.add(
              StoryItem.text(
                title: widget.status[i].toString(),
                backgroundColor: Colors.primaries[widget.x[i]],
              ),
            );
      // if(statusenum==statusenum.text)
      // {storyItems.add(
      //     StoryItem.text(title:widget.status[i].toString() ,
      //         backgroundColor:Colors.primaries[Random().nextInt(Colors.primaries.length)]));
      // }else{
      // storyItems.add(
      //   StoryItem.pageImage(
      //     url: widget.status[i].toString(),
      //     controller: storyController,
      //   ),
      // );}
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    creeateStorytems();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (storyItems.length == 0) {
      return krmLoader();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("More"),
        ),
        body: Stack(children: [
          StoryView(

            storyItems: storyItems,
            onStoryShow: (s) {
              print("Showing a story");
            },
            onComplete: () {
              print("Completed a cycle");
              Navigator.pop(context);
            },
            progressPosition: ProgressPosition.top,
            repeat: false,
            controller: storyController,
          ),
          Positioned(child: Text(""))
        ]));
  }
}
