import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';

class BookmarkCategoryThree extends StatefulWidget {

  const BookmarkCategoryThree({super.key,
  });

  @override
  State<BookmarkCategoryThree> createState() => _BookmarkCategoryThreeState();
}

class _BookmarkCategoryThreeState extends State<BookmarkCategoryThree> {
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
                  Center(child: Labels(title: 'NOT YET IMPLEMENTED', color: Apptheme.textclrdark))
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}