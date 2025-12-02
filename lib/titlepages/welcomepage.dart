import 'package:flutter/material.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/loginfield.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/signin_field.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/welcomelogo.dart';
import 'package:test_app/sub_navigator.dart';

class Welcomepage extends StatefulWidget {
  const Welcomepage({super.key});

  @override
  State<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends State<Welcomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.drawerbackground,
      body: LayoutBuilder( builder: (BuildContext context, BoxConstraints constraints) {
        double parentheight = constraints.maxHeight;
        double parentwidth = constraints.maxWidth;

        return 
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Welcomepagelogo(
                        whathappens: null,
                        choosecolor: Apptheme.error,
                        pad: 0,
                      ),
                    ),
                  )
                ],
              ),
            ),

            SizedBox(
              width: parentwidth/2,
              child: ListView(
                children: [

              
                  SizedBox(
                    child: 
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 100),
                        child: Bigfocusedtext(title: 'ECO-pi',),
                      ),
                    ),
                  ),
              
                  SizedBox(
                    height: 330,
                    width: 150,
                    child: AspectRatio(
                      aspectRatio: 16/9,
                      child: SigninField())),
                  
                  Container(
                    color: Apptheme.transparentcheat,
                    height: 50,
                    child: Center(
                      child: IconButton(
                        onPressed: () {RootScaffold.of(context)?.goToHomePage();
                        },
                        icon: const Icon(Icons.alarm),
                        color: Apptheme.iconslight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          ],
        );
      },
      ),
    );
  }
}
