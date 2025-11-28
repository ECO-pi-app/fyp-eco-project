import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/drawerlisttile.dart';
import 'package:test_app/design/apptheme/buttons_and_icons.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/welcomelogo.dart';

class BackgroundDrawer extends StatelessWidget {
  final Function(int) onSelectPage;

  double getShortcutCountAsDouble(List<Widget> shortcuts) => shortcuts.length.toDouble();
  double getBookmarkCountAsDouble(List<Widget> bookmarks) => bookmarks.length.toDouble();



  const BackgroundDrawer({super.key, required this.onSelectPage});

  @override
  Widget build(BuildContext context) {

    final mediaQueryData = MediaQuery.of(context);
    final screenHeight = mediaQueryData.size.height;

    double getShortcutCountAsDouble(List<Widget> shortcuts) => shortcuts.length.toDouble();

    final List<Widget> shortcuts=[
                          

      Leftdrawerlisttile(
          title: 'Attributes', 
          whathappens: () => onSelectPage(1)),

      
      
       //--ADD BOUNDARY HERE FOR LATER--

    
      Leftdrawerlisttile(
          title: 'Allocation', 
          whathappens: () => onSelectPage(4)),

      Leftdrawerlisttile(
        title: 'Sustainability News', 
        whathappens: () => onSelectPage(5)),
                  
      Leftdrawerlisttile(
          title: 'About Us', 
          whathappens: () => onSelectPage(6)),
                 

      

    ];

    final List<Widget> bookmarks=[
     
                  

      Leftdrawerlisttilelight(
          title: 'Category Example ', 
          whathappens: () {}),
                  
      Leftdrawerlisttilelight(
          title: 'Category Example', 
          whathappens: () {}),
                  
      Leftdrawerlisttilelight(
          title: 'Category Example', 
          whathappens: () {}),

      Leftdrawerlisttilelight(
          title: 'Category Example', 
          whathappens: () {}),

      Leftdrawerlisttilelight(
          title: 'Category Example', 
          whathappens: () {}),

    ];

    final double shotcutsno = getShortcutCountAsDouble(shortcuts);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        //--Header & List of Pages--
        Container(
            padding: EdgeInsets.all(8),
            height: screenHeight,
            width: 250,
            child: 
            Column(
              children: [
                            
                Padding(padding: EdgeInsetsGeometry.symmetric( vertical: 20),
                  child: 
                  ConstrainedBox(constraints: BoxConstraints(maxHeight: 100, maxWidth: 100),
                    child: 
                    Welcomepagelogo(
                      whathappens: () => onSelectPage(0), 
                      choosecolor: Apptheme.transparentcheat, 
                      pad: 0,
                    ),
                  )
                ),
                            
                Expanded(
                  child: 
                  ListView(
                    children: [
    
                      Container(
                       color:  Apptheme.transparentcheat,
                       height: 40+(shotcutsno*40),
                        child: 
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: shortcuts.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Apptheme.transparentcheat,
                              elevation: 0,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                color: Apptheme.transparentcheat,
                                child: shortcuts[index],
                              ),
                            );
                          },
                        ),
                      ),
                    
                      Divider(color: Apptheme.dividers,thickness: 2,indent: 35,endIndent: 35,),
                            
                      //--LIST 2--
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: screenHeight/2.2),
                        child: 
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: bookmarks.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder:(context, index) {
                            return Card(
                              color: Apptheme.transparentcheat,
                              elevation: 0,
                              margin: EdgeInsets.all(4),
                              child: 
                              Container(
                                color: Apptheme.transparentcheat,
                                child: bookmarks[index],
                              ),
                            );
                          },
                        ),
                      ),
                    
                    ],
                  ),
                ),
              ],
            ),
          ),
              
        
        //--Settings--
        Container(
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
            
        )

      ]
    );
      
  }
}
