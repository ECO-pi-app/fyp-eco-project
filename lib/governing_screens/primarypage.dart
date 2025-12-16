import 'package:flutter/material.dart';
import 'dart:math';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/governing_screens/background_drawer.dart';
import 'package:test_app/dynamic_pages/main_aboutus.dart';
import 'package:test_app/dynamic_pages/main_allocation.dart';
import 'package:test_app/dynamic_pages/main_dynamichome.dart';
import 'package:test_app/dynamic_pages/main_productanlys.dart';
import 'package:test_app/dynamic_pages/main_sustainabilitynews.dart';
import 'package:test_app/dynamic_pages/zdebug.dart';
import 'package:test_app/scope_pages/scope3_category1.dart';
import 'package:test_app/scope_pages/scope3_category2.dart';
import 'package:test_app/scope_pages/scope3_category3.dart';
import 'package:test_app/scope_pages/scope3_category4.dart';
import 'package:test_app/scope_pages/scope3_category5.dart';
import 'package:test_app/scope_pages/scope3_category9.dart';
import 'package:test_app/scope_pages/scope3_category10.dart';
import 'package:test_app/scope_pages/scope3_category11.dart';
import 'package:test_app/scope_pages/scope3_category12.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';



class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  late final List<Widget> pages;

@override
void initState() {
  super.initState();

  pages = [
    KeyedSubtree(
      key: ValueKey('home'),
      child: Dynamichome(),
    ),
    KeyedSubtree(
      key: ValueKey('analysis'),
      child: Dynamicprdanalysis(),
    ),
    KeyedSubtree(
      key: ValueKey('allocation'),
      child: DynamicAllocation(),
    ),
    KeyedSubtree(
      key: ValueKey('news'),
      child: DynamicSustainabilityNews( ),
    ),
    KeyedSubtree(
      key: ValueKey('about'),
      child: DynamicCredits(),
    ),
    KeyedSubtree(
      key: ValueKey('debug'),
      child: DebugPage(),
    ),

    //--BOOKMARKS---------------------------------------------------------------------
    KeyedSubtree(
      key: ValueKey('cat1'),
      child: BookmarkCategoryOne(),
    ),

    KeyedSubtree(
      key: ValueKey('cat2'),
      child: BookmarkCategoryTwo(),
    ),

    KeyedSubtree(
      key: ValueKey('cat3'),
      child: BookmarkCategoryThree( ),
    ),

    KeyedSubtree(
      key: ValueKey('cat4'),
      child: BookmarkCategoryFour(),
    ),

    KeyedSubtree(
      key: ValueKey('cat5'),
      child: BookmarkCategoryFive(),
    ),

    KeyedSubtree(
      key: ValueKey('cat9'),
      child: BookmarkCategoryNine(),
    ),

    KeyedSubtree(
      key: ValueKey('cat10'),
      child: BookmarkCategoryTen(),
    ),

    KeyedSubtree(
      key: ValueKey('cat11'),
      child: BookmarkCategoryEleven(),
    ),

    KeyedSubtree(
      key: ValueKey('cat12'),
      child: BookmarkCategoryTwelve(),
    ),
  ];
}


  void _onPageSelected(int index) {
   ref.read(currentPageProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {

    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final screenwidth = mediaQueryData.size.width;

    final double listWidth = min(340, screenwidth);

    final selectedIndex = ref.watch(currentPageProvider);


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

        Container(
          color: Apptheme.transparentcheat,
          width: double.infinity,
          height: double.infinity,
          child: BackgroundDrawer(onSelectPage: _onPageSelected)
        ),

        Positioned(
          top: 0,
          left: 60,
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
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Apptheme.header,
                            borderRadius: BorderRadius.all( Radius.circular(5))
                          ),
                          width: listWidth - 10,
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
                      color: Apptheme.header,
                      borderRadius: BorderRadius.all( Radius.circular(5))
                    ),
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CurrentPageIndicator(),

                        _titlebaricons((Icons.newspaper),() => _onPageSelected(3)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),


        //--Main               
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
          right: 10,
          left:  400,
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
      'Attributes',
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


Widget _titlebaricons(IconData icon,  VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.only(right: 35),
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 25,
        child: Icon(
          icon,  
          color:Apptheme.iconslight, 
          size: 20
        )
      ),
    ),
  );
}

