import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/welcomelogo.dart';
import 'package:test_app/app_logic/river_controls.dart';
import 'package:test_app/app_logic/riverpod_account.dart';
import 'package:test_app/sub_navigator.dart';


class Loginpage extends ConsumerStatefulWidget {
  const Loginpage({super.key});

  @override
  ConsumerState<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends ConsumerState<Loginpage> {
  final TextEditingController _profileNameCtrl = TextEditingController();
  bool showLogin = true;

@override
void dispose() {
  _profileNameCtrl.dispose();
  super.dispose();
}



  @override
  Widget build(BuildContext context) {

    final dynamicfield = showLogin ? const LoginField() : const SignUpField();
    final factsfield = RandomFactsWidget();

    return Scaffold(
      backgroundColor: Apptheme.backgroundlight,
      body: LayoutBuilder(builder: (context, constraints) {

        return Stack(
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
                      child: Image.asset('assets/images/home_page_background.png'),
                    ),
                  ),
                ),
              ),
            ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Container(
                    width: 500,
                    color: Apptheme.transparentcheat,
                    child: ListView(
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
                        ),

                        SizedBox(
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Bigfocusedtext(title: 'ECO-pi'),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 330,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: dynamicfield,
                          ),
                        ),

                        Center(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                showLogin = !showLogin;
                              });
                            },
                            child: Text(
                              showLogin ? "Don't have an account? Sign Up" : "Already have an account? Log In",
                              style: TextStyle(
                                color: Apptheme.textclrdark,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 80),
                    child: factsfield
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}






//--------------LIST OF PROJECTS------------------------
class ProjectsPanel extends ConsumerStatefulWidget {
  const ProjectsPanel({super.key});

  @override
  ConsumerState<ProjectsPanel> createState() => _ProjectsPanelState();
}

class _ProjectsPanelState extends ConsumerState<ProjectsPanel> {
  final TextEditingController _profileNameCtrl = TextEditingController();

  @override
  void dispose() {
    _profileNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Apptheme.transparentcheat,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Apptheme.widgetclrdark,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
        child: productsAsync.when(
          data: (products) {
            return ListView(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Titletext(
                      title: 'Your Projects',
                      color: Apptheme.textclrdark,
                    ),
                  ),
                ),

                // ---------- PROJECT LIST ----------
                ...products.map((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          RootScaffold.of(context)
                              ?.goToHomePageWithArgs(product.name);
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Apptheme.widgettertiaryclr,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Labels(
                                    title: product.name,
                                    color: Apptheme.textclrdark,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Apptheme.iconsdark,
                                onPressed: () {
                                  _confirmDelete(context, product.name);
                                },
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 40),

                // ---------- CREATE PROJECT ----------
                _buildCreateSection(context),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  // ---------------- HELPERS ----------------

  Widget _buildCreateSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Labels(
            title: "Create Project",
            color: Apptheme.textclrdark,
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: 600,
            child: TextField(
              controller: _profileNameCtrl,
              decoration: InputDecoration(
                hintText: "Enter profile name...",
                hintStyle: TextStyle(
                  color: Apptheme.texthintclrlight,
                ),
                filled: true,
                fillColor: Apptheme.transparentcheat,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: Apptheme.widgetclrlight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Apptheme.widgetclrlight,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Apptheme.widgetclrlight,
                  ),
                ),
              ),
              style: TextStyle(color: Apptheme.textclrdark),
            ),
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: 120,
            height: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Apptheme.widgetclrlight,
                foregroundColor: Apptheme.widgetclrdark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () async {
                final name = _profileNameCtrl.text.trim();
                if (name.isEmpty) return;

                final username =
                    await secureStorage.read(key: "username");

                if (username == null || username.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please log in first")),
                  );
                  return;
                }

                final req = ProfileSaveRequest(
                  profileName: name,
                  description: "Mock description",
                  data: {"sample": "test"},
                  username: username,
                );

                await ref.read(saveProfileProvider(req).future);

                _profileNameCtrl.clear();
                ref.invalidate(productsProvider);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Saved profile: $name")),
                );
              },
              child: const Text("Create"),
            ),
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String productName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Delete $productName?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(deleteProfileProvider.notifier)
                    .delete(productName, ref);

                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}

//------------------HELPERS----------------------------------------------------------
final signUpParamsProvider = StateProvider<SignUpParameters?>((ref) => null);

final loginParamsProvider = StateProvider<LoginParameters?>((ref) => null);

//------------------LOG IN FIELD----------------------------------------------------------
class LoginField extends ConsumerStatefulWidget {
  const LoginField({super.key});

  @override
  ConsumerState<LoginField> createState() => _LoginFieldState();
}

class _LoginFieldState extends ConsumerState<LoginField> {
  final usernameController=TextEditingController();
  final passwordController=TextEditingController();



  @override
  Widget build(BuildContext context) {

  final params = ref.watch(loginParamsProvider);

  final loginState = params == null
      ? null
      : ref.watch(logInProvider(params));



    return 
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Apptheme.backgroundlight,
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
                        color: Apptheme.backgroundlight,
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
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
                        width: parentWidth * 0.7, 
                        height: 50, 
                        child: SizedBox(
                          width: parentWidth * 0.7,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Apptheme.tertiarysecondaryclr,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(8),
                            ),
                            onPressed: () {
                              ref.read(loginParamsProvider.notifier).state = LoginParameters(
                                profileName: usernameController.text,
                                password: passwordController.text,
                              );
                              RootScaffold.of(context)?.goToWelcomePage();
                            },

                            child: (loginState?.isLoading ?? false)
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Log In",
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

                      ),
                    );
                  },
                ),
              ),
      
            
            
            ]
          ),
        ),
      ),
    );

  }
}

//------------------SIGN UP FIELD----------------------------------------------------------
class SignUpField extends ConsumerStatefulWidget {
  const SignUpField({super.key});

  @override
  ConsumerState<SignUpField> createState() => _SignUpFieldState();
}

class _SignUpFieldState extends ConsumerState<SignUpField> {
  final usernameController=TextEditingController();
  final passwordController=TextEditingController();



  @override
  Widget build(BuildContext context) {

  final params = ref.watch(signUpParamsProvider);

  final signUpState = params == null
      ? null
      : ref.watch(signUpProvider(params));



    return 
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Apptheme.backgroundlight,
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
                        color: Apptheme.backgroundlight,
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
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
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
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
                            ),
                          )
                      );
                    }
                  ),
                ),
              ),

              if (signUpState != null)
                signUpState.when(
                  data: (result) => Text(
                    "Sign up success! Saved profile: $result",
                    style: TextStyle(color: Colors.green),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, _) => Text(
                    "Error: $err",
                    style: TextStyle(color: Colors.red),
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
                        width: parentWidth * 0.7, 
                        height: 50, 
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Apptheme.tertiarysecondaryclr,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(8),
                          ),
                          onPressed: () {
                            ref.read(signUpParamsProvider.notifier).state = SignUpParameters(
                              profileName: usernameController.text,
                              password: passwordController.text,
                            );
                          },
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Sign Up",
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
      ),
    );

  }
}

//------------------RANDOM FACTS PAGE----------------------------------------------
class RandomFactsWidget extends StatefulWidget {
  final Duration interval;
  final double minHeight;

  const RandomFactsWidget({
    super.key,
    this.interval = const Duration(seconds: 4),
    this.minHeight = 120,
  });

  @override
  State<RandomFactsWidget> createState() => _RandomFactsWidgetState();
}

class _RandomFactsWidgetState extends State<RandomFactsWidget> {
  late Timer _timer;
  int _currentIndex = 0;
  final _rng = Random();

  final List<String> ecoFacts = [
    "Recycling aluminum saves up to 95% of the energy needed to make new aluminum.",
    "A single tree can absorb up to 22kg of CO₂ per year.",
    "Glass can be recycled endlessly without losing quality.",
    "Food waste in landfills produces methane, a gas 25x stronger than CO₂.",
    "LED bulbs use up to 75% less energy than traditional bulbs.",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(widget.interval, (_) {
      if (!mounted || ecoFacts.isEmpty) return;

      setState(() {
        int next;
        do {
          next = _rng.nextInt(ecoFacts.length);
        } while (next == _currentIndex && ecoFacts.length > 1);

        _currentIndex = next;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return Container(
          constraints: BoxConstraints(
            minHeight: widget.minHeight,
          ),
          decoration: BoxDecoration(
            color: Apptheme.transparentcheat,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Apptheme.widgetclrdark,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Titletext(
                title: "Did You Know?",
                color: Apptheme.textclrdark,
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: width,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  child: Container(
                    height: 300,
                    key: ValueKey(_currentIndex),
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: width * 0.95,
                        ),
                        child: Labels(
                          title: ecoFacts.isEmpty
                              ? "??"
                              : ecoFacts[_currentIndex],
                          color: Apptheme.textclrdark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
