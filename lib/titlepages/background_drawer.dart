import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
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
    
      Leftdrawerlisttile(
          title: 'Allocation', 
          whathappens: () => onSelectPage(2)),

      Leftdrawerlisttile(
        title: 'Sustainability News', 
        whathappens: () => onSelectPage(3)),

      Leftdrawerlisttile(
        title: 'About Us', 
        whathappens: () => onSelectPage(4)),

      Leftdrawerlisttile(
        title: 'Debug Page', 
        whathappens: () => onSelectPage(5)),
                  
    ];

    final List<Widget> bookmarks=[
     
                  

      Leftdrawerlisttilelight(
          title: 'Category 1 ', 
          whathappens: () => onSelectPage(6)),
                  
      Leftdrawerlisttilelight(
          title: 'Category 2', 
          whathappens: () => onSelectPage(7)),
                  
      Leftdrawerlisttilelight(
          title: 'Category 3', 
          whathappens: () => onSelectPage(8)),

      Leftdrawerlisttilelight(
          title: 'Category 4', 
          whathappens: () => onSelectPage(9)),

      Leftdrawerlisttilelight(
          title: 'Category 5', 
          whathappens: () => onSelectPage(10)),
      
      Leftdrawerlisttilelight(
          title: 'Category 9', 
          whathappens: () => onSelectPage(11)),
      
      Leftdrawerlisttilelight(
          title: 'Category 10', 
          whathappens: () => onSelectPage(12)),
                
      Leftdrawerlisttilelight(
          title: 'Category 11', 
          whathappens: () => onSelectPage(13)),
                
      Leftdrawerlisttilelight(
          title: 'Category 12', 
          whathappens: () => onSelectPage(14)),

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


class Leftdrawerlisttile extends StatelessWidget {
  final String title;
  final VoidCallback? whathappens;

  const Leftdrawerlisttile({
    super.key,
    required this.title,
    this.whathappens = empty,
  });

  static void empty() {}
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: 
        BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Apptheme.drawer,
        ),
      child: Container(
      padding: EdgeInsets.only(top: 1,bottom: 1),
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: whathappens, 
        child: 
        SizedBox(
          width: double.infinity,
          child: 
          Text(
            title,
            style: TextStyle(
              color: Apptheme.textclrlight,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.left,
            overflow: TextOverflow.fade,
            softWrap: false,
            maxLines: 1,
          ),
        ),
      ),
    )
    );
  }
}

class Leftdrawerlisttilelight extends StatelessWidget {
  final String title;
  final VoidCallback? whathappens;

  const Leftdrawerlisttilelight({
    super.key,
    required this.title,
    this.whathappens = empty,
  });

  static void empty() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 80),
      child: Container(
        height: 30,
        decoration: 
          BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Apptheme.drawerlight,
          ),
        child: Container(
        padding: EdgeInsets.symmetric(vertical: 2),
        alignment: Alignment.centerLeft,
        child: 
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Icon(Icons.bookmark, size: 15,),
            ),
      
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: whathappens, 
                  child: 
                  
                    Text(
                      title,
                      style: TextStyle(
                        color: Apptheme.textclrdark,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                      maxLines: 1,
                    ),
                  
                ),
              ),
            ),
          ],
        ),
      )
      ),
    );
  }
}
