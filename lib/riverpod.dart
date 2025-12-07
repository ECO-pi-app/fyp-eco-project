import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



final riverpodtest = StateProvider<int>((ref) => 0);


final riverpodtest2 = ChangeNotifierProvider<RiverpodModel>((ref) {
  return RiverpodModel(counter: 0);
});


class RiverpodModel extends ChangeNotifier {
  int counter;

  RiverpodModel({required this.counter});

  void increment() {
    counter++;
    notifyListeners();
  }
}
