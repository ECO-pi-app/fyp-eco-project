import 'package:flutter/material.dart';
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
        // ignore: unused_local_variable
        double parentheight = constraints.maxHeight;
        // ignore: unused_local_variable
        double parentwidth = constraints.maxWidth;

        return 
        Stack(
          children: [

            Positioned(
              left: 0,
              child: ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 800,
                      child: Image.asset('assets/images/home_page_background.png',
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Row(
              children: [

                Container(
                  width: 500,
                  color: Apptheme.transparentcheat,
                  child: 
                  ListView(
                    children: [
                                
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Welcomepagelogo(
                            whathappens: null,
                            choosecolor: Apptheme.transparentcheat,
                            pad: 0,
                          ),
                        ),
                      ),
                  
                      SizedBox(
                        child: 
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Bigfocusedtext(title: 'ECO-pi',),
                          ),
                        ),
                      ),
                  
                      SizedBox(
                        height: 330,
                        child: AspectRatio(
                          aspectRatio: 16/9,
                          child: SigninField())
                      ),
                      
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
              
                Expanded(
                  child: 
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 80),
                    child: 
                    Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Apptheme.transparentcheat,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Apptheme.widgetborderdark,
                          width: 2,
                        ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: 
                            Padding(
                              padding: const EdgeInsets.only(bottom: 50),
                              child: Titletext(title: 'Your Projects', color: Apptheme.textclrlight),
                            )),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 600,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Apptheme.drawer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Labels(
                                    title: 'Product 1', 
                                    color: Apptheme.textclrlight
                                  )
                                ),
                              ),
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 600,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Apptheme.drawer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Labels(
                                    title: 'Product 2', 
                                    color: Apptheme.textclrlight
                                  )
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 600,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Apptheme.drawer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Labels(
                                    title: 'Product 3', 
                                    color: Apptheme.textclrlight
                                  )
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 600,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Apptheme.drawer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Labels(
                                    title: 'Product 4', 
                                    color: Apptheme.textclrlight
                                  )
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 600,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Apptheme.drawer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Labels(
                                    title: 'Product 5', 
                                    color: Apptheme.textclrlight
                                  )
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 600,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Apptheme.drawer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Labels(
                                    title: 'Product 6', 
                                    color: Apptheme.textclrlight
                                  )
                                ),
                              ),
                            ),
                          ),
                        
                        
                        ],
                      ),
                    ),
                  ),
                )
                ),
              
              ],
            ),
          
          ],
        );
      },
      ),
    );
  }
}
