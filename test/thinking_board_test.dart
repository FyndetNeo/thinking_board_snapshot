import 'package:test/test.dart';
import 'package:thinking_board/src/models/board_state.dart';
import 'package:thinking_board/src/models/game_state.dart';

import 'package:thinking_board/thinking_board.dart';
import 'test_games/game_1.dart';

void main() {
  group('Human validated chess Games', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('game_1 move by move, ending in Checkmate', () {
      GameState gameState = GameState.newGame();
      for (PlayerMove move in game_1) {
        gameState = gameState.onPlayerMove(move);
      }
      final endedGameObject = gameState.map((value) => null,
          endedGameState: (state) => state.endedGameObject,
          repetitionDrawable: (_) => null);
      expect(gameState is EndedGameState, true,
          reason: "GameState is not an EndedGameState");
      expect(gameState.boardStates.last is EndedState, true,
          reason: "last boardState is not an EndedState");
      expect(endedGameObject is CheckmateEnd, true,
          reason: "endedGameObject is not CheckmateEnd");
      expect(
          (endedGameObject as CheckmateEnd).checkmatedPlayer, PlayerColor.red);
      expect(endedGameObject.winner, PlayerColor.white);
    });
  });
}
