import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/sub_navigator.dart';

class Loginfield extends StatefulWidget {
  const Loginfield({super.key});

  @override
  State<Loginfield> createState() => _LoginfieldState();
}

class _LoginfieldState extends State<Loginfield> {
  final usernameController=TextEditingController();
  final passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {

    return 
    Container(
      height: 350 ,
      decoration: BoxDecoration(
        color: Apptheme.widgetborderlight,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey,
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(0, 0)
          )
        ]
      ),
      child: 
    
      Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
    
            //--SPACER--
            Flexible( flex: 1,
              child:
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    double parentwidth = constraints.maxWidth;
                    double parentheight = constraints.maxHeight;
                
                    return 
                    Container(
                      color: Apptheme.error,
                      height: parentheight/4,
                      width: parentwidth/2,
                      
                    );
                  }
                ),
              ),
            ),
    
            //--USERNAME--
            Flexible( flex: 1,
              child:
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    double parentwidth = constraints.maxWidth;
                    double parentheight = constraints.maxHeight;
                
                    return 
                    Container(
                      decoration: BoxDecoration(
                        color: Apptheme.texthintbgrnd,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      height: parentheight,
                      width: parentwidth/1.2,
                      child: 
                        Align(
                          alignment: AlignmentGeometry.centerLeft,
                          child: TextField(  
                            
                            controller: usernameController,
                            style: TextStyle(
                              fontWeight: FontWeight.w500 ,
                              color: Apptheme.textclrdark,
                            ),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 0),
                            hintText: 'Email (example@gmail.com)',
                            hintStyle: TextStyle(
                              color: Apptheme.texthintclrdark,
                              fontWeight: FontWeight.w100,
                                                                
                            ),
                          ),
                                                                    ),
                        )
                    );
                  }
                ),
              ),
            ),
            
            //--PASSWORD--
            Flexible( flex: 1,
              child:
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints){
                    double parentwidth = constraints.maxWidth;
                    double parentheight = constraints.maxHeight;
                
                    return 
                    Container(
                      decoration: BoxDecoration(
                        color: Apptheme.texthintbgrnd,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      height: parentheight,
                      width: parentwidth/1.2,
                      child: 
                        Align(
                          alignment: AlignmentGeometry.centerLeft,
                          child: TextField(  
                            controller: passwordController,
                            obscureText: true,
                            obscuringCharacter: '*',
                                    
                            style: TextStyle(
                              fontWeight: FontWeight.w500 ,
                              color: Apptheme.textclrdark,
                            ),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 0),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: Apptheme.texthintclrdark,
                              fontWeight: FontWeight.w100,
                                                                
                            ),
                          ),
                          ),
                        )
                    );
                  }
                ),
              ),
            ),
            
            //--Sign In Button--
            Flexible(
              flex: 1, 
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double parentWidth = constraints.maxWidth;
                  double parentHeight = constraints.maxHeight;
    
                  return Center(
                    child: SizedBox(
                      width: parentWidth * 0.5, 
                      height: parentHeight * 0.9, 
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Apptheme.header,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                        ),
                        onPressed: () {
                          if (usernameController.text == "sphere@gmail.com" &&
                              passwordController.text == "sphere1234") {
                            RootScaffold.of(context)?.goToHomePage();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Incorrect username or password. Please try again',
                                  style: TextStyle(color: Apptheme.error),
                                ),
                              ),
                            );
                          }
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Log In/Sign In",
                            style: TextStyle(
                              color: Apptheme.textclrlight,
                              fontWeight: FontWeight.bold,
                              fontSize: parentHeight * 0.3 < 14
                                  ? 14
                                  : parentHeight * 0.3, 
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    
          
          ]
        ),
      ),
    );

  }
}