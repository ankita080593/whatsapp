import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whattsup/features/auth/controller/AuthController.dart';
import 'package:whattsup/features/contacts/views/SelectContactsScreen%20.dart';
import 'package:whattsup/features/status%20d/view/textstory.dart';
import 'package:whattsup/groups%20d/view/CreateGroupScreen.dart';
import '../../features/auth/views/verification.dart';
import '../../features/status d/view/status.dart';
import '../../features/videocall/view/CallPickupScreen.dart';
import 'chat.dart';
import 'groups.dart';
import 'calls.dart';
class MobileLayout extends ConsumerStatefulWidget {
  const MobileLayout({super.key});

  @override
  ConsumerState<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends ConsumerState<MobileLayout>
    with SingleTickerProviderStateMixin,
        WidgetsBindingObserver
{
  late TabController _tabController;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state==AppLifecycleState.resumed){
      print('app Started');
      ref.read(authControllerProvider).changeUserstate(true);
    }else{
      print('app close');
      ref.read(authControllerProvider).changeUserstate(false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 0,

    )
      ..addListener(() {
        setState(() {});
      });
  }

  var tabs = <Widget>[
    groups(),
    chat(device: 'mobile',isGroup: false,reciveruid: '',),
    status(uid: '',isGroup: '',),
    calls(),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CallPickup(
      scaffold: Scaffold(backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.teal,
          title: Text('whatsup',style: TextStyle(color: Colors.white),),
          actions: [
            Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => camera()));
                    },
                    icon: Icon(Icons.camera_alt_outlined,color: Colors.white,)),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      // setState(() {
                      //   showappbar = !showappbar;
                      // });
                      // serchbar();
                    },
                    icon: Icon(Icons.search,color: Colors.white,)),
                PopupMenuButton(
                    icon: Icon(Icons.more_vert,color: Colors.white,),
                    itemBuilder: (context) {
                      var mypop = DefaultTabController.of(context)!.index;
                      if (mypop == 0) {
                        return [
                          PopupMenuItem(child: Text('settings')),
                        ];
                      } else if (mypop == 1) {
                        return [
                          PopupMenuItem(child: Text('new group')),
                          PopupMenuItem(child: Text('new broadcast')),
                          PopupMenuItem(child: Text('Linked devices')),
                          PopupMenuItem(child: Text('starred messages')),
                          PopupMenuItem(child: Text('payments')),
                          PopupMenuItem(child: Text('settings')),
                        ];
                      } else if (mypop == 2) {
                        return [
                          PopupMenuItem(child: Text('status privacy')),
                          PopupMenuItem(child: Text('settings')),
                        ];
                      } else if (mypop == 3) {
                        return [
                          PopupMenuItem(child: Text('Clear call log'),),
                          PopupMenuItem(child: Text('settings'),),
                        ];
                      }
                      return [];
                    }
                  // }

                ),
              ],
            )
          ],
          bottom: TabBar(indicatorColor: Colors.white,
            controller: _tabController,
            isScrollable: false,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Icon(Icons.people),
              Row(
                children: [
                  const Text('chat'),
                  DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white),
                      child: Text('24',
                          style: TextStyle(color: Colors.green))),
                ],
              ),
              Row(
                children: [
                  Text('status'),
                  Icon(
                    Icons.circle_rounded,
                    size: 10,
                  ),
                ],
              ),
              Text('calls'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabs,
        ),
        floatingActionButton: getFAB(_tabController!.index),
      ),
    );
  }

  Widget getFAB(index) {
    if (index == 1) {
      return FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.chat_outlined),
        onPressed: () {
           Navigator.push(
              context, MaterialPageRoute(builder: (context) => SelectContactsScreen(device:'mobile')));
        },
      );
    } else if (index == 2) {
      return Column(
        children: [
          SizedBox(height: 650),
          FloatingActionButton(
              child: Icon(
                Icons.edit,
                color: Colors.black,
              ),
              backgroundColor: Colors.grey.shade300,
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (contex) => textstory(uid: '',)));
              }),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: Colors.green,
            child: Icon(Icons.camera_alt_outlined),
            onPressed: () {
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (contex) => camera()));
            },
          ),
        ],
      );
    } else if (index == 3) {
      return FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add_call),
        onPressed: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => flotcall()));
        },
      );
    } else {
      floatingActionButton:
      return Visibility(
        visible: false,
        child: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add_call),
          onPressed: () {
            Text('message');
          },
        ),
      );
    }
  }
}
