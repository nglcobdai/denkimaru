import 'dart:html';

class Input {
  // static const int _maxDurationMs = 100;
  // static bool _isKeyDown = false;
  // static int _contiCount = 0;
  // static num? _onKeyDownTimestamp;
  // Player player;

  bool isMoveLeft;
  bool isMoveRight;
  bool isMoveTop;

  // bool get isMoveLeft => this._isMoveLeft;
  // bool get isMoveRight => this._isMoveRight;
  // bool get isMoveTop => this._isMoveTop;

  // set isMoveLeft(bool b) {
  //   this._isMoveLeft = b;
  // }

  // set isMoveRight(bool b) {
  //   this._isMoveLeft = b;
  // }

  // set isMoveTop(bool b) {
  //   this._isMoveTop = b;
  // }

  /// Constructor
  // Input(this.player) {}
  int _keyTop;
  int _keyLeft;
  int _keyRight;
  Input(this._keyTop, this._keyLeft, this._keyRight,
      [this.isMoveLeft = false,
      this.isMoveRight = false,
      this.isMoveTop = false]) {
    catchBtnEvent();
    catchKeyEvent();
  }

  /// ボタン入力割り込み定義
  void catchBtnEvent() {
    querySelector("#btL")?.onMouseDown.listen((MouseEvent e) {
      isMoveLeft = true;
    });
    querySelector("#btL")?.onMouseUp.listen((MouseEvent e) {
      isMoveLeft = false;
    });
    querySelector("#btR")?.onMouseDown.listen((MouseEvent e) {
      isMoveRight = true;
    });
    querySelector("#btR")?.onMouseUp.listen((MouseEvent e) {
      isMoveRight = false;
    });
    querySelector("#btU")?.onMouseDown.listen((MouseEvent e) {
      // moveUp(3);
      isMoveTop = true;
    });
  }

  /// キー入力割り込み定義
  void catchKeyEvent() {
    window.onKeyDown.listen((KeyboardEvent e) {
      _controlPlayer(e.keyCode, true);
    });

    window.onKeyUp.listen((KeyboardEvent e) {
      _controlPlayer(e.keyCode, false);
    });
  }

  /// キー種別判別関数
  void _controlPlayer(int keyCode, bool isDown) {
    if (keyCode == KeyCode.SPACE) {
    } else if (keyCode == _keyTop) {
      // denkimaru jump
      // moveUp(3);
      isMoveTop = true;
    } else if (keyCode == _keyLeft) {
      // denkimaru move left
      isMoveLeft = isDown;
    } else if (keyCode == KeyCode.S) {
      // denkimaru squat
    } else if (keyCode == _keyRight) {
      // denkimaru move right
      isMoveRight = isDown;
    }
  }
}
