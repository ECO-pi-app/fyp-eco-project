import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebugPage extends ConsumerWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
      Text(
        'Even though the supplier-specific and hybrid methods are more specific to the individual supplier than the average-data and spend-based methods, they may not produce results that are a more accurate reflection of the product\’s contribution to the reporting company\’s scope 3 emissions. In fact, data collected from a supplier may actually be less accurate than industry-average data for a particular product. Accuracy derives from the granularity of the emissions data, the reliability of the supplier\’s data sources, and which, if any, allocation techniques were used. The need to allocate the supplier’s emissions to the specific products it sells to the company can add a considerable degree of uncertainty, depending on the allocation methods used (for more information on allocation, see chapter 8 of the Scope 3 Standard)')
      ],
    );
  }
}
