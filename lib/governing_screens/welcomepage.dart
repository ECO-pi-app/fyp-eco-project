import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/app_logic/riverpod_profileswitch.dart';
import 'package:test_app/app_logic/riverpod_states.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/welcomelogo.dart';
import 'package:test_app/app_logic/river_controls.dart';
import 'package:test_app/app_logic/riverpod_account.dart';
import 'package:test_app/sub_navigator.dart';


class Welcomepage extends ConsumerStatefulWidget {
  const Welcomepage({super.key});

  @override
  ConsumerState<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends ConsumerState<Welcomepage> {
  final TextEditingController _profileNameCtrl = TextEditingController();
  bool showLogin = true;


@override
void dispose() {
  _profileNameCtrl.dispose();
  super.dispose();
}



  @override
  Widget build(BuildContext context) {
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
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, left: 20, right: 30),
                                child: SizedBox(
                                  height: 70,
                                  child: Welcomepagelogo(
                                    whathappens: null,
                                    choosecolor: Apptheme.transparentcheat,
                                    pad: 0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  child: Bigfocusedtext(
                                    title: 'ECO-pi',
                                    color: Apptheme.textclrdark,
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),

                        SizedBox(
                          height: 200,
                            child: factsfield,
                          
                        ),

                        SizedBox(
                          child: SelectedProductInfoWidget(),
                        )

                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
                    child: ProjectsPanel()
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




//--------------- PROJECT DESCRIPTION FIELD ----------------
class SelectedProductInfoWidget extends ConsumerStatefulWidget {
  const SelectedProductInfoWidget({super.key});

  @override
  ConsumerState<SelectedProductInfoWidget> createState() =>
      _SelectedProductInfoWidgetState();
}

class _SelectedProductInfoWidgetState
    extends ConsumerState<SelectedProductInfoWidget> {
  late final TextEditingController _controller;
  bool _hydrated = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    // Run AFTER first build to avoid Riverpod modification error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hydrateFromBackend();
    });
  }

  void _hydrateFromBackend() {
    if (_hydrated) return;
    _hydrated = true;

    final productsAsync = ref.read(productsProvider);

    productsAsync.whenData((products) {
      final notifier = ref.read(productDescriptionProvider.notifier);

      debugPrint("[SelectedProductInfoWidget] Hydrating descriptions...");

      for (final product in products) {
        final existing = notifier.getDescription(product.name);

        if (existing == null || existing.isEmpty) {
          notifier.setDescription(product.name, product.description);
          debugPrint(
            "[SelectedProductInfoWidget] Loaded '${product.name}' -> '${product.description}'",
          );
        } else {
          debugPrint(
            "[SelectedProductInfoWidget] Skipped '${product.name}', already has: '$existing'",
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productName = ref.watch(activeProductProvider);
    final descriptionMap = ref.watch(productDescriptionProvider);

    final description = productName != null
        ? descriptionMap[productName] ?? ""
        : "";

    // Keep text field in sync with provider/backend
    if (_controller.text != description) {
      debugPrint(
        "[SelectedProductInfoWidget] Sync controller for '$productName' -> '$description'",
      );

      _controller.text = description;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: Apptheme.widgetclrlighttransparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Apptheme.transparentcheat,
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: productName == null
          ? Labels(
              title: "Select a project to add a description",
              color: Apptheme.textclrdark,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Titletext(
                  title: productName,
                  color: Apptheme.textclrdark,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Enter project description...",
                    filled: true,
                    fillColor: Apptheme.transparentcheat,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  style: TextStyle(
                    color: Apptheme.textclrdark,
                  ),
                  onChanged: (value) {
                    ref
                        .read(productDescriptionProvider.notifier)
                        .setDescription(productName, value);

                    debugPrint(
                      "[SelectedProductInfoWidget] Updated '$productName' -> '$value'",
                    );
                  },
                ),
              ],
            ),
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
  final TextEditingController _profileDescCtrl = TextEditingController();

  bool _createExpanded = false;
  final double defaultpanelheight = 50;
  final double expandedpanelheight = 250;

  @override
  void dispose() {
    _profileNameCtrl.dispose();
    _profileDescCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final username = ref.watch(usernameProvider);

    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: Apptheme.transparentcheat,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Apptheme.transparentcheat,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, top: 20, right: 0),
        child: productsAsync.when(
          data: (products) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Titletext(
                          title: username.when(
                            data: (name) => 'Welcome $name',
                            loading: () => 'Welcome...',
                            error: (_, __) => 'Welcome',
                          ),
                          color: Apptheme.textclrdark,
                        ),
                      ),
                    ),

                    ...products.map((product) {
                      final activeName = ref.watch(activeProductProvider); // current active project

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onDoubleTap: () {
                                    RootScaffold.of(context)?.goToHomePageWithArgs(product.name);
                                  },
                                  child: ChoiceChip(
                                    showCheckmark: false,
                                    selectedColor: Apptheme.widgetsecondaryclr,
                                    backgroundColor: Apptheme.widgettertiaryclr,
                                    selected: activeName == product.name, // compare strings
                                    onSelected: (_) {
                                      ref.read(activeProductProvider.notifier).state = product.name;
                                    },
                                    label: Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 0),
                                            child: Textsinsidewidgetsdrysafe(
                                              words: product.name,
                                              color: Apptheme.textclrdark,
                                              fontsize: 20,
                                              toppadding: 0,
                                              leftpadding: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Apptheme.widgettertiaryclr,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Apptheme.iconsdark,
                                  onPressed: () {
                                    _confirmDelete(context, product.name);
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      );
                    }).toList(),

                    IconButton(
                      icon: const Icon(Icons.alarm), 
                      color: Apptheme.iconsdark,
                      onPressed: () {
                        {RootScaffold.of(context)?.goToLoginPage();}
                      },
                    ),
                  ],
                ),

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

          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Container(
              width: double.infinity,
              height: _createExpanded ? expandedpanelheight : defaultpanelheight,
              decoration: BoxDecoration(
                color: Apptheme.widgettertiaryclr,
                borderRadius: BorderRadius.circular(5),
            
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Apptheme.widgetclrdark,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Labels(
                            title: 'New Project', 
                            color: Apptheme.widgetclrlight,
                            toppadding: 0,
                            leftpadding: 10,
                          ),
                          IconButton(
                            icon: AnimatedRotation(
                              turns: _createExpanded ? 0.5 : 0.0, // down/up
                              duration: const Duration(milliseconds: 250),
                              child: const Icon(Icons.keyboard_arrow_down),
                            ),
                            color: Apptheme.iconslight,
                            onPressed: () {
                              setState(() {
                                _createExpanded = !_createExpanded;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  
                      SizedBox(height: 10),
                    
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: _profileNameCtrl,
                            decoration: InputDecoration(
                              hintText: "Profile name...",
                              hintStyle: TextStyle(
                                color: Apptheme.texthintclrdark,
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
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: TextField(
                            controller: _profileDescCtrl,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Project description...",
                              hintStyle: TextStyle(
                                color: Apptheme.texthintclrdark,
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
                      ),

                      SizedBox(height: 10),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 150,
                            height: 30,
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
                                  description: _profileDescCtrl.text.trim(),
                                  data: {"sample": "test"},
                                  username: username,
                                );

                          
                                await ref.read(saveProfileProvider(req).future);
                          
                                _profileNameCtrl.clear();
                                _profileDescCtrl.clear();
                                ref.invalidate(productsProvider);
                          
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Saved profile: $name")),
                                );
                              },
                              child: const Textsinsidewidgetsdrysafe(
                                words: "Create Project",
                                color: Apptheme.textclrdark,
                                toppadding: 0,
                                leftpadding: -5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                                  ),
                ),
                          ),
          ),
          ),

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
            color: Apptheme.widgetclrlighttransparent,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Apptheme.transparentcheat,
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
                              ? "No facts available"
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
