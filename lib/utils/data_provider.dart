import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  int _dataSortIndex = 0;

  int get dataSortIndex {
    return _dataSortIndex;
  }

  set setDataSortIndex(int dataSortIndex) {
    _dataSortIndex = dataSortIndex;
    notifyListeners();
  }
}
