import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';

final GlobalKey<ScaffoldState> _openDrawerKey = GlobalKey<ScaffoldState>();

//--Page Header with back--
class PageHeaderOne extends StatelessWidget {
  final String title;
  final Widget? leading;

  const PageHeaderOne({super.key, required this.title, this.leading,});

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      key: _openDrawerKey,
              height: 50,
              width: double.infinity,
              decoration: 
              BoxDecoration(
                color: Apptheme.drawer,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey,
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 4)
                    )
                  ]
              ),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                        //--Back--
                        Padding (padding: EdgeInsetsGeometry.only(left:0,),
                        child:
                        SizedBox(
                          height: double.infinity,
                          width: 75,
                        child:  leading,
                        ),
                        ),

                        //--"SPHERE"--
                        Expanded(
                          child: 
                            Padding (padding: EdgeInsetsGeometry.only(left:0, bottom: 5),
                                child:
                                Text(title,
                                style: TextStyle(
                                  color: Apptheme.textclrlight,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                ),
                                ),
                          ),
            

                          //--Settings (Trailing)--
                          Align(
                            alignment: AlignmentGeometry.centerRight,
                            child:
                              Padding (padding: EdgeInsetsGeometry.only(right:35, left: 0),
                                child: 
                                  SizedBox(
                                    height: double.infinity,
                                    width: 30,
                                    child:
                                      IconButton(
                                      onPressed: null,
                                      icon: 
                                        Icon(Icons.settings,
                                        size: 30,
                                        color: Apptheme.iconslight,
                                        ),
                                        alignment: AlignmentDirectional.centerEnd,
                                      ),                          
                                  ),        
                                ), 
                          ),
                        
                      ],
                    ) ,
                );
  }
}

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
    ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: 200,
        minHeight: 100
      ),
      child: Container(
                height: 100,
                width: double.infinity,
                decoration: 
                BoxDecoration(
                  color: Apptheme.header,
                    boxShadow: [
                      BoxShadow(
                        color: Apptheme.header,
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
                                child: Text(title,
                                style: TextStyle(
                                  color: Apptheme.textclrlight,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                                softWrap: false,
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
                  ),
    );
  }
}

//--Page Header for Others--
class PageHeaderThree extends StatelessWidget {
  final String title;

  const PageHeaderThree({super.key, required this.title,});

  @override
  Widget build(BuildContext context) {
    return 
    Container(
              height: 50,
              width: double.infinity,
              decoration: 
              BoxDecoration(
                color: Apptheme.header,
                  boxShadow: [
                    BoxShadow(
                      color: Apptheme.header,
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(0, 4)
                    )
                  ]
              ),
              child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                        //--Drawer--

                        //--Home--

                        //--"Title"--
                        Expanded(
                          child: 
                            Padding (padding: EdgeInsetsGeometry.only(left:30, top: 5),
                                child:
                                Text(title,
                                style: TextStyle(
                                  color: Apptheme.textclrlight,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                ),
                                ),
                          ),
                        
                        //--Settings (Trailing)--
                        Align(
                          alignment: AlignmentGeometry.centerRight,
                          child:
                            Padding (padding: EdgeInsetsGeometry.only(right:35, left: 0, top: 5),
                              child: 
                                SizedBox(
                                  height: double.infinity,
                                  width: 30,
                                  child:
                                    IconButton(
                                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                                    icon: 
                                      Icon(Icons.settings,
                                      size: 25,
                                      color: Apptheme.iconslight,
                                      ),
                                      alignment: AlignmentDirectional.centerEnd,
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


//--Protoype--
class PageHeaderFour extends StatelessWidget {
  final String summary;
  final String title;
  final Color color;
  final VoidCallback? whathappens;

  const PageHeaderFour({super.key, 
  required this.title, 
  required this.summary, 
  required this. color,
  this.whathappens,
  });



  @override
  Widget build(BuildContext context) {
    return 
    Container(
              height: 200,
              width: double.infinity,
              decoration: 
              BoxDecoration(
                color: Apptheme.header,
                  boxShadow: [
                    BoxShadow(
                      color: Apptheme.header,
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(0, 4)
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
                                  ListView(
                                    children: [
                                      Text(title,
                                      style: TextStyle(
                                        color: Apptheme.textclrlight,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      ),
                                    
                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Subtitlesummary(words: summary, color: color,),
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
                                    onPressed: whathappens,
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
                    ) ,
                );
  }
}

class Pageheader extends StatefulWidget {
  const Pageheader({super.key});

  @override
  State<Pageheader> createState() => PageheaderState();
}

class PageheaderState extends State<Pageheader> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}