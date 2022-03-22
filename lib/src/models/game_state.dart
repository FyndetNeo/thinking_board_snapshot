// Flutter imports:

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/board_enums.dart';
import 'board_state.dart';
import 'chess_move.dart';
import 'ended_game/agreed_resign_end.dart';
import 'ended_game/draw_end.dart';
import 'ended_game/ended_game.dart';
import 'ended_game/solo_resign_end.dart';
import 'pieces/piece_enum.dart';

part 'game_state.freezed.dart';

@freezed
class GameState with _$GameState {
  const GameState._();

  factory GameState(IList<BoardState> boardStates) = RunningGameState;

  factory GameState.newGame() =>
      RunningGameState(IList([BoardState.defaultStart()]));

  factory GameState.generate(IList<PlayerMove> chessMoves) =>
      RunningGameState(_generateBoardStates(chessMoves));

  factory GameState.endedGameState(
          IList<BoardState> boardStates, EndedGame endedGameObject) =
      EndedGameState;

  @With<DrawGameByRepetition>()
  factory GameState.repetitionDrawable(
      IList<BoardState> boardStates, PlayerColor repeater) = RepetitionDrawable;

  PlayerColor get playerToMoveNext => boardStates.last.playerToMoveNext;

  IList<ProcessedPlayerMove> get playedMoves => boardStates
      .sublist(1)
      .map((boardState) => boardState.map(
          running: (boardState) => boardState.lastChessMove,
          ended: (boardState) => boardState.lastChessMove,
          start: (_) => throw Exception(
              "Can't have StartState on different position than the first")))
      .toIList();

  static IList<BoardState> _generateBoardStates(IList<PlayerMove> chessMoves) {
    final List<BoardState> boardStateList = [BoardState.defaultStart()];
    for (PlayerMove chessMove in chessMoves) {
      final latestBoardState = boardStateList.last;
      latestBoardState.map(
          running: (boardState) =>
              boardStateList.add(boardState.onPlayerMove(chessMove)),
          start: (boardState) =>
              boardStateList.add(boardState.onPlayerMove(chessMove)),
          ended: (boardState) => throw _invalidMove(chessMove));
    }
    return boardStateList.lock;
  }

  bool checkForThreeRepetition(BoardState newBoardState) {
    bool _checkForThreeRepetition(BoardState newBoardState, int copyAmount, int index) {
      final currentBoardState = boardStates[boardStates.length - 1 - index];
      if (newBoardState.currentPosition.boardPosition ==
          currentBoardState.currentPosition.boardPosition) {
        copyAmount++;
        if (copyAmount == 3) {
          return true;
        }
      }
      ProcessedPlayerMove? latestChessMove = currentBoardState.map(
        running: (boardState) => boardState.lastChessMove,
        ended: (boardState) => boardState.lastChessMove,
        start: (boardState) => null,
      );
      if (latestChessMove == null) {
        return false;
      }
      final pieceType = latestChessMove.when(
        chessMove: (chessMove) => chessMove.movedPiece.pieceType,
        missTurn: () => null,
      );
      if (pieceType == PieceType.pawn) {
        return false;
      }
      index++;
      return _checkForThreeRepetition(newBoardState, copyAmount, index);
    }

    return _checkForThreeRepetition(newBoardState, 1, 0);
  }

  static Exception _invalidMove(PlayerMove chessMove) {
    return Exception(
        'Tried to construct invalid GameState with chessMove: ${chessMove.toString()}');
  }

  EndedGameState endGame(EndedGame endType) => boardStates.last.map(
        running: (boardState) => EndedGameState(
            boardStates.removeLast().add(boardState.toEndedState(endType)),
            endType),
        start: (boardState) => EndedGameState(
            boardStates.removeLast().add(boardState.toEndedState(endType)),
            endType),
        ended: (boardState) =>
            EndedGameState(boardStates, boardState.gameEndedObject),
      );

  GameState resign(PlayerColor resignee) => endGame(SoloResignEnd(resignee));

  GameState agreedResign(PlayerColor winner) =>
      endGame(AgreedResignEnd(winner));

  GameState agreedDraw() => endGame(DrawEnd(DrawType.agreement));

  GameState onPlayerMove(PlayerMove playerMove) {
    PlayerColor? drawRepeater = map((value) => null,
        endedGameState: (_) => null,
        repetitionDrawable: (gameState) => gameState.repeater);
    // ignore: prefer_function_declarations_over_variables
    GameState Function(IList<BoardState> boardStates) gameStateWrapper =
        (boardStates) => GameState(boardStates);

    if (drawRepeater != null) {
      gameStateWrapper =
          (boardStates) => RepetitionDrawable(boardStates, drawRepeater);
    }
    final newBoardState = boardStates.last.map(
      running: (boardState) => boardState.onPlayerMove(playerMove),
      start: (boardState) => boardState.onPlayerMove(playerMove),
      ended: (boardState) => throw Exception("Can't move when game is Over"),
    );
    final endedGameState = newBoardState.maybeMap(
      ended: (boardState) => EndedGameState(
          boardStates.add(newBoardState), boardState.gameEndedObject),
      orElse: () => null,
    );
    if (endedGameState != null) {
      return endedGameState;
    }
    if (checkForThreeRepetition(newBoardState)) {
      return newBoardState.map(
        running: (boardState) => RepetitionDrawable(
            boardStates.add(boardState), boardStates.last.playerToMoveNext),
        start: (boardState) =>
            throw Exception("Can't reach start position after Move"),
        ended: (boardState) => throw Exception(),
      );
    }
    return newBoardState.map(
      running: (boardState) => gameStateWrapper(boardStates.add(boardState)),
      start: (boardState) =>
      throw Exception("Can't reach start position after Move"),
      ended: (boardState) => throw Exception(), // TODO Should return EndedGameState
    );
  }

  GameState takeBack({int? numberOfTurns}) {
    numberOfTurns ??= 1;
    IList<BoardState> newBoardStates;
    if (boardStates.length >= numberOfTurns) {
      newBoardStates = boardStates.removeRange(
          boardStates.length - numberOfTurns, boardStates.length);
    } else {
      newBoardStates = boardStates.removeRange(0, boardStates.length);
    }
    return GameState(newBoardStates);
  }

  GameState takeBackToPlayer(PlayerColor player) {
    IList<BoardState> currentBoardStates = boardStates;
    for (int i = 0; i < 3; i++) {
      if (boardStates.last.playerToMoveNext == player) {
        return GameState(currentBoardStates);
      }
      currentBoardStates = currentBoardStates.removeLast();
    }
    throw Exception('Tried to go back to player that never moved before');
  }
}

mixin DrawGameByRepetition {
  IList<BoardState> get boardStates;

  EndedGameState get drawGameByRepetition =>
      EndedGameState(boardStates, DrawEnd(DrawType.repetition));
}
