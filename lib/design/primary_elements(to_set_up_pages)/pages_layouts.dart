import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';

class PrimaryPages extends StatefulWidget {
  final VoidCallback menutogglee;
  final Widget? childofmainpage;
  final Widget? header;
  final Color backgroundcolor;

  const PrimaryPages({super.key,
  required this.menutogglee,
  this.childofmainpage,
  required this.header,
  this.backgroundcolor = Apptheme.backgroundlight,
  });

  @override
  State<PrimaryPages> createState() => _PrimaryPagesState();
}

class _PrimaryPagesState extends State<PrimaryPages> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        child: 
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(5),
            child: Container(
              color: Apptheme.widgetclrlight,
              child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
                child: 
                Container(
                  padding: EdgeInsets.only(bottom: 10, top:10),
                  child: widget.childofmainpage,
                ),
              ),
            ),
          ),
      );

      
  }
}