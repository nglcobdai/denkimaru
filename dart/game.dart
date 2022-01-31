import 'dart:html';
import 'dart:async';
import 'player.dart';
import 'objects.dart';
import 'item.dart';
import 'background.dart';

class Game {
  static bool isExecGame = false;
  static const int screenX = 1280;
  static const int screenY = 720;
  static const int playerSize = 54;
  static const int minGrouondSize = playerSize + 1;
  static const int maxSlideSpeed = 5;
  CanvasRenderingContext2D? _back;

  int _slideSpeed = 1;

  /// Objects
  late List<Player> denkimarus;
  late Objects objects;
  // late Item item;
  late Background background;

  /// Player
  static late List<int> keyMap;
  late int numPlayer;

  Game([_slideSpeed = 1]) {
    CanvasElement? elem = querySelector("#can") as CanvasElement;
    _back = elem.context2D;
    background =
        Background(_back, screenX, screenY, minGrouondSize, _slideSpeed);
    denkimarus = [];
    objects = Objects(_back, screenX, screenY, background, _slideSpeed);
    // item = Item();

    numPlayer = 1;
    keyMap = [KeyCode.W, KeyCode.A, KeyCode.D];
    ElementList keyCnf = querySelectorAll('.key-config');
    int cnt = 0;
    for (Element player in keyCnf) {
      cnt++;
      player.onKeyDown.listen((KeyboardEvent e) {
        // window.console.dir(player.dataset[0]);
        window.console.dir(player.dataset['id']);
        if (KeyCode.A <= e.keyCode && e.keyCode <= KeyCode.Z) {
          player.innerHtml = e.key?.toUpperCase();
          keyMap[int.parse(player.dataset['id']!)] = e.keyCode;
        } else if (e.keyCode == KeyCode.UP) {
          player.innerHtml = "↑";
          keyMap[int.parse(player.dataset['id']!)] = e.keyCode;
        } else if (e.keyCode == KeyCode.LEFT) {
          player.innerHtml = "←";
          keyMap[int.parse(player.dataset['id']!)] = e.keyCode;
        } else if (e.keyCode == KeyCode.RIGHT) {
          player.innerHtml = "→";
          keyMap[int.parse(player.dataset['id']!)] = e.keyCode;
        }
      });
    }

    querySelector("#btAddPlayer")?.onMouseDown.listen((MouseEvent e) {
      querySelector("#player2")?.style.display = 'inline-block';
      querySelector("#btAddPlayer")?.style.display = 'none';
      numPlayer++;
      keyMap
        ..add(KeyCode.W)
        ..add(KeyCode.A)
        ..add(KeyCode.D);
    });
  }
  void inGame() {
    isExecGame = true;

    for (int i = 0; i < numPlayer; i++) {
      denkimarus.add(Player(
          _back,
          screenX,
          screenY,
          playerSize,
          background,
          _slideSpeed,
          keyMap[0 + 3 * i],
          keyMap[1 + 3 * i],
          keyMap[2 + 3 * i]));
    }

    // screenInit();
    Duration d = Duration(milliseconds: 1);
    int dSpeed = 0;
    Timer.periodic(d, (timer) {
      background.move();
      objects();
      for (Player denkimaru in denkimarus) {
        denkimaru.move();
        if (denkimaru.isGameOver(objects) != state.eLiving) {
          switch (denkimaru.isGameOver(objects)) {
            case state.eHitEnemy:
              window.console.log('Game over! Because denkimaru hit the enemy.');
              break;
            case state.eCrushedWall:
              window.console
                  .log('Game over! Because denkimaru is crushed by the wall.');
              break;
            default:
              window.console.log('Game over!');
              break;
          }
          denkimarus.remove(denkimaru);
          if (denkimarus.length == 0) {
            timer.cancel();
            execGameOver();
          }
          window.console.log('Score : ${denkimaru.score}');
        }
      }
      //background.move();
      screenDraw();
      screenScore();
      for (Player denkimaru in denkimarus) {
        denkimaru.score++;
      }
      //print([dSpeed, _slideSpeed]);
      if (dSpeed > 1000 && _slideSpeed <= maxSlideSpeed) {
        _slideSpeed++;
        for (Player denkimaru in denkimarus) {
          denkimaru.slideSpeed = _slideSpeed;
        }
        background.scrollSpeed = _slideSpeed;
        objects.updateSpeed(_slideSpeed);
        dSpeed = 0;
      }
      dSpeed++;
    });
  }

  void screenInit() {
    _back?.setFillColorRgb(255, 255, 255);
  }

  void screenDraw() {
    background.draw();
    for (Player denkimaru in denkimarus) {
      denkimaru.draw();
    }
    objects.draw();
  }

  void screenScore() {
    int scores = 0;
    for (Player denkimaru in denkimarus) {
      scores += denkimaru.score;
    }
    querySelector('#score')?.text = scores.toString().padLeft(8, "0");
  }

  void execGameOver() {
    querySelector('#start')!.style.display = '';
    querySelector('.gameover')!.style.display = '';
    isExecGame = false;
  }

  void init() {
    _slideSpeed = 1;
    background =
        Background(_back, screenX, screenY, minGrouondSize, _slideSpeed);
    objects = Objects(_back, screenX, screenY, background, _slideSpeed);
    // item = Item();
    denkimarus = [];
    for (int i = 0; i < numPlayer; i++) {
      denkimarus.add(Player(
          _back,
          screenX,
          screenY,
          playerSize,
          background,
          _slideSpeed,
          keyMap[0 + 3 * i],
          keyMap[1 + 3 * i],
          keyMap[2 + 3 * i]));
    }
  }
}
