import 'dart:html';
import 'enemy.dart';

class Rubber extends Enemy {
  // 画像定義
  static const int _imSize = 100;
  static final ImageElement _ie = querySelector('#luffy') as ImageElement;

  static const double _diff = 1; // 移動増加量

  Rubber() : super(_imSize, _diff) {}

  @override
  int get imHeight => 140;

  @override
  ImageElement get ie => _ie;

  // 接触したら GameOver
  @override
  bool isDead(double playerBottom) => true;
}
