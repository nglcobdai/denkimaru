import 'dart:html';
import 'dart:async';
import 'dart:math';

class Background {
  late List<int> _ground;
  late double _scrollOffset; // [px]

  static late int _minGrouondSize;
  static late int _groundNum;
  static const int _flat = 500; // [px]
  int _scrollSpeed; // [px/us]
  late final double _groundUpdatePeriod; // [1/us]
  int _groundUpdateCnt;

  CanvasRenderingContext2D? cont;
  final int _screenWidth; // 画面サイズ(横)
  final int _screenHeight; // 画面サイズ(縦)

  int _skipBackDraw;

  /// constructor
  Background(this.cont, this._screenWidth, this._screenHeight, minGrouondSize,
      this._scrollSpeed,
      [this._groundUpdateCnt = 0, this._skipBackDraw = 0]) {
    Background._minGrouondSize = minGrouondSize;
    Background._groundNum = (_screenWidth ~/ _minGrouondSize + 16);

    this._groundUpdatePeriod = _minGrouondSize / _scrollSpeed;
    this._ground = List.generate(_groundNum, (i) => _flat);
    // this._ground = [
    //   _flat,
    //   _flat,
    //   _flat - 55,
    //   _flat,
    //   _flat - 55,
    //   _flat,
    //   _flat,
    //   _flat - 55,
    //   _flat,
    //   _flat - 55,
    //   _flat - 55,
    //   _flat,
    //   _flat - 55,
    //   _flat,
    //   _flat
    // ];
    this._scrollOffset = 0; //_scrollSpeed.toDouble();
    back0 = back(0);
    back1 = back(300);
    back2 = back(600);
  }

  /// getter
  List<int> get ground => _ground;
  double get scrollOffset => _scrollOffset;

  set scrollSpeed(int speed) {
    this._scrollSpeed = speed;
    // this._groundUpdatePeriod = _minGrouondSize / speed;
  }

  move() {
    _scrollOffset -= _scrollSpeed;
    _groundUpdateCnt += _scrollSpeed;
    // print(_scrollOffset);
    // if (_groundUpdateCnt >= _groundUpdatePeriod) {
    if (_scrollOffset <= -_minGrouondSize) {
      _groundUpdateCnt = 0;
      _scrollOffset += _minGrouondSize; //_scrollSpeed.toDouble();
      Random rand = Random();
      _ground.removeAt(0);
      // _ground.add(550 - 50 * rand.nextInt(4) * (rand.nextInt(2)));
      int newGround = rand.nextInt(2) == 0
          ? _ground.last + 54 * rand.nextInt(2) * ((rand.nextInt(2)) * 2 - 1)
          : _ground.last;
      newGround = min(_flat, max(300, newGround));
      _ground.add(newGround);
      // print(_ground);
    }
  }

  draw() {
    cont?.setFillColorRgb(225, 245, 254);
    cont?.rect(0, 0, _screenWidth, _screenHeight);
    cont?.fill();
    drawBackground();
    drawGround();
  }

  drawGround() {
    cont?.setFillColorRgb(62, 39, 35);
    cont?.beginPath();
    cont?.lineTo(_screenWidth, _screenHeight);
    cont?.lineTo(0, _screenHeight);
    for (int x = 0; x < _ground.length; x++) {
      // window.console.log(x * 50 - background.firstBlockLength);
      // _back!.lineTo(
      // x * 50 - 50 + background.firstBlockLength, background.ground[x]);
      // window.console.log(background.scrollOffset);
      cont?.lineTo(x * _minGrouondSize + _scrollOffset, _ground[x]);
      // window.console.log(x * 55 + background.scrollOffset);
      cont?.lineTo((x + 1) * _minGrouondSize + _scrollOffset, _ground[x]);
    }
    cont?.closePath();
    cont?.fill();
  }

  Function back(double a) {
    double repeetFreq = _screenWidth.toDouble();
    double offset = a;
    return (double b) {
      offset += b;
      offset = offset < repeetFreq ? offset : 0;
      // print([sin(0), sin(79.9 / pi / 4)]);
      // print(offset);
      return offset;
    };
  }

  late final Function back0;
  late final Function back1;
  late final Function back2;

  void drawBackground() {
    double offset0 = back0(0.3 * _scrollSpeed);
    double offset1 = back1(0.5 * _scrollSpeed);
    double offset2 = back2(0.7 * _scrollSpeed);
    cont?.setFillColorRgb(27, 94, 32);
    cont?.beginPath();
    cont?.lineTo(_screenWidth, _screenHeight);
    cont?.lineTo(0, _screenHeight);
    for (int x = 0; x < _screenWidth + 51; x += 50) {
      cont?.lineTo(x, 150 + 50 * sin((x + offset0) * 2 / _screenWidth * pi));
    }
    cont?.closePath();
    cont?.fill();
    cont?.setFillColorRgb(56, 142, 60);
    cont?.beginPath();
    cont?.lineTo(_screenWidth, _screenHeight);
    cont?.lineTo(0, _screenHeight);
    for (int x = 0; x < _screenWidth + 51; x += 50) {
      cont?.lineTo(x, 250 + 75 * sin((x + offset1) * 2 / _screenWidth * pi));
    }
    cont?.closePath();
    cont?.fill();
    cont?.setFillColorRgb(76, 175, 80);
    cont?.beginPath();
    cont?.lineTo(_screenWidth, _screenHeight);
    cont?.lineTo(0, _screenHeight);
    for (int x = 0; x < _screenWidth + 51; x += 50) {
      cont?.lineTo(x, 325 + 75 * sin((x + offset2) * 2 / _screenWidth * pi));
    }
    cont?.closePath();
    cont?.fill();
  }
}
