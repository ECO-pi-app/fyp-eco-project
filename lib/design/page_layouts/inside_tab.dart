import 'package:flutter/material.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/auto_tab_3pages.dart';


class TabWidget extends StatefulWidget {
  const TabWidget({super.key});

  @override
  State<TabWidget> createState() => _DynamicProfileState();
}

class _DynamicProfileState extends State<TabWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: 
          Column(
          children: [

            //--Custom Header for Home--
            PageHeaderThree(title: 'Profile'),
        
            
            //--Main Page--
            ManualColumn(
              childof1: Text('Example'), 
              childof2: Text('Example'), 
              flexValue1: 1, 
              flexValue2: 4)
          ],
          ),
      );
  }
}