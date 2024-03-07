import 'package:flutter/material.dart';
import 'package:whattsup/Mywidget/web/webLayout.dart';

import 'Mywidget/Mobile/MobileLayout.dart';
class myLayout extends StatelessWidget {
  const myLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth>700){
      return  webLayout();
      }else{
        return MobileLayout();
      }
    });
  }
}
