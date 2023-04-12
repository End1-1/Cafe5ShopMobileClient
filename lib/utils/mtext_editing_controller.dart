import 'package:flutter/cupertino.dart';

class MTextEditingController extends TextEditingController {
  String previousValue = '';


  @override
  void dispose() {
    removeListener(() { });
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (previousValue != text) {
      previousValue = text;
      super.notifyListeners();
    }
  }
}