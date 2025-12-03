import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';

class Widgets1 extends StatelessWidget {
  final double aspectratio;
  final Widget? child;
  final double maxheight;
  const Widgets1({super.key, 
  required this.aspectratio, 
  this.child,
  required this.maxheight,
  });



  @override
  Widget build(BuildContext context) {
    return 
    ConstrainedBox( constraints: BoxConstraints(maxHeight: maxheight),
      child: 
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Apptheme.widgetclrlight,
          boxShadow: [BoxShadow(
            color: Apptheme.header,
            spreadRadius: 2,
            blurRadius: 2,
          )],
          border: Border.all(
            color: Apptheme.widgetclrlight,
            width: 1,
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignOutside,
            )
        ),
        child: child ,
      ),
    );
  }
}


class Widgets2 extends StatelessWidget {
  final double aspectratio;
  final Widget? child;
  final Color color;
  const Widgets2({super.key, required this.aspectratio, this.child, required this.color});



  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 80
      ),
      child: 
      AspectRatio(
        aspectRatio: aspectratio,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
            border: Border.all(
              color: Apptheme.widgetborderlight,
              width: 5,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignOutside,
              )
          ),
          child: child ,
        ),
      ),
    );
  }
}

