import 'package:flutter/material.dart';

class WheelProvider extends ChangeNotifier {
  int _wheelIndex = 6;

  int get wheelIndex {
    return _wheelIndex;
  }

  set setWheelIndex(int wheelIndex) {
    _wheelIndex = wheelIndex;
    notifyListeners();
  }
}
