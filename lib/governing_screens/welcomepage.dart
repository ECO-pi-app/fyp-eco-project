import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/welcomelogo.dart';
import 'package:test_app/sub_navigator.dart';
import 'package:test_app/riverpod.dart';

// Product model is the same as above

class Welcomepage extends ConsumerStatefulWidget {
  const Welcomepage({super.key});

  @override
  ConsumerState<Welcomepage> createState() => _WelcomepageState();
}

class _WelcomepageState extends ConsumerState<Welcomepage> {
  final TextEditingController _profileNameCtrl = TextEditingController();
  final Widget dynamicfield = LoginField();



@override
void dispose() {
  _profileNameCtrl.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: Apptheme.drawerbackground,
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
                              choosecolor: Apptheme.transparentcheat,
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

                        Container(
                          color: Apptheme.transparentcheat,
                          height: 50,
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                RootScaffold.of(context)?.goToHomePage();
                              },
                              icon: const Icon(Icons.alarm),
                              color: Apptheme.iconslight,
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
                    child: Container(
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

                                // Dynamic product list
                                ...products.map((product) {
                                  return Padding(
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
                                        child: Row(
                                          children: [
                                            // Product name
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 20),
                                                child: Labels(
                                                  title: product.name,
                                                  color: Apptheme.textclrlight,
                                                ),
                                              ),
                                            ),

                                            // Trash button
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              color: Apptheme.iconslight,
  
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: Text("Delete ${product.name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                ref.read(deleteProfileProvider.notifier).delete(product.name);
                Navigator.of(context).pop(); // close dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  },
                                            ),

                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),



                                const SizedBox(height: 40),

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Titletext(
                                        title: "Create Profile",
                                        color: Apptheme.textclrdark,
                                      ),

                                      const SizedBox(height: 10),

                                      SizedBox(
                                        width: 600,
                                        child: TextField(
                                          controller: _profileNameCtrl,
                                          decoration: InputDecoration(
                                            hintText: "Enter profile name...",
                                            filled: true,
                                            fillColor: Apptheme.drawer,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          style: TextStyle(color: Apptheme.textclrlight),
                                        ),
                                      ),

                                      const SizedBox(height: 15),

                                      SizedBox(
                                        width: 200,
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final name = _profileNameCtrl.text.trim();
                                            if (name.isEmpty) return;

                                            final req = ProfileSaveRequest(
                                              profileName: name,
                                              description: "Mock description",
                                              data: {"sample": "test"},   // mock data
                                              username: "demoUser",
                                            );

                                            ref.read(saveProfileProvider(req));
                                          },
                                          child: const Text("Save Profile"),
                                        ),
                                      ),

                                      const SizedBox(height: 15),

                                      SizedBox(
                                        width: 200,
                                        height: 45,
                                        child: ElevatedButton(
                                          onPressed:  () {
                                            ref.read(deleteProfileProvider.notifier).delete("Test");
                                          },
                                          child: const Text("Delete Profile"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Center(child: Text('Error: $err')),
                        ),
                      ),
                    ),
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
      : ref.watch(logInAuth(params));



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

              if (loginState != null)
                loginState.when(
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
                            backgroundColor: Apptheme.header,
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
                          child: FittedBox(
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
      : ref.watch(signUpAuth(params));



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
                            backgroundColor: Apptheme.header,
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
