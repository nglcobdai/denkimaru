import 'dart:math';

import 'objects.dart';

class Enemy extends ObjectMotion {
  double _diff;

  Enemy(_imSize, this._diff) : super(_imSize) {}

  @override
  void update(List<int> ground, double groundOffset) {
    x -= (ObjectMotion.slideSpeed! + _diff);

    int leftX = (x - groundOffset) ~/ (54 + 1);
    int rightX = (x - groundOffset + imWidth) ~/ (54 + 1);

    y = x < 0
        ? y
        : x > ObjectMotion.screenWidth!
            ? 0
            : min((ground[leftX] - imHeight).toDouble(),
                (ground[rightX] - imHeight).toDouble());
  }

  // プレイヤの下がオブジェクト上3分の1より下の時、GameOver
  @override
  bool isDead(double playerBottom) => (y + (imHeight / 3) < playerBottom);
}
