import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/riverpod.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaOptionsAsync = ref.watch(metaOptionsProvider);
    final test = ref.watch(countriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Test Materials Provider')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ElevatedButton(
              onPressed: () {
                // This refreshes the FutureProvider
                ref.refresh(metaOptionsProvider);
              },
              child: const Text('Refresh Data'),
            ),
            const SizedBox(height: 20),
            Text('Raw FutureProvider: $metaOptionsAsync'),
            const SizedBox(height: 20),
            const Text('Test items:'),
            ...test.map((item) => Text(item)).toList(),


            
          ],
        ),
      ),
    );
  }
}
