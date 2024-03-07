import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whattsup/groups%20d/view/CreateGroupScreen.dart';

import '../../comman/globlevariable.dart';
import '../../groups d/controller/GroupController.dart';
class groups extends ConsumerStatefulWidget {
  const groups({super.key});

  @override
  ConsumerState<groups> createState() => _groupsState();
}

class _groupsState extends ConsumerState<groups> {
  final TextEditingController groupname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          ListTile(
            leading:Container(
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius:BorderRadius.all(Radius.circular(10))

              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Stack(
                    children:[
                      Icon(
                        Icons.people,
                        size:40,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        top: 15,
                        left: 15,
                        child: IconButton(onPressed: (){
                        },icon: Icon(Icons.add_circle,size: 20,color: Colors.redAccent,),),
                        // child: CircleAvatar(
                        //   radius: 8,
                        //   backgroundColor: Colors.red,
                        //   child: IconButton(onPressed: (){
                        //     createGroup(context);
                        //   },icon:Icon(Icons.add),iconSize: 15,),
                        // ),
                      )
                    ]
                ),
              ),
            ),
            title: Text('new group'),
          ),
          Divider(thickness: 5),
          ListTile(leading: const CircleAvatar(backgroundImage: AssetImage('assets/images/swans-7736415_960_720.jpg'),),
            title: Text('Art group'),
            subtitle: Row(
              children: [
                Text('+8469650456:'),
                Icon(Icons.picture_as_pdf),
                Text('ankita pdf')
              ],
            ),
            trailing: Text('21/5/23'),),
          Divider(thickness: 2,),
          ListTile(leading: CircleAvatar(backgroundImage: AssetImage('assets/images/img.jpg'),),
            title: Text('Computer group'),
            subtitle:Row(
              children: [
                Text('+8347831462:'),
                Icon(Icons.picture_as_pdf),
                Text('flutter pdf')
              ],
            ),
            trailing: Text('4/3/23'), ),
          Container(width:MediaQuery.of(context).size.width/1.2,child: Text('>   view all')),
          Divider(thickness: 5,),
        ],
      ),
    );
  }
}
