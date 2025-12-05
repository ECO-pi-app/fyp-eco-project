import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';

class PrimaryPages extends StatefulWidget {
  final VoidCallback menutogglee;
  final double paddingadd;
  final Widget? childofmainpage;
  final Widget? header;

  const PrimaryPages({super.key,
  required this.menutogglee,
  this.paddingadd =0,
  this.childofmainpage,
  required this.header,
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
          Stack(
            children: [
              
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30, right: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Apptheme.transparentcheat,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0
                    )
                  )
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child:
                    //--Handle--
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Container(
                          height: double.infinity,
                          width: 25,
                          
                          decoration: BoxDecoration(
                            color: Apptheme.systemUI,
                            
                            border: Border(
                              right: BorderSide(
                                color: Apptheme.systemUI,
                                width: 2
                              )
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30)
                            )
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: widget.menutogglee, 
                              icon: Icon(
                                Icons.drag_indicator, 
                                color: Apptheme.iconslight,
                                size: 25,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ),
                ),
              ),

              Positioned(
                left: 25,
                right: 4,
                top: 4,
                bottom: 4,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Container(
                    color: Apptheme.backgroundlight,
                    child: Stack(
                    children: [
                    
                      //--Main Page--
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                            child: 
                            Container(
                              padding: EdgeInsets.only(bottom: 15, top:140+widget.paddingadd),
                              color: Apptheme.backgroundlight,
                              child: widget.childofmainpage,
                            ),
                          ),
                        ),
                      ),
                    
                      //--Custom Header for Home--
                      Align(
                        alignment: Alignment.topCenter,
                        child: widget.header,
                      ),
                    ],
                    ),
                  ),
                ),
              ),
            
            ]
          ),
      );

      
  }
}