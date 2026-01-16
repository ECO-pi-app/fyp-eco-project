import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';

class HoverSidebarWithNested extends StatefulWidget {
  final Function(int) onSelectPage;

  const HoverSidebarWithNested({super.key, required this.onSelectPage});

  @override
  State<HoverSidebarWithNested> createState() => _HoverSidebarWithNestedState();
}

class _HoverSidebarWithNestedState extends State<HoverSidebarWithNested>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _openSubmenu = false;
  double paddingbetweentiles = 25;

  @override
  Widget build(BuildContext context) {
    // --- Shortcuts (main items) ---
    final shortcuts = [
      _drawerTile(Icons.home, "Home" ,() => widget.onSelectPage(0)),
      _drawerTile((Icons.calculate),"Attributes", () => widget.onSelectPage(1)),
      _drawerTile((Icons.percent),"Allocation", () => widget.onSelectPage(2)),
      _drawerTile((Icons.laptop),"Debug Page", () => widget.onSelectPage(5)),
    ];

    // --- Bookmarks / Categories (now as submenu) ---
    final bookmarks = [
      _drawerTileLight("Climate", () => widget.onSelectPage(6)),
    ];

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _openSubmenu = false;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: _hovered ? 350 : 60,
        decoration: BoxDecoration(
          color: Apptheme.backgrounddark.withOpacity(0.6),
          borderRadius: const BorderRadius.only(topRight: Radius.circular(30)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(),
            ),
            ListView(
              padding: const EdgeInsets.only(top: 18),
              children: [
                

                // --- Shortcut Tiles ---
                ...shortcuts,

                // --- Parent Tile with Submenu (Scope & Categories) ---
                _parentTile(
                  icon: Icons.factory,
                  label: "Data Reporting and Summary",
                  isOpen: _openSubmenu,
                  onTap: () => setState(() => _openSubmenu = !_openSubmenu),
                ),

                // --- Animated Submenu ---
                if (_hovered && _openSubmenu) 
                  AnimatedSize(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOut,
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          color: Apptheme.textclrlight,
                          indent: 16,
                          endIndent: 16,
                          thickness: 1,
                        ),
                        ...bookmarks,
                      ],
                    ),
                  ),

                
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Helper Widgets ---
Widget _drawerTile(IconData icon, String title, VoidCallback onTap) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 16), // Icon padding
        SizedBox(
          height: 25,
          child: Icon(icon,  color:Apptheme.iconslight, size: 22)
        ),
        if (_hovered) ...[
          const SizedBox(width: 16), // Space between icon and label
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: onTap,
                child: Labelsinhoverdrawer(label: title, verticalpad: 25,)
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

Widget _parentTile({
  required IconData icon,
  required String label,
  required bool isOpen,
  required VoidCallback onTap,
}) {
  return ClipRRect(
    child: InkWell(
      onTap: _hovered ? onTap : null,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 16), // Icon padding
              SizedBox(
                height: 25,
                child: Icon(icon, color:Apptheme.iconslight, size: 22)
              ),
              if (_hovered) ...[
                const SizedBox(width: 16),
                  Labelsinhoverdrawer(label: label, verticalpad: 25,),
                  const SizedBox(width: 10,),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, color: Apptheme.iconslight),
                  ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}







Widget _drawerTileLight(String title, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.only(left: 0, top: 4, bottom: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 0),
        if (_hovered)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 70),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onTap,
                  child: Text(title,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          )
      ],
    ),
  );
}
    }