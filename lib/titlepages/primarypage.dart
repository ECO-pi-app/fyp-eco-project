import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/titlepages/background_drawer.dart';
import 'package:test_app/screens/dynamic_pages/haboutus.dart';
import 'package:test_app/screens/dynamic_pages/fallocation.dart';
import 'package:test_app/screens/dynamic_pages/bdynamichome.dart';
import 'package:test_app/screens/dynamic_pages/bproductanlys.dart';
import 'package:test_app/screens/dynamic_pages/gsustainabilitynews.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  int _selectedIndex = 0;
  bool _showSettings = false;
  double drawerwidth = 266;
  double _prevscreenwidth = 0;


  void _onPageSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void settingstoggle() {
    setState(() {
      _showSettings = !_showSettings;
  });
  }

  @override
  Widget build(BuildContext context) {

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final screenwidth = mediaQueryData.size.width;

    const double openThreshold = 1000;
    

    final double drawerwidth = 266;
    final double settingswidth = 200;

    final double dynamicDrawerWidth = screenwidth < 750 ? 5 : drawerwidth;

    

    if (_prevscreenwidth >= openThreshold &&
        screenwidth < openThreshold &&
        _showSettings) {
      _showSettings = false;
    }

    _prevscreenwidth = screenwidth;

    //--Dynamic Pages (DRAWER DIRECTORY)--
    final List<Widget> pages = [
      Dynamichome(settingstogglee: settingstoggle),
      Dynamicprdanalysis(settingstogglee: settingstoggle),
      DynamicAllocation(settingstogglee: settingstoggle,),
      DynamicSustainabilityNews(settingstogglee: settingstoggle),
      DynamicCredits(settingstogglee: settingstoggle),
    ];

    return Scaffold(
      body: 
    
    Padding(padding: EdgeInsetsGeometry.all(0),
    child:
    Stack(
      alignment: AlignmentGeometry.center,
      children: [
              
        Container(
          color: Apptheme.drawerbackground,
          width: double.infinity,
          height: double.infinity,
          child: BackgroundDrawer(onSelectPage: _onPageSelected)
        ),
              
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
          right: _showSettings ? settingswidth: 5,
          left: dynamicDrawerWidth,
          top: 2,
          bottom: 2,
          child: 
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: 
            ClipRRect(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(25)),
              child: 
              
              Container(
                color: Apptheme.backgroundlight,
                child: pages[_selectedIndex]
              )
            ),
          ),
        )
              
              
      ],
    )
    )
      );
  }
}