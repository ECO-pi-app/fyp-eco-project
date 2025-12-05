import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets1.dart';

class BookmarkCategoryOne extends StatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutoggle;

  const BookmarkCategoryOne({super.key,
    required this.settingstogglee,
    required this.menutoggle,
  });

  @override
  State<BookmarkCategoryOne> createState() => _BookmarkCategoryOneState();
}

class _BookmarkCategoryOneState extends State<BookmarkCategoryOne> {
  @override
  Widget build(BuildContext context) {
    return  PrimaryPages(
      menutogglee: widget.menutoggle, 
      header: Pageheaders(
        settingstogglee: widget.settingstogglee, 
        title: 'Category 1', 
        child: Headertext(
          words: 'Purchased Goods and Services',
          backgroundcolor: Apptheme.header,
        )
      ),
      childofmainpage: ListView(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Widgets1(
              maxheight: 500,
              child: Column(
                children: [
                  Labels(title: 'Attributes included', color: Apptheme.textclrdark)
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Widgets1(
              maxheight: 500,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Labels(title: 'Emissions by activities', color: Apptheme.textclrdark),

                  ],
                )
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Widgets1(
              maxheight: 500,
              child: Column(
                children: [
                  Labels(title: 'Declarations', color: Apptheme.textclrdark)
                ],
              )
            ),
          ),

        ],
      ),
    );
  }
}