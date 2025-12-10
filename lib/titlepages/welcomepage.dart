import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/signin_field.dart';
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
        double parentheight = constraints.maxHeight;
        double parentwidth = constraints.maxWidth;

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
                            child: SigninField(),
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
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Labels(
                                            title: product.name,
                                            color: Apptheme.textclrlight,
                                          ),
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
