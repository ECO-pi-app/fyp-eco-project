import 'package:flutter/material.dart';
import 'dart:math';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/dynamic_pages/popup_pages.dart';
import 'dart:ui';

void showSettingsPopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: "Popup",
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.0).animate(curved),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 70,
                right: 10,
                bottom: 70,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Apptheme.transparentcheat,
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: FrostedBackgroundSettings(child: SettingsContent()),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}
class MenuPage {
  final String title;
  final Widget page;

  MenuPage({required this.title, required this.page});
}
class _SettingsContentState extends State<SettingsContent> {
  // Current selected left menu
  int selectedMenu = 0;
  
  final List<MenuPage> menuPages = [
    MenuPage(title: 'General', page: GeneralPage()),
    MenuPage(title: 'Units', page: UnitsPage()),
    MenuPage(title: 'Admin', page: DeveloperPage())
    
  ];


  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final screenwidth = mediaQueryData.size.width;

    double padding = 0;
  

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // ---------- LEFT COLUMN ----------
          SizedBox(
            width: 200,
            child: Column(
              children: [
                // User box on top
                Container(
                  color: Apptheme.transparentcheat,
                  width: 200,
                  height: 80,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Container(
                        height: 50,
                        width: 180,
                        decoration: BoxDecoration(
                          color: Apptheme.systemUI,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Icon(
                                  Icons.supervised_user_circle,
                                  color: Apptheme.iconslight,
                                  size: 30,
                                ),
                              ),
                              Labels(
                                title: '[USER]',
                                color: Apptheme.textclrlight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Left menu items
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 0),
                    width: 200,
                    color: Apptheme.transparentcheat,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: ListView.builder(
                        itemCount: menuPages.length,
                        itemBuilder: (context, index) {
                          final item = menuPages[index];
                          return ListTileItems(
                            title: item.title, 
                            navigateto: (title) {
                              setState(() {
                                selectedMenu = index;
                              });
                            }, 
                            padding: padding
                          );
                        }
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: padding),

          // ---------- RIGHT COLUMN ----------
          SizedBox(
            width: max(0, screenwidth - 80 - (padding * 3) - 200),
            child: Column(
              children: [
                // Header
                Container(
                  color: Apptheme.transparentcheat,
                  width: max(0, screenwidth - 80 - (padding * 3) - 200),
                  height: 50,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Labels(
                      title: menuPages[selectedMenu].title,
                      color: Apptheme.textclrlight,
                      fontsize: 30,
                      leftpadding: 20,
                    ),
                  ),
                ),

                // Main Page
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    width: max(0, screenwidth - 80 - (padding * 3) - 200),
                    decoration: BoxDecoration(
                      color: Apptheme.backgroundlight.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10)),
                    ),
                    child: menuPages[selectedMenu].page,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//-------------------------------------REUSEABLE LISTTILE ITEMS------------------------------------
class ListTileItems extends StatelessWidget {
  final String title;
  final ValueChanged<String> navigateto;
  final double padding;

  const ListTileItems({
    super.key,
    required this.title,
    required this.navigateto,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () => navigateto(title),
      child: Container(
        width: max(0, screenWidth - 80 - (padding * 3) - 200),
        height: 50,
        decoration: BoxDecoration(
          color: Apptheme.transparentcheat,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 0),
        child: Labels(
          title: title,
          color: Apptheme.textclrlight,
          fontsize: 20,
        ),
      ),
    );
  }
}
//-------------------------------------REUSEABLE TRANSLUCENT BACKGROUND----------------------------
class FrostedBackgroundSettings extends StatelessWidget {
  final Widget child;
  const FrostedBackgroundSettings({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: Apptheme.backgrounddark.withOpacity(0.6),
          child: child,
        ),
      ),
    );
  }
}
