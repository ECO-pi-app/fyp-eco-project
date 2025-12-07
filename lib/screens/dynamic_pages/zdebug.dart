import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/apptheme/textlayout.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/app_design.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';


class DebugPage extends StatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutoggle;

  const DebugPage({super.key, 
  required this.settingstogglee,
  required this.menutoggle,
  });

  @override
  State<DebugPage> createState() => _DynamicProfileState();
}

class _DynamicProfileState extends State<DebugPage> {
List<Map<String, dynamic>> articles = [];
bool isLoading = true;
String? errorMessage;

@override
void initState() {
  super.initState();
  fetchNews();
}

Future<void> fetchNews() async {
  try {
    final url = Uri.parse("http://127.0.0.1:8000/");
    final response = await http.get(url);

    if (!mounted) return;  

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (!mounted) return; 

      setState(() {
        articles = List<Map<String, dynamic>>.from(data['articles']);
        isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        errorMessage = "Server returned ${response.statusCode}";
        isLoading = false;
      });
    }
  } catch (e) {
    if (!mounted) return;
    setState(() {
      errorMessage = e.toString();
      isLoading = false;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return PrimaryPages(
      paddingadd: 15,
      menutogglee: widget.menutoggle, 
      header: Pageheaders(
        settingstogglee: widget.settingstogglee, 
        title: 'Testing', 
        child: null
      ),
      childofmainpage: Widgets1(
        maxheight: 250,
        backgroundcolor: Apptheme.widgetsecondaryclr,
        child:  isLoading
        ? const Center(child: CircularProgressIndicator())
        : errorMessage != null
            ? Center(child: 
                Text('There appears to be a network issue. \n Please make sure you are connected to the internet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Apptheme.textclrlight,
                ),
                )
              )
            : ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Apptheme.widgetclrlight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            article['title'] ?? 'No Title',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Source
                          Text(
                            "Source: ${article['source'] ?? 'Unknown'}",
                            style: const TextStyle(fontSize: 12),
                          ),

                          const SizedBox(height: 6),

                          // URL
                          Text(
                            article['url'] ?? 'No URL',
                            style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

      ),
    );
  }
}





class DebugCanvas extends StatefulWidget {
  final VoidCallback menutogglee;
  final Widget? childofmainpage;
  final Color backgroundcolor;

  const DebugCanvas({super.key,
  required this.menutogglee,
  this.childofmainpage,
  required this.backgroundcolor,
  });

  @override
  State<DebugCanvas> createState() => _DebugCanvasState();
}

class _DebugCanvasState extends State<DebugCanvas> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
        child: 
          Stack(
            children: [
              
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30, right: 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Apptheme.transparentcheat,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0), bottomLeft: Radius.circular(0
                    )
                  )
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child:
                    //--Handle--
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0, bottom: 0),
                        child: Container(
                          height: double.infinity,
                          width: 25,
                          
                          decoration: BoxDecoration(
                            color: Apptheme.systemUI,
                            
                            border: Border(
                              right: BorderSide(
                                color: Apptheme.systemUI,
                                width: 2
                              )
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomLeft: Radius.circular(30)
                            )
                          ),
                          child: Center(
                            child: IconButton(
                              onPressed: widget.menutogglee, 
                              icon: Icon(
                                Icons.drag_indicator, 
                                color: Apptheme.iconslight,
                                size: 25,
                              ),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ),
                ),
              ),

              Positioned(
                left: 25,
                right: 4,
                top: 4,
                bottom: 4,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(20),
                  child: Container(
                    color: Apptheme.backgroundlight,
                    child: widget.childofmainpage,
                  ),
                ),
              ),
            
            ]
          ),
      );

      
  }
}