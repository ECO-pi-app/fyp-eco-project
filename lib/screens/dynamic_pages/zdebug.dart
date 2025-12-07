import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/design/secondary_elements_(to_design_pages)/testdropdown.dart';
import 'package:test_app/riverpod.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaOptionsAsync = ref.watch(metaOptionsProvider);
    final test = ref.watch(testProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Test Materials Provider')),
      body: Center(
        child: ListView(
          children: [
            Text('Raw FutureProvider: $metaOptionsAsync'),
            const SizedBox(height: 20),
            Text('Test: $test'),
          ],
        ),
      ),
    );
  }
}
