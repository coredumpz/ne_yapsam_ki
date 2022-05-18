import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/pages/wheel_pages/result_book.dart';
import 'package:ne_yapsam_ki/pages/wheel_pages/result_game.dart';
import 'package:ne_yapsam_ki/pages/wheel_pages/result_movie.dart';
import 'package:ne_yapsam_ki/pages/wheel_pages/result_recipe.dart';
import 'package:ne_yapsam_ki/pages/wheel_pages/result_tv.dart';
import 'package:ne_yapsam_ki/utils/wheel_provider.dart';
import 'package:provider/provider.dart';

import 'board_view.dart';
import '../../models/wheel_model.dart';

class LuckWheel extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LuckWheelState();
  }
}

class _LuckWheelState extends State<LuckWheel>
    with SingleTickerProviderStateMixin {
  double _angle = 0;
  double _current = 0;
  late AnimationController _ctrl;
  late Animation _ani;
  final List<Luck> _items = [
    Luck("movie", Colors.accents[0]),
    Luck("tvseries", Colors.accents[2]),
    Luck("book", Colors.accents[4]),
    Luck("game", Colors.accents[8]),
    Luck("food", Colors.accents[10]),
  ];

  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    var _duration = const Duration(milliseconds: 5000);
    _ctrl = AnimationController(vsync: this, duration: _duration);
    _ani = CurvedAnimation(parent: _ctrl, curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.green, Colors.blue.withOpacity(0.2)])),
              child: AnimatedBuilder(
                animation: _ani,
                builder: (context, child) {
                  final _value = _ani.value;
                  final _angle = _value * this._angle;
                  return Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      BoardView(
                          items: _items, current: _current, angle: _angle),
                      _buildGo(),
                      _buildResult(_value),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildGo() {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 72,
          width: 72,
          child: const Text(
            "GO",
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: _animation,
      ),
    );
  }

  _animation() {
    if (!_ctrl.isAnimating) {
      var _random = Random().nextDouble();
      _angle = 20 + Random().nextInt(5) + _random;
      _ctrl.forward(from: 0.0).then((_) {
        _current = (_current + _random);
        _current = _current - _current ~/ 1;
        _ctrl.reset();

        goToResultPage();
      });
    }
  }

  int _calIndex(value) {
    var _base = (2 * pi / _items.length / 2) / (2 * pi);
    //print((((_base + value) % 1) * _items.length).floor());
    return (((_base + value) % 1) * _items.length).floor();
  }

  _buildResult(_value) {
    var _index = _calIndex(_value * _angle + _current);
    String _asset = _items[_index].asset;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(_asset, height: 80, width: 80),
      ),
    );
  }

  goToResultPage() {
    var _index = _calIndex(_ani.value * _angle + _current);
    _ctrl.dispose();
    Provider.of<WheelProvider>(context, listen: false).setWheelIndex = _index;

    Navigator.pop(context);

    int wheelIndex =
        Provider.of<WheelProvider>(context, listen: false).wheelIndex;

    switch (wheelIndex) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const MovieResult()));
        break;
      case 1:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const TVResult()));
        break;
      case 2:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const BookResult()));
        break;
      case 3:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const GameResult()));
        break;
      case 4:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RecipeResult()));
        break;
      default:
    }
  }
}
