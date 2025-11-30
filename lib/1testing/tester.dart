import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/auto_tab_3pages.dart';


class TabWidgettest extends StatefulWidget {
  final double height1;
  final double height2;
  final int flex1;
  final int flex2;

  const TabWidgettest({super.key,
    required this.height1,
    required this.height2,
    required this.flex1,
    required this.flex2,
  
  });

  @override
  State<TabWidgettest> createState() => _TabWidgettestState();
}

class _TabWidgettestState extends State<TabWidgettest> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: 
            
            //--Main Page--
            ManualColumn(

              //--Left Widget--
              childof1:
              Container(
                width: double.infinity,
                height: widget.height1,
                decoration: BoxDecoration(
                  color: Apptheme.windowcontrols,
                ),
              ), 


              //--Right Widget--
              childof2:
              Container(
                width: double.infinity,
                height: widget.height2,
                decoration: BoxDecoration(
                  color: Apptheme.windowcontrols,
                ),
              ), 


              //--Flex Values--
              flexValue1: widget.flex1, 
              flexValue2: widget.flex2)

      );
  }
}