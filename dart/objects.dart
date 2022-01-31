import 'dart:math';
import 'dart:html';
import 'background.dart';
import 'item.dart';
import 'rubber.dart';
import 'water.dart';

enum objectsId { water, rubber, battery }

class ObjectMotion {
// 画面サイズ
  static int? screenWidth;
  static int? screenHeight;

  /// 増加量
  static int? slideSpeed;

  /// 座標とサイズ
  double _x;
  double _y;
  int _imSize;

  ObjectMotion(this._imSize, [this._x = 0, this._y = 0]) {
    _x = ObjectMotion.screenWidth!.toDouble();
    _y = (ObjectMotion.screenHeight! - imHeight).toDouble();
  }

  // Setter
  set x(double __x) => _x = __x;
  set y(double __y) => _y = __y;

  // Getter
  double get x => _x;
  double get y => _y;
  int get imWidth => _imSize;
  int get imHeight => _imSize;
  Rectangle<double> get bBox => Rectangle(x, y, imWidth.toDouble(),
      imHeight.toDouble()); // [左上x座標, 左上y座標, width, height]
  ImageElement get ie => querySelector('#water') as ImageElement; // override必須

  void update(List<int> ground, double groundOffset) {
    x -= (ObjectMotion.slideSpeed!);

    int leftX = (x - groundOffset) ~/ (54 + 1);
    int rightX = (x - groundOffset + imWidth) ~/ (54 + 1);

    y = x < 0
        ? y
        : x > ObjectMotion.screenWidth!
            ? 0
            : min((ground[leftX] - imWidth).toDouble(),
                (ground[rightX] - imWidth).toDouble());
  }

  bool isOutCanvas() => (0 >= (x + imWidth));

  bool isHit(List playerCorners) {
    // プレイヤ四隅の座標のうち、1つでもオブジェクト領域内に含まれているならヒット
    for (Point point in playerCorners) {
      if (this.bBox.containsPoint(point)) {
        return true;
      }
      continue;
    }
    return false;
  }

  bool isDead(double playerBottom) => false;

  int updateScore(int score) => score;
}

class Objects {
  static var random = Random();
  List<ObjectMotion> objects = [];
  CanvasRenderingContext2D? cont;

  Background bg;

  Objects(this.cont, screenWidth, screenHeight, this.bg, slideSpeed) {
    ObjectMotion.screenWidth = screenWidth;
    ObjectMotion.screenHeight = screenHeight;
    ObjectMotion.slideSpeed = slideSpeed;
  }

  void call() {
    _createObject();
    _updateMotion();
    _removeObject();
  }

  void draw() {
    for (ObjectMotion object in objects) {
      cont!.drawImageScaled(
          object.ie, object.x, object.y, object.imWidth, object.imHeight);
    }
  }

  void _createObject() {
    if ((objects.length > 0) &&
        (ObjectMotion.screenWidth! - 80) < objects.last.x) {
      return;
    }
    // FIXME
    int temp = random.nextInt(1000); // durationに合わせる
    if (1 < temp) {
      return;
    }

    int key = random.nextInt(3);
    if (objectsId.water.index == key) {
      objects.add(Water());
    } else if (objectsId.rubber.index == key) {
      objects.add(Rubber());
    } else if (objectsId.battery.index == key) {
      objects.add(Item());
    }
  }

  void _updateMotion() {
    for (ObjectMotion object in objects) {
      object.update(bg.ground, bg.scrollOffset);
    }
  }

  // 条件画面外で削除
  void _removeObject() => objects.removeWhere((object) => object.isOutCanvas());

  // 条件撃破で削除
  void removeObject(object) => objects.remove(object);

  void updateSpeed(int speed){
    ObjectMotion.slideSpeed = speed;
  }
}
