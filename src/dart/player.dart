import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'objects.dart';
import 'background.dart';
import 'input.dart';

enum state { eLiving, eHitEnemy, eCrushedWall }

// abstract class Motion {
//   double get x;
//   double get y;
//   // void move(int x, int y);
// }

class Player extends Input {
  /// 座標とサイズ
  double _x; // X座標(左上)
  double _y; // Y座標(左上)
  static late int _width; // 画像サイズ(横)
  static late int _height; // 画像サイズ(縦)

  // 落下用
  bool _isFall; // 落下計算するか
  double _fallSpeed; // 落下速度
  static const double _fallGravity = 1.06; //落下速度係数

  /// キー入力用フラグ
  // @override
  bool isJumpUp; // 2段ジャンプ禁止用
  // @override
  // bool isMoveLeft; // 左キー(A)が入力されているか
  // @override
  // bool isMoveRight; // 右キー(D)が入力されているか

  final int _screenWidth; // 画面サイズ(横)
  final int _screenHeight; // 画面サイズ(縦)

  /// Background関連
  Background bg;
  static late List<int> _ground; // 地面(障害物)高さ
  late double _groundOffset; // 地面の進み具合
  late int _slideSpeed; // 背景速さ

  int _score; // スコア
  bool _isCrushed;

  // 描画関連
  CanvasRenderingContext2D? cont;
  static final ImageElement ie = querySelector("#ima") as ImageElement;

  /// Constructor
  Player(this.cont, this._screenWidth, this._screenHeight, size, this.bg,
      this._slideSpeed,
      [int keyTop = KeyCode.W,
      int keyLeft = KeyCode.A,
      int keyRight = KeyCode.D,
      this._x = 0,
      this._y = 0,
      this._isFall = true,
      this._fallSpeed = _fallGravity,
      this.isJumpUp = false,
      this._score = 0,
      this._isCrushed = false])
      : super(keyTop, keyLeft, keyRight) {
    _width = size; // ie.width ?? 50;
    _height = ie.height ?? 50;
    _ground = bg.ground;
    // _groundOffset = bg.scrollOffset;
    _x = 300;
    _y = (_ground[0] - _height).toDouble();
  }

  /// Getter
  double get x => _x;
  double get y => _y;
  int get score => _score;
  List<Point> get corners => [
        Point(_x, _y),
        Point(_x + _width, _y),
        Point(_x, _y + _height),
        Point(_x + _width, _y + _height)
      ]; // Playerの四隅の座標

  set score(int score) {
    this._score = score;
  }

  set slideSpeed(int speed) {
    this._slideSpeed = speed;
  }

  /// 移動先座標計算関数
  void move() {
    if (isMoveLeft) {
      moveLeft();
    }
    if (isMoveRight) {
      moveRight();
    }
    if (isMoveTop) {
      moveUp(3);
    }

    _x = _nextX(-_slideSpeed.toDouble());
    if (_isFall) {
      _fallSpeed *= _fallGravity;
      _y = _nextY(_fallSpeed);
    }
  }

  /// 左移動関数
  /// [diff] 移動量
  void moveLeft([double diff = 20]) {
    int cntL = 0;
    Duration d = Duration(milliseconds: 25);
    Timer.periodic(d, (timer) {
      if (cntL > diff) {
        // isJump = false;
        timer.cancel();
      }
      _x = _nextX(-0.20 + _slideSpeed / 50);
      cntL++;
    });
  }

  /// 右移動関数
  /// [diff] 移動量
  void moveRight([double diff = 20]) {
    int cntR = 0;
    Duration d = Duration(milliseconds: 25);
    Timer.periodic(d, (timer) {
      if (cntR > diff) {
        // isJump = false;
        timer.cancel();
      }
      _x = _nextX(0.20 + _slideSpeed / 50);
      cntR++;
    });
  }

  /// 跳躍関数(上に飛ぶ間)
  /// [diff] 移動量
  void moveUp([double diff = 1]) {
    isMoveTop = false;
    if (!isJumpUp) {
      // print("neko");
      isJumpUp = true;
      _isFall = false;
      Duration d = Duration(microseconds: (25000 ~/ diff));
      _fallSpeed = pow(_fallGravity, 50).toDouble();
      Timer.periodic(d, (timer) {
        // _y = 550 - diff * 100 * sin(cntU / 100);
        // _y = pow(cntU, 2).toDouble() * 0.15 + 175;
        // if (!_nextY(
        //     pow(cntU, 2).toDouble() * 0.15 + 175 - 600 + _ground[x] - _y)) {
        _fallSpeed /= _fallGravity;
        _y = _nextY(-_fallSpeed);
        if (_fallSpeed < _fallGravity) {
          _isFall = true;
          timer.cancel();
        }
      });
    }
  }

  state isGameOver(Objects objects) {
    if (_isCrushed) {
      return state.eCrushedWall;
    }
    for (ObjectMotion object in objects.objects) {
      if (!object.isHit(this.corners)) {
        continue; // 当たり無し
      }
      if (object.isDead(this.y + _width)) {
        return state.eHitEnemy; // Game over
      } else {
        _score = object.updateScore(score);
        objects.removeObject(object);
        return state.eLiving;
      }
    }
    return state.eLiving;
  }

  // void moveDown() {
  //   _y = nextY(-1);
  // }

  double _nextX([double dx = 0]) {
    //- 地面との当たり判定 ----
    double tmpX = _x + dx;
    int leftX = (tmpX - bg.scrollOffset) ~/ (_width + 1);
    int rightX = (tmpX - bg.scrollOffset + _width) ~/ (_width + 1);

    // 左端が接触(左下のY座標が背景よりも大きい)
    if (_y + _height > _ground[leftX]) {
      // スクロール反映はなし(その場に留まれる)
      // _isFall = false;
      return _x;
    }
    // 右端が接触(右下のY座標が背景よりも大きい)
    if (_y + _height > _ground[rightX]) {
      // スクロール反映(その場に留まれないので左に進む)
      // _isFall = false;
      tmpX = (leftX) * (_width + 1) + bg.scrollOffset;
      if (tmpX < 0) {
        _isCrushed = true;
      }
      return _x;
    }
    // _isFall = true;
    // window.console.log([_x, _y, _isFall]);
    return max(0, min((_screenWidth - _width).toDouble(), _x + dx));
  }

  // bool _nextY([double dy = 0]) {
  double _nextY([double dy = 0]) {
    //- 地面との当たり判定 ----
    double tmpY = _y + dy;
    int leftX = (_x - bg.scrollOffset) ~/ (_width + 1);
    int rightX = (_x - bg.scrollOffset + _width) ~/ (_width + 1);

    // 左下or右下のY座標が背景よりも大きい
    if (tmpY + _height > _ground[leftX] || tmpY + _height > _ground[rightX]) {
      // 画面左で押しつぶされる場合以外は、ちゃんと地面に接地するようにする
      // これがないと、ちょっと(≦1px)浮く場合がある
      // 画面左を例外としたのは、Y座標計算の都合で、ワープする可能性があるため
      if (_ground[rightX] == 0) {
        _y = min((_ground[leftX] - _height).toDouble(),
            (_ground[rightX] - _height).toDouble());
      }
      // _isFall = false;
      _fallSpeed = _fallGravity;
      isJumpUp = false;
      // return false;
      return _y;
    }

    // _y = max(0, tmpY);
    // return true;
    return max(0, tmpY);
  }

  void draw() => cont?.drawImageScaled(ie, _x, _y, _width, _height);

  void updateScore() {
    _score++;
  }
}
