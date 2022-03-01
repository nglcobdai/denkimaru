import 'dart:html';
import 'objects.dart';

class Item extends ObjectMotion {
  // 画像定義
  static const int _imSize = 80;
  static final ImageElement _ie = querySelector('#battery') as ImageElement;

  // static const double _diff = 0; // 移動増加量(Itemは動かない想定)
  static const int _diffScore = 100; // スコア増加量

  Item() : super(_imSize) {}

  @override
  ImageElement get ie => _ie;

  @override
  int updateScore(int score) => score + _diffScore;
}
