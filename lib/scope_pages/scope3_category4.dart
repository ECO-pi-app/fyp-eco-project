import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/headers.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';

class BookmarkCategoryFour extends StatefulWidget {

  const BookmarkCategoryFour({super.key,
  });

  @override
  State<BookmarkCategoryFour> createState() => _BookmarkCategoryFourState();
}

class _BookmarkCategoryFourState extends State<BookmarkCategoryFour> {
  @override
  Widget build(BuildContext context) {
    return  PrimaryPages(
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