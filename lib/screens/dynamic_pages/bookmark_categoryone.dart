import 'package:flutter/material.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';

class BookmarkCategoryone extends StatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutogglee;

  const BookmarkCategoryone({super.key,
    required this.settingstogglee,
    required this.menutogglee,
  });

  @override
  State<BookmarkCategoryone> createState() => _BookmarkCategoryoneState();
}

class _BookmarkCategoryoneState extends State<BookmarkCategoryone> {
  @override
  Widget build(BuildContext context) {
    return PrimaryPages(
      menutogglee: widget.menutogglee, 
      header: Pageheaders(
        settingstogglee: widget.settingstogglee, 
        title: 'Category 1', 
        child: null
      ),
    );
  }
}