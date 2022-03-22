
import 'package:thinking_board/thinking_board.dart';

void main() {
  var game = GameState.newGame();
  game.onPlayerMove(
      ChessMove(start: Position.E2, end: Position.E4).toPlayerMove());
  print('player to move after E2 to E4 move: ${game.playerToMoveNext}');
}
