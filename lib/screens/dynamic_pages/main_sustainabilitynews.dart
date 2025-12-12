import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/pages_layouts.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/widgets.dart';


class DynamicSustainabilityNews extends StatefulWidget {
  final VoidCallback settingstogglee;
  final VoidCallback menutoggle;

  const DynamicSustainabilityNews({super.key, 
  required this.settingstogglee,
  required this.menutoggle,
  });

  @override
  State<DynamicSustainabilityNews> createState() => _DynamicProfileState();

  
}

class _DynamicProfileState extends State<DynamicSustainabilityNews> {

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
    final url = Uri.parse("http://127.0.0.1:8000/news/sustainabilit");
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
      menutogglee: widget.menutoggle, 
      header: null,
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
              color: Apptheme.textclrdark,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                     Expanded(
                       child: Column(
                        children: [
                           // Title
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              article['title'] ?? 'No Title',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                       
                          const SizedBox(height: 6),
                       
                          // Source
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Source: ${article['source'] ?? 'Unknown'}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                       
                          const SizedBox(height: 6),
                       
                          // URL
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              article['url'] ?? 'No URL',
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                       ),
                     ),

                      if (article['image_url'] != null &&
                          article['image_url'].toString().startsWith('http'))
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            article['image_url'],
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text("Image failed to load"),
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