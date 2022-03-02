import 'package:flutter/material.dart';

class WheelProvider extends ChangeNotifier {
  int _wheelIndex = 6;
  bool _buttonReveal = false;
  bool _isSortButtonPressed = false;

  bool get isSortButtonPressed {
    return _isSortButtonPressed;
  }

  set setSortButtonPressed(bool sortButtonPressed) {
    _isSortButtonPressed = sortButtonPressed;
    notifyListeners();
  }

  bool get buttonReveal {
    return _buttonReveal;
  }

  set setButtonReveal(bool buttonReveal) {
    _buttonReveal = buttonReveal;
    //notifyListeners();
  }

  int get wheelIndex {
    return _wheelIndex;
  }

  set setWheelIndex(int wheelIndex) {
    _wheelIndex = wheelIndex;
    //notifyListeners();
  }
}
