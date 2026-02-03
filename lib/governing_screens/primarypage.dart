import 'package:flutter/material.dart';
import 'dart:math';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/governing_screens/background_drawer.dart';
import 'package:test_app/dynamic_pages/main_aboutus.dart';
import 'package:test_app/dynamic_pages/main_assembly.dart';
import 'package:test_app/dynamic_pages/main_home.dart';
import 'package:test_app/dynamic_pages/main_productanlys.dart';
import 'package:test_app/dynamic_pages/main_sustainabilitynews.dart';
import 'package:test_app/dynamic_pages/main_scopeanalysis.dart';
import 'package:test_app/app_logic/river_controls.dart';
import 'package:test_app/scope_pages/scope3_category1.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class HomeScreen extends ConsumerStatefulWidget {
  final String profileName;
  final String productID;

  const HomeScreen({
    super.key,
    required this.profileName,
    required this.productID,
  });

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
      child: Dynamichome(productName: widget.profileName,),
    ),
    KeyedSubtree(
      key: ValueKey('analysis'),
      child: Dynamicprdanalysis(productID: widget.profileName,),
    ),
    KeyedSubtree(
      key: ValueKey('scope'),
      child: Scopeanalysis(productID: widget.profileName,),
    ),
    KeyedSubtree(
      key: ValueKey('assembly'),
      child: DynamicAssembly(),
    ),
    KeyedSubtree(
      key: ValueKey('news'),
      child: DynamicSustainabilityNews( ),
    ),
    KeyedSubtree(
      key: ValueKey('about'),
      child: DynamicCredits(),
    ),

    //--BOOKMARKS---------------------------------------------------------------------
    KeyedSubtree(
      key: ValueKey('cat1'),
      child: ProductDetailForm(productId: widget.profileName,),
    ),

  ];
}

  void _onPageSelected(int index) {
    ref.read(currentPageProvider.notifier).state = index;
  } 


  final Map<int, Widget> _pageGuides = {
    0: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textsinsidewidgetsdrysafe(words: "Welcome to ECO-pi", color: Apptheme.textclrlight, fontsize: 20, fontweight: FontWeight.bold,),
        SizedBox(height: 8),
        Textsinsidewidgetsdrysafe(words: "Example Text 1", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgetsdrysafe(words: "Example Text 2", color: Apptheme.textclrlight, leftpadding: 5,),
      ],
    ),
    1: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textsinsidewidgets(words: "Part Analysis Guide", color: Apptheme.textclrlight, fontsize: 18, fontweight: FontWeight.bold,),
        SizedBox(height: 8),
        Textsinsidewidgets(words: "• Analyze each part individually.", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgets(words: "• Check material composition and emissions.", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgets(words: "• Hover over tiles for details.", color: Apptheme.textclrlight, leftpadding: 5,),
      ],
    ),
    2: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textsinsidewidgets(words: "Scope Analysis Guide", color: Apptheme.textclrlight, fontsize: 18, fontweight: FontWeight.bold,),
        SizedBox(height: 8),
        Textsinsidewidgets(words: "• Scope 1, 2, 3 emissions explained.", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgets(words: "• Visualizations show total impact per category.", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgets(words: "• Use the side menu to navigate.", color: Apptheme.textclrlight, leftpadding: 5,),
      ],
    ),
    3: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textsinsidewidgets(words: "Assembly Guide", color: Apptheme.textclrlight, fontsize: 18, fontweight: FontWeight.bold,),
        SizedBox(height: 8),
        Textsinsidewidgets(words: "• Review assembly steps.", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgets(words: "• Identify high-impact operations.", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgets(words: "• Click parts to view details.", color: Apptheme.textclrlight, leftpadding: 5,),
      ],
    ),
    4: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textsinsidewidgets(words: "Sustainability News", color: Apptheme.textclrlight, fontsize: 18, fontweight: FontWeight.bold,),
        SizedBox(height: 8),
        Textsinsidewidgets(words: "• Latest updates and articles.", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgets(words: "• Filter by topic or category.", color: Apptheme.textclrlight, leftpadding: 5,),
      ],
    ),
    5: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textsinsidewidgets(words: "About Page", color: Apptheme.textclrlight, fontsize: 18, fontweight: FontWeight.bold,),
        SizedBox(height: 8),
        Textsinsidewidgets(words: "• App info and team.", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgets(words: "• Credits and version history.", color: Apptheme.textclrlight, leftpadding: 5,),
      ],
    ),
    6: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textsinsidewidgets(words: "Climate Summary", color: Apptheme.textclrlight, fontsize: 18, fontweight: FontWeight.bold,),
        SizedBox(height: 8),
        Textsinsidewidgets(words: "• Scope 3 Category 1 details.", color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgets(words: "• Quick summaries for bookmarked items.", color: Apptheme.textclrlight, leftpadding: 5,),
      ],
    ),
  };


void _showPageGuide() {
  final pageIndex = ref.read(currentPageProvider);
  final guideContent = _pageGuides[pageIndex] ??
      const Text("No guide available for this page.");

  showDialog(
    context: context,
    builder: (context) {
      return PageGuideDialog(
        title: "Page Guide",
        content: guideContent,
      );
    },
  );
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
          child: BackgroundDrawer(onSelectPage: _onPageSelected, profileName: widget.profileName)
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
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          width: listWidth - 10,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Center(
                              child: Bigfocusedtext(
                                title: widget.profileName,
                                fontsize: 23,
                                color: Apptheme.textclrlight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
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

                        Row(
                          children: [
                            _titlebaricons(Icons.newspaper,() => _onPageSelected(4)),
                            GuideIconButton(
                              onTap: _showPageGuide,
                            )


                          ]
                        )
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
      'Part Analysis',
      'Scope Analysis',
      'Assembly (BETA TESTING)',
      'Sustainability News',
      'About',
      'Data Summary: Climate',
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

class GuideIconButton extends StatefulWidget {
  final VoidCallback onTap;
  final String tooltip;

  const GuideIconButton({
    super.key,
    required this.onTap,
    this.tooltip = "Page guide",
  });

  @override
  State<GuideIconButton> createState() => _GuideIconButtonState();
}

class _GuideIconButtonState extends State<GuideIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(right: 35),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _hovered
                ? Apptheme.header.withOpacity(0.85)
                : Apptheme.header.withOpacity(0.6),
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              if (_hovered)
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: widget.onTap,
            child: Icon(
              Icons.info_outline,
              size: 20,
              color: Apptheme.iconslight,
            ),
          ),
        ),
      ),
    );
  }
}

class PageGuideDialog extends StatelessWidget {
  final String title;
  final Widget content;

  const PageGuideDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Apptheme.backgrounddark,
      title: Titletext(
        title: title,
        fontsize: 24,
        color: Apptheme.textclrlight,
      ),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: content,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Textsinsidewidgetsdrysafe(
            words: "Close",
            color: Apptheme.textclrlight,
          ),
        )
      ],
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


