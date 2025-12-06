import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';


class DebugPage extends StatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutoggle;

  const DebugPage({super.key, 
  required this.settingstogglee,
  required this.menutoggle,
  });

  @override
  State<DebugPage> createState() => _DynamicProfileState();
}

class _DynamicProfileState extends State<DebugPage> {
  @override
  Widget build(BuildContext context) {
    return  PrimaryPages(
      menutogglee: widget.menutoggle, 
      header: Pageheaders(
        settingstogglee: widget.settingstogglee, 
        title: 'Category 1', 
        child: Headertext(
          words: 'Purchased Goods and Services',
          backgroundcolor: Apptheme.header,
        )
      ),
      childofmainpage: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Widgets1(
              maxheight: 500,
              child: Column(
                children: [
                  Labels(title: 'Attributes included', color: Apptheme.textclrdark)
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Widgets1(
              maxheight: 500,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Labels(title: 'Emissions by activities', color: Apptheme.textclrdark),

                  ],
                )
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Widgets1(
              maxheight: 500,
              child: Column(
                children: [
                  Labels(title: 'Declarations', color: Apptheme.textclrdark)
                ],
              )
            ),
          ),

        ],
      ),
    );
  }
}





class DebugCanvas extends StatefulWidget {
  final VoidCallback menutogglee;
  final Widget? childofmainpage;
  final Color backgroundcolor;

  const DebugCanvas({super.key,
  required this.menutogglee,
  this.childofmainpage,
  required this.backgroundcolor,
  });

  @override
  State<DebugCanvas> createState() => _DebugCanvasState();
}

class _DebugCanvasState extends State<DebugCanvas> {

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
                    child: widget.childofmainpage,
                  ),
                ),
              ),
            
            ]
          ),
      );

      
  }
}