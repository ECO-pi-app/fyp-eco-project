import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/home_tab.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widget_autosum.dart';



class Dynamichome extends StatefulWidget {
  final VoidCallback settingstogglee;
  const Dynamichome({super.key, required this.settingstogglee});


  @override
  State<Dynamichome> createState() => _DynamichomeState();
}

class _DynamichomeState extends State<Dynamichome> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: 
          Column(
          children: [

            //--Custom Header for Home--
            PageHeaderTwo(title: "ECO-pi", whathappens:widget.settingstogglee,),
            
            //--Main Page--
            Expanded(
              child: 
              Padding(padding: EdgeInsetsGeometry.only(top: 30, bottom: 20, left: 20, right: 20),
              child: 
              ManualTabpagesdoublepage(
                tab1: "Your Products", 
                tab1fontsize: 20, 
                tab2: "Your Profiles", 
                tab2fontsize: 20, 

                pg1flexValue1: 1, 
                pg1flexValue2: 2, 
                pg2flexValue1: 1, 
                pg2flexValue2: 1, 

                firstchildof1:SizedBox(height: double.infinity,child:  Center(child: Text('Widget', style: TextStyle(color: Apptheme.textclrdark, fontSize: 20),))),

                secondchildof1: SizedBox(
                  height: double.infinity,
                  child:  
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: 
                    ListView(
                      children: [
                        Center(child: 
                          Container(
                            width: double.infinity,
                            height: 330,
                            decoration: BoxDecoration(
                              color: Apptheme.widgetclrlight,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: 
                              [BoxShadow(
                                  color: Apptheme.header,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                )],
                              ),
                            child: 
                            Center(
                              child: Text('Insert Pie Charts here, by category', 
                                style: TextStyle(
                                  color: Apptheme.textclrdark, 
                                  fontSize: 20),
                                ),
                            ),
                          )
                        ),
//-------------------------------------------------------------------------------------------------------
                        Labels(title: 'Your Products', color: Apptheme.textclrlight,),

                        SizedBox(
                          width: double.infinity,
                          child: AutoaddWidget(
                            aspectratio: 16/5, 
                            color: Apptheme.widgetsecondaryclr, 
                            title: 'title'
                          ),
                        )
                      ],
                    ),
                  )
                ),

                firstchildof2: SizedBox(height: double.infinity,
                child:  
                  Center(
                    child: 
                    Text('Widget', 
                    style: TextStyle(
                      color: Apptheme.textclrdark, 
                      fontSize: 20),
                    )
                  )
                ),

                secondchildof2: SizedBox(height: double.infinity,
                child:  
                  Center(
                    child: 
                    Text('Widget', 
                    style: TextStyle(
                      color: Apptheme.textclrdark, 
                      fontSize: 20),
                    )
                  )
                ),
                
                )
              ),
            )
          ],
          ),
      );
  }
}