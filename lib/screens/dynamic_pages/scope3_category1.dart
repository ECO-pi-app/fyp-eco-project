import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/headers.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';

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
            child: Widgets2(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Labels(
                      title: 'Attributes included', 
                      color: Apptheme.textclrdark
                    ),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Widgets2(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Labels(
                        title: 'Emissions by activities', 
                        color: Apptheme.textclrdark,
                      )
                    ),
            
                  ],
                )
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Align(
              alignment: Alignment.topLeft,
              child: Widgets2(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Labels(
                        title: 'Declarations', 
                        color: Apptheme.textclrdark,
                      )
                    ),

                    Textsinsidewidgets(
                      words: 'The following emissions may not include all emissions that could theoretically be counted. The ECO-pi software is a work in progress and may be subject to inaccuracies.', 
                      color: Apptheme.textclrdark,
                      leftpadding: 14,
                    )

                  ],
                )
              ),
            ),
          ),

        ],
      ),
    );
  }
}