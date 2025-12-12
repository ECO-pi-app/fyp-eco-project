import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';

//--Page Header for Home Page--
class PageHeaderTwo extends StatelessWidget {
  
  final String title;
  final VoidCallback? whathappens;

  const PageHeaderTwo({super.key, 

  required this.title, 

  this.whathappens,
  });

  @override
  Widget build(BuildContext context) {
    return 
    Container(
              height: 160,
              width: double.infinity,
              decoration: 
              BoxDecoration(
                color: Apptheme.error,
                  boxShadow: [
                    BoxShadow(
                      color: Apptheme.error,
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: const Offset(0, 4)
                    )
                  ]
              ),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
    
                        //--Leading--
                        Align(
                          alignment: AlignmentGeometry.center,
                          child:
                            Padding (padding: EdgeInsetsGeometry.only(right:0, left: 20, top: 0),
                              child: 
                                SizedBox(
                                  height: double.infinity,
                                  width: 60,
                                  child:
                                    IconButton(
                                    onPressed:null,
                                    icon: 
                                      Icon(Icons.help,
                                      size: 30,
                                      color: Apptheme.iconslight,
                                      ),
                                      alignment: AlignmentDirectional.center,
                                      padding: EdgeInsets.zero,
                                    ),                          
                                ),        
                              ), 
                        ),
    
                        //--"Title"--
                        Expanded(
                          child: 
                            Container(
                              padding: EdgeInsets.only(bottom: 12),
                              color: Apptheme.transparentcheat,
                              child: Center(
                                child: Bigfocusedtext(
                                  title: title,
                                ),
                              ),
                            ),
                          ),
                        
                        //--Settings (Trailing)--
                        Align(
                          alignment: AlignmentGeometry.centerRight,
                          child:
                            Padding (padding: EdgeInsetsGeometry.only(right:20, left: 0, top: 0),
                              child: 
                                SizedBox(
                                  height: double.infinity,
                                  width: 60,
                                  child:
                                    IconButton(
                                    onPressed: whathappens,
                                    icon: 
                                      Icon(Icons.settings,
                                      size: 30,
                                      color: Apptheme.iconslight,
                                      ),
                                      alignment: AlignmentDirectional.center,
                                      padding: EdgeInsets.zero,
                                    ),                          
                                ),        
                              ), 
                        ),
                        
                      ],
                    ) ,
                );
  }
}

//--Page Headers--
class Pageheaders extends StatefulWidget {
  final VoidCallback? settingstogglee;
  final String title;
  final Widget? child;
  final double height;

  const Pageheaders({super.key,
  required this.settingstogglee,
  required this.title,
  required this.child,
  this.height = 140,
  });

  @override
  State<Pageheaders> createState() => PageheadersState();
}

class PageheadersState extends State<Pageheaders> {
  @override
  Widget build(BuildContext context) {
    return 
      Container(
      height: widget.height,
      width: double.infinity,
      decoration: 
      BoxDecoration(
        color: Apptheme.error,
          boxShadow: [
            BoxShadow(
              color: Apptheme.error,
              spreadRadius: 0,
              blurRadius: 0,
              offset: const Offset(0, 0)
            )
          ]
      ),
      child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            //--"Title"--
            Expanded(
              child: 
              Center(
                  child: Padding (padding: EdgeInsetsGeometry.only(left:20, right: 20, top: 15),
                      child:
                      Column(
                        children: [

                          //--TITLE--
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Titletext(
                              title: widget.title,
                              color: Apptheme.textclrdark,
                            ),
                          ),


                        
                          //--CHILD--
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Align(
                            alignment: Alignment.centerLeft,
                              child: widget.child,
                            ),
                          )
                        ],
                      ),
                      ),
                ),
              ),
            
            //--Settings (Trailing)--
            Align(
              alignment: AlignmentGeometry.center,
              child:
                Padding (padding: EdgeInsetsGeometry.only(right:35, left: 0, top: 5),
                  child: 
                    SizedBox(
                      height: double.infinity,
                      width: 40,
                      child:
                        IconButton(
                        onPressed: widget.settingstogglee,
                        icon: 
                          Icon(Icons.settings,
                          size: 25,
                          color: Apptheme.iconslight,
                          ),
                          alignment: AlignmentDirectional.center,
                          padding: EdgeInsets.zero,
                        ),                          
                    ),        
                  ), 
            ),
                
          ],
        ),
          );
            
  }
}


