import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/buttons_and_icons.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/hover_drawer.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/welcomelogo.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/sub_drawer.dart';
import 'package:test_app/dynamic_pages/master_panel.dart';

class BackgroundDrawer extends ConsumerStatefulWidget {
  final Function(int) onSelectPage;

  const BackgroundDrawer({super.key, required this.onSelectPage});

    @override
  ConsumerState<BackgroundDrawer> createState() => _BackgroundDrawerState();
}

class _BackgroundDrawerState extends ConsumerState<BackgroundDrawer> {

  double getShortcutCountAsDouble(List<Widget> shortcuts) => shortcuts.length.toDouble();
  double getBookmarkCountAsDouble(List<Widget> bookmarks) => bookmarks.length.toDouble();

  @override
  Widget build(BuildContext context) {

    final mediaQueryData = MediaQuery.of(context);
    final screenHeight = mediaQueryData.size.height;


    return Stack(
      children: [

        Container(
            color: Apptheme.transparentcheat,
            height: screenHeight,
            width: 400,
            child: 
            Column(
              children: [
                            
                Padding(
                  padding: const EdgeInsets.all(2.5),
                  child: HeaderofMasterPanel(onSelectPage: widget.onSelectPage),
                ),
        
                Expanded(
                  child: Padding(padding: EdgeInsetsGeometry.only(left: 70, top: 10, right: 10),
                  child: Align(alignment: Alignment.centerLeft,child: MasterPanel()),
                  ),
                ),
        
              ],
            ),
          ),
      
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 65),
            child: HoverSidebarWithNested(onSelectPage: widget.onSelectPage,),
          )
        ),

        Align(
          alignment: Alignment.bottomLeft,
          child: LShapeContainer(
            verticalWidth: 60, 
            horizontalHeight: 20,
            onSelectPage: widget.onSelectPage,
          )
        )
      
      ],
    );
      
  }
}



class HeaderofMasterPanel extends StatelessWidget {
  final Function(int) onSelectPage;
  const HeaderofMasterPanel({super.key, required this.onSelectPage});
  

  @override
  Widget build(BuildContext context) {
    double headeradjust = 0;
    return Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 0),
      child: 
      Container(
        alignment: Alignment.centerLeft,
        height: 60-(2*0),
        decoration: BoxDecoration(
          color: Apptheme.transparentcheat,
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 0+headeradjust,),
              Welcomepagelogo(
                whathappens: () => onSelectPage(0), 
                choosecolor: Apptheme.transparentcheat, 
                pad: 0,
                size: 70,
              ),
              SizedBox(width: 75-headeradjust),
            ],
          ),
        ),
      )
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25, bottom: 12),
      width:  200,
      decoration: BoxDecoration(color: Apptheme.transparentcheat),
      child: 
    
      //--THE LIST IS HERE--
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
    
          LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            double parentWidth = constraints.maxWidth;
    
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: 
              Container(
                alignment: Alignment.center,
                width: parentWidth/1.1,
                height: 80,
                decoration: BoxDecoration(
                  color: Apptheme.drawer,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: 
                Text('Settings',
                  style: TextStyle(
                    color: Apptheme.textclrlight,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.fade,
                    fontSize: 25
                  ),
                  maxLines: 1,
                  softWrap: false,
                  textAlign: TextAlign.center,                 
                ),
              ),
            );
          },),
    
          Expanded(
            child:
            Padding(
              padding: const EdgeInsets.all(16),
              child: 
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Apptheme.dividers,
                  )
                ),
              ),
            )
          ),
    
          Padding(
            padding: const EdgeInsets.all(8),
            child: 
            Container(
              decoration: BoxDecoration(
                color: Apptheme.drawer,
                borderRadius: BorderRadius.circular(10)
                ),
              height: 35,
              width: double.infinity,
              child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  TextButton(onPressed:   () => Navigator.pushNamed(context, '/welcomepage'),
                  child:
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Center(
                        child: Text('Logout', 
                          style: TextStyle(
                          fontSize: 20,
                          color: Apptheme.textclrlight,
                          ),
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        softWrap: false,
                        ),
                      ),
                    ),
                  ),
                          
                  Loggingout(),
                                      
                ],
              ),
            ),
          ),
        ],
      ),
        
    );
  }
}

