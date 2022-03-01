import 'dart:html';
import 'enemy.dart';

class Water extends Enemy {
  // 画像定義
  static const int _imSize = 120;
  static final ImageElement _ie = querySelector('#water') as ImageElement;

  static const double _diff = 0.1; // 移動増加量
  static const int _diffScore = 500; // スコア増加量

  Water() : super(_imSize, _diff) {}

  @override
  ImageElement get ie => _ie;

  @override
  int updateScore(int score) => score + _diffScore;
}
