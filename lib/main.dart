import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/sub_navigator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(1200, 800),
    center: false,
    backgroundColor: Apptheme.drawer,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: true,
    minimumSize: Size(548, 250),
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    
    await windowManager.focus();
  });

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootScaffold(), 
    );
  }
}