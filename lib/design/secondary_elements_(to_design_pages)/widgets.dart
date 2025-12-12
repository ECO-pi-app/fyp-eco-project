import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';

//--Fixed height widgets--
class Widgets1 extends StatelessWidget {
  final Color backgroundcolor ;
  final Color bordercolor ;
  final double maxheight;
  final Widget? child;

  const Widgets1({super.key, 
  this.backgroundcolor =Apptheme.transparentcheat,
  this.bordercolor = Apptheme.transparentcheat,
  required this.maxheight,
  this.child,
  });

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        height: maxheight,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundcolor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(
            color: bordercolor,
            spreadRadius: 2,
            blurRadius: 2,
          )],
        ),
        child: child ,
      ),
    );
  }
}

//--Fit-height widgets--
class Widgets2 extends StatelessWidget {
  final Color backgroundcolor ;
  final Color bordercolor ;
  final Widget? child;

  const Widgets2({super.key, 
  this.backgroundcolor =Apptheme.widgetclrlight,
  this.bordercolor = Apptheme.widgetclrdark,
  this.child,
  });

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: EdgeInsets.only(bottom: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundcolor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(
            color: bordercolor,
            spreadRadius: 2,
            blurRadius: 2,
          )],
        ),
        child: child ,
      ),
    );
  }
}

//--Widget for products-add box in homepage--
class AutoAddedWidget extends StatelessWidget {
  final Widget? child;
  final Color color;

  const AutoAddedWidget({super.key, 
  this.child, 
  required this.color
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
        border: Border.all(
          color: Apptheme.widgetclrdark,
          width: 2,
          style: BorderStyle.solid,
          strokeAlign: BorderSide.strokeAlignOutside,
          )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: child,
      ) ,
    );
  }
}

