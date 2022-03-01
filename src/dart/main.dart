/* main.dart
 *
 * Author  : 
 * Update  : 
 * Compile : dart compile js ./dart/main.dart -o ./js/out.js
 */
import 'game.dart';
import 'dart:html';

void main() {
  Game denkimaruGame = Game();
  window.onKeyDown.listen((KeyboardEvent e) {
    if (e.keyCode == KeyCode.SPACE) {
      denkimaruGame.init(); // new game
      if (Game.isExecGame) {
        return;
      }
      querySelector('#start')!.style.display = 'none';
      querySelector('.gameover')!.style.display = 'none';
      querySelector('#player-select')!.style.display = 'none';
      // Game denkimaruGame = Game();
      denkimaruGame.inGame();
      denkimaruGame.init(); // new game
    }
  });
}
