import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoIconPopup extends StatefulWidget {
  final String text;

  const InfoIconPopup({super.key, required this.text});

  @override
  State<InfoIconPopup> createState() => _InfoIconPopupState();
}

class _InfoIconPopupState extends State<InfoIconPopup> {
  OverlayEntry? _overlayEntry;
  final double _popupWidth = 200;
  final double _cornerRadius = 5;

  // Create the overlay popup
  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy -20,          
        left: offset.dx - _popupWidth - 5,
        child: MouseRegion(
          onEnter: (_) {},
          onExit: (_) => _removeOverlay(),
          child: Material(
            type: MaterialType.transparency,
            elevation: 3,
            borderRadius: BorderRadius.circular(_cornerRadius),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_cornerRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: _popupWidth,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(_cornerRadius),
                    border: Border.all(color: Apptheme.widgetclrdark),
                  ),
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Apptheme.textclrdark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    if (_overlayEntry != null) return; // prevent duplicates

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showOverlay(),
      onExit: (_) => _removeOverlay(),
      child: const Icon(
        Icons.info_outline,
        color: Apptheme.textclrdark,
      ),
    );
  }
}




class InfoIconPopupDark extends StatefulWidget {
  final String text;
  final double iconSize;

  const InfoIconPopupDark({super.key, required this.text, this.iconSize = 18});

  @override
  State<InfoIconPopupDark> createState() => _InfoIconPopupDarkState();
}

class _InfoIconPopupDarkState extends State<InfoIconPopupDark> {
  OverlayEntry? _overlayEntry;
  final double _popupWidth = 200;
  final double _cornerRadius = 5;

  // Create the overlay popup
  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy -20,          
        left: offset.dx - _popupWidth - 5,
        child: MouseRegion(
          onEnter: (_) {},
          onExit: (_) => _removeOverlay(),
          child: Material(
            type: MaterialType.transparency,
            elevation: 3,
            borderRadius: BorderRadius.circular(_cornerRadius),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_cornerRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: _popupWidth,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Apptheme.backgrounddark.withOpacity(1),
                    borderRadius: BorderRadius.circular(_cornerRadius),
                    border: Border.all(color: Apptheme.widgetclrdark),
                  ),
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      color: Apptheme.textclrlight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOverlay() {
    if (_overlayEntry != null) return; // prevent duplicates

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showOverlay(),
      onExit: (_) => _removeOverlay(),
      child: Icon(
        Icons.info_outline,
        color: Apptheme.iconsdark,
        size: widget.iconSize,
      ),
    );
  }
}


//-----GOOGLE MAPS HYPERLINK ICON-----
class GoogleMapsIconButton extends StatelessWidget {
  final double size;
  final Color color;
  final String? searchQuery; // optional: open a specific place

  const GoogleMapsIconButton({
    super.key,
    this.size = 24,
    this.color = Colors.blue,
    this.searchQuery,
  });

  Future<void> _openMaps() async {
    final Uri url = Uri.parse(
      searchQuery == null
          ? 'https://www.google.com/maps'
          : 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(searchQuery!)}',
    );

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.map),
      iconSize: size,
      color: color,
      onPressed: _openMaps,
      tooltip: 'Open Google Maps',
    );
  }
}




