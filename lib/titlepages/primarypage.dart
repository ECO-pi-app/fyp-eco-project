import 'package:flutter/material.dart';
import 'dart:math';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/titlepages/background_drawer.dart';
import 'package:test_app/screens/dynamic_pages/main_aboutus.dart';
import 'package:test_app/screens/dynamic_pages/main_fallocation.dart';
import 'package:test_app/screens/dynamic_pages/main_dynamichome.dart';
import 'package:test_app/screens/dynamic_pages/main_productanlys.dart';
import 'package:test_app/screens/dynamic_pages/main_sustainabilitynews.dart';
import 'package:test_app/screens/dynamic_pages/zdebug.dart';
import 'package:test_app/screens/dynamic_pages/bookmark_category1.dart';
import 'package:test_app/screens/dynamic_pages/bookmark_category2.dart';
import 'package:test_app/screens/dynamic_pages/bookmark_category3.dart';
import 'package:test_app/screens/dynamic_pages/bookmark_category4.dart';
import 'package:test_app/screens/dynamic_pages/bookmark_category5.dart';
import 'package:test_app/screens/dynamic_pages/bookmark_category9.dart';
import 'package:test_app/screens/dynamic_pages/bookmark_category10.dart';
import 'package:test_app/screens/dynamic_pages/bookmark_category11.dart';
import 'package:test_app/screens/dynamic_pages/bookmark_category12.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';



class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  bool _showSettings = false;
  bool _showMenu = true;
  double drawerwidth = 266;
  double _prevscreenwidth = 0;

  late final List<Widget> pages;

@override
void initState() {
  super.initState();

  pages = [
    KeyedSubtree(
      key: ValueKey('home'),
      child: Dynamichome(settingstogglee: settingstoggle, menutogglee: menutoggle),
    ),
    KeyedSubtree(
      key: ValueKey('analysis'),
      child: Dynamicprdanalysis(settingstogglee: settingstoggle, menutogglee: menutoggle),
    ),
    KeyedSubtree(
      key: ValueKey('allocation'),
      child: DynamicAllocation(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),
    KeyedSubtree(
      key: ValueKey('news'),
      child: DynamicSustainabilityNews(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),
    KeyedSubtree(
      key: ValueKey('about'),
      child: DynamicCredits(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),
    KeyedSubtree(
      key: ValueKey('debug'),
      child: DebugPage(),
    ),

    //--BOOKMARKS---------------------------------------------------------------------
    KeyedSubtree(
      key: ValueKey('cat1'),
      child: BookmarkCategoryOne(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),

    KeyedSubtree(
      key: ValueKey('cat2'),
      child: BookmarkCategoryTwo(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),

    KeyedSubtree(
      key: ValueKey('cat3'),
      child: BookmarkCategoryThree(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),

    KeyedSubtree(
      key: ValueKey('cat4'),
      child: BookmarkCategoryFour(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),

    KeyedSubtree(
      key: ValueKey('cat5'),
      child: BookmarkCategoryFive(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),

    KeyedSubtree(
      key: ValueKey('cat9'),
      child: BookmarkCategoryNine(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),

    KeyedSubtree(
      key: ValueKey('cat10'),
      child: BookmarkCategoryTen(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),

    KeyedSubtree(
      key: ValueKey('cat11'),
      child: BookmarkCategoryEleven(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),

    KeyedSubtree(
      key: ValueKey('cat12'),
      child: BookmarkCategoryTwelve(settingstogglee: settingstoggle, menutoggle: menutoggle),
    ),
  ];
}


  void _onPageSelected(int index) {
   ref.read(currentPageProvider.notifier).state = index;
  }

  void settingstoggle() {
    setState(() {
      if (MediaQuery.of(context).size.width < 750) {
        if (!_showSettings) _showMenu = false;
      }
      _showSettings = !_showSettings;
  });
  }

  void menutoggle() {
    setState(() {
      if (MediaQuery.of(context).size.width < 750) {
        if (!_showMenu) _showSettings = false;
      }
      _showMenu = !_showMenu;
  });
  }

  @override
  Widget build(BuildContext context) {

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final screenwidth = mediaQueryData.size.width;

    const double openThreshold = 200;
    
    final double settingswidth = 200;
    final double menuwidth = 400;

    final double listWidth = min(400, screenwidth);

    final selectedIndex = ref.watch(currentPageProvider);

    if (_prevscreenwidth >= openThreshold &&
        screenwidth < openThreshold &&
        _showSettings && _showMenu) {
      _showSettings = false;
    }

    _prevscreenwidth = screenwidth;

    return Scaffold(
      body: 
    
    Padding(padding: EdgeInsets.all(0),
    child:
    Stack(
      alignment: AlignmentGeometry.center,
      children: [

        Container(
          color: Apptheme.backgroundlight,
          width: double.infinity,
          height: double.infinity,
          child: null,
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
            
                SizedBox(
                  width: listWidth,
                  height: 60,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(width: 60),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Apptheme.widgetsecondaryclr,
                            borderRadius: BorderRadius.all( Radius.circular(5))
                          ),
                          width: listWidth - 70,
                          child:  Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Center(
                              child: Bigfocusedtext(
                                title: 'Welcome [User]',
                                fontsize: 25,
                                color: Apptheme.textclrlight,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10,)    
                     
                    ],
                  ),
                ),
            
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: max(0, screenwidth - 405),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Apptheme.widgetsecondaryclr,
                      borderRadius: BorderRadius.all( Radius.circular(5))
                    ),
                    height: 50,
                    child: CurrentPageIndicator(),
                  ),
                ),
              ],
            ),
          ),
        ),
              
        Container(
          color: Apptheme.transparentcheat,
          width: double.infinity,
          height: double.infinity,
          child: BackgroundDrawer(onSelectPage: _onPageSelected)
        ),
              
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
          right: _showSettings ? settingswidth: 10,
          left: _showMenu ? menuwidth : 0,
          top: 70,
          bottom: 20,
          child: 
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20),
            child: 
            Container(
              color: Apptheme.transparentcheat,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ClipRect(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,

                      transitionBuilder: (child, animation) {
                        final slide = Tween<Offset>(
                          begin: Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(animation);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(position: slide, child: child),
                        );
                      },

                      child: SizedBox( 
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: pages[selectedIndex],
                      ),
                    ),
                  );
                },
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




class CurrentPageIndicator extends ConsumerWidget {
  const CurrentPageIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(currentPageProvider);

    // Map index to page name
    final pageNames = [
      'ECO-pi',
      'Analysis',
      'Allocation',
      'News',
      'About',
      'Debug',
      'Scope 3 Category 1',
      'Scope 3 Category 2',
      'Scope 3 Category 3',
      'Scope 3 Category 4',
      'Scope 3 Category 5',
      'Scope 3 Category 9',
      'Scope 3 Category 10',
      'Scope 3 Category 11',
      'Scope 3 Category 12',
    ];

    final currentPageName = pageIndex < pageNames.length
        ? pageNames[pageIndex]
        : 'Unknown';

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 5),
        child: Bigfocusedtext(
          title: currentPageName,
          fontsize: 25,
        ),
      ),
    );
  }
}

