import 'package:flutter/material.dart';
import 'package:test_app/app_logic/riverpod_account.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
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
  final Product profileName;
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
      child: Dynamichome(productName: widget.profileName.name,),
    ),
    KeyedSubtree(
      key: ValueKey('analysis'),
      child: Dynamicprdanalysis(productID: widget.profileName.name,),
    ),
    KeyedSubtree(
      key: ValueKey('scope'),
      child: Scopeanalysis(productID: widget.profileName.name,),
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
      children: const [
        Textsinsidewidgetsdrysafe(words: "Welcome to ECO-pi", color: Apptheme.textclrlight, fontsize: 20, fontweight: FontWeight.bold,),
        Textsinsidewidgetsdrysafe(words: 
        "This is the home page. This is where the user can see define the duration of the LCA analysis, define the parts involved in a project and see the data visualisations of emissions associated with each part.", 
        color: Apptheme.textclrlight, leftpadding: 5,),
        SizedBox(height: 15),
        Textsinsidewidgetsdrysafe(words: 
        "First, click on the + icon on the right of 'Timeline' to define the analysis duration. Next, click on the + icon on the right of 'Parts' to add parts to your project. Once parts are added, you can view their emissions data visualisations in the pie chart on the left.",
        color: Apptheme.textclrlight, leftpadding: 5,),
        Textsinsidewidgetsdrysafe(words: 
        "Each timeline has a list of parts. Select a timeline from the list on the top right to view its associated parts and their emissions data. You can also cycle through the list of parts to see their individual data visualisations in the pie chart on their left. A timeline and a part must be first defined before proceeding to the analysis pages to start the LCA analysis.", 
        color: Apptheme.textclrlight, leftpadding: 5,),
      ],
    ),
    1: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textsinsidewidgetsdrysafe(words: "Activity Analysis Guide", color: Apptheme.textclrlight, fontsize: 20, fontweight: FontWeight.bold,),
        Textsinsidewidgetsdrysafe(words: 
        "This is the Activity Analysis page. This and the Scope Analysis page are where the user can enter the parameters of the products being analysed. Activity Analysis categorises emissions based on activities involved throughout the product lifecycle from material extraction to disposal.", 
        color: Apptheme.textclrlight, leftpadding: 5, maxLines: 50,),
        SizedBox(height: 15),
        Textsinsidewidgetsdrysafe(words: 
        "Upstream, Production and Downstream activities are split into three tabs. The definition of each is as follows:\n\n• Upstream: Activities before the product reaches the manufacturer (e.g., raw material extraction, transportation to factory).\n\n• Production: Activities during the manufacturing process (e.g., assembly, energy use in factory).\n\n• Downstream: Activities after the product leaves the manufacturer (e.g., distribution, usage, end-of-life disposal).",
        color: Apptheme.textclrlight, leftpadding: 5, maxLines: 50,),
        SizedBox(height: 15),
        Textsinsidewidgetsdrysafe(words: 
        "Each activity has to be first defined with its parameters (e.g., distance, energy consumption) before the emissions can be calculated and visualised in the pie chart on the left. \n\n• First, click the + - button found next to the 'Calculate Emissions' button. \n\n• For a brand new project, it will be empty. Click on the plus sign to add a new column. \n\n• Click the fine tune button next to the info (i) icon at each of the activity title (e.g. Material Input | 0.00 kg CO2) to define the factor for each row. This factor is in place in case users want to adjust the default values using a ratio (e.g. Load factor for machines) improving accuracy without the user having to manually calculate each value. \n\n• Scroll to the right to see all parameter fields.", 
        color: Apptheme.textclrlight, leftpadding: 5,maxLines: 50,),
      ],
    ),
    2: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Textsinsidewidgetsdrysafe(words: "Scope Analysis Guide", color: Apptheme.textclrlight, fontsize: 20, fontweight: FontWeight.bold,),
        Textsinsidewidgetsdrysafe(words: 
        "This is the Scope Analysis page. This and the Activity Analysis page are where the user can enter the parameters of the products being analysed. Scope Analysis categorises emissions based on the 15 categories defined by the GHG Protocol for project level emissions.", 
        color: Apptheme.textclrlight, leftpadding: 5, maxLines: 50,),
        SizedBox(height: 15),
        Textsinsidewidgetsdrysafe(words: 
        "Main and Scope 3 emissions are split into two tabs. The definition of each is as follows:\n\n• Main: Direct emissions from owned or controlled sources (Scope 1) and indirect emissions from the generation of purchased electricity, steam, heating, and cooling consumed by the reporting company (Scope 2).\n\n• Scope 3: All other indirect emissions that occur in a company’s value chain (e.g., purchased goods and services, business travel, waste disposal).\n\nNote: This app currently focuses on Scope 3 for detailed analysis. Though it covers manufacturing emissions, Scope 1 and 2 are not detailed here.",
        color: Apptheme.textclrlight, leftpadding: 5, maxLines: 50,),
        SizedBox(height: 15),
        Textsinsidewidgetsdrysafe(words: 
        "Each activity has to be first defined with its parameters (e.g., distance, energy consumption) before the emissions can be calculated and visualised in the pie chart on the left. \n\n• First, click the + - button found next to the 'Calculate Emissions' button. \n\n• For a brand new project, it will be empty. Click on the plus sign to add a new column. \n\n• Click the fine tune button next to the activity title (e.g. Material Input | 0.00 kg CO2) to define the factor for each row. This factor is in place in case users want to adjust the default values using a ratio (e.g. Load factor for machines) improving accuracy without the user having to manually calculate each value. \n\n• Scroll to the right to see all parameter fields.", 
        color: Apptheme.textclrlight, leftpadding: 5,maxLines: 50,),
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
          child: BackgroundDrawer(onSelectPage: _onPageSelected, profileName: widget.profileName.name)
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
                                title: widget.profileName.name,
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
                            SaveProfileIconButton(),
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
      'Activity Analysis',
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

class SaveProfileIconButton extends ConsumerStatefulWidget {
  final String description;
  final String tooltip;

  const SaveProfileIconButton({
    super.key,
    this.description = "Auto-save description",
    this.tooltip = "Save profile",
  });

  @override
  ConsumerState<SaveProfileIconButton> createState() =>
      _SaveProfileIconButtonState();
}

class _SaveProfileIconButtonState
    extends ConsumerState<SaveProfileIconButton> {
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
                ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () async {
              final activeProduct = ref.read(activeProductProvider);
              final activePart = ref.read(activePartProvider);
              final username = await ref.read(usernameProvider.future);

              if (activeProduct == null ||
                  activePart == null ||
                  username == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Nothing to save!")),
                );
                return;
              }

              final key = (product: activeProduct.name, part: activePart);

              try {
                await saveProfile(
                  ref,
                  activeProduct.name,
                  widget.description,
                  username,
                  key,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Profile saved successfully!"),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error saving profile: $e")),
                );
              }
            },
            child: Icon(
              Icons.save,
              size: 20,
              color: Apptheme.iconslight,
            ),
          ),
        ),
      ),
    );
  }
}

