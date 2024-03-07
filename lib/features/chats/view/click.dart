import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../enum/enum12.dart';
import '../controller/chatClassConroller.dart';
class click extends ConsumerStatefulWidget {
  final path;
  final uid;
final isGroup;
  const click({Key? key,required this.path,required this.uid,required this.isGroup}) : super(key: key);

  @override
  ConsumerState<click> createState() => _clickState();
}

class _clickState extends ConsumerState<click> {
  TextEditingController area=TextEditingController();
  void sendFilemessage(BuildContext context, File pickedFile) {
    ref.read(chatClassControllerProvider).sendFilemessage(
      context: context,
      file: pickedFile,
      reciveruid: widget.uid,
      messageEnum: MessageEnum.image,
      isGroup: widget.isGroup,
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      body:
      /*Container(child:Image.file(File(widget.path)),)*/SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [Container(child:Image.file(File(widget.path)),),

                Positioned(top:30,left:10,child: IconButton(onPressed:(){},icon:Icon(Icons.close,color: Colors.white,))),
                Positioned(top:30,left:200,child:IconButton(onPressed:(){},icon:Icon(Icons.crop_rotate,color: Colors.white,))),
                Positioned(top:30,left:250,child:IconButton(onPressed:(){},icon:Icon(Icons.emoji_emotions_outlined,color: Colors.white,)),),
                Positioned(top:30,right:50,child: IconButton(onPressed:(){},icon:Icon(Icons.title,color: Colors.white,)),),
                Positioned(top:30,right:10,child: IconButton(onPressed:(){},icon:Icon(Icons.edit_outlined,color: Colors.white,),)),
                Positioned(bottom:100,left:180,child: IconButton(onPressed:(){},icon:Icon(Icons.keyboard_arrow_up_outlined,color: Colors.white,),)),
                Positioned(bottom:90,left:187,child: Text('Filter',style: TextStyle(color: Colors.white),)),
                Positioned(bottom:0,left:5,child: Container(height: 40,width:380,
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.grey.shade800),
                  child: TextFormField(
                    controller: area,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(hintText: 'Add a caption...',hintStyle: TextStyle(color: Colors.white,),
                        border: InputBorder.none,
                        prefixIcon:IconButton(onPressed:(){
                        },icon:Icon(Icons.add_photo_alternate,color: Colors.white,),),
                        suffixIcon: IconButton(onPressed: (){},icon: Icon(Icons.av_timer,color: Colors.white,),)),
                  ),
                ),
                ),
              ],),
            Row(
              children: [SizedBox(height:MediaQuery.of(context).size.height/10,
                width: 10,),
                Container(height: 30,width: 60,padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Colors.grey.shade800,),
                  child: Text('Tushar',style: TextStyle(color: Colors.white),),),
                SizedBox(height: MediaQuery.of(context).size.height/10,width: 265,),
                CircleAvatar(child:IconButton(onPressed:(){
                  sendFilemessage(context,
                    File(widget.path),
                  );
                },icon:Icon(Icons.send,color: Colors.white,)),backgroundColor: Colors.green,radius: 25,)

              ],
            ),
          ],
        ),


      ),
    );
  }
}
