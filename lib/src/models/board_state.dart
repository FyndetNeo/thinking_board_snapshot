// Flutter imports:

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/default_available_moves.dart';
import '../data/default_starting_positions.dart';
import '../utils/board_enums.dart';
import '../utils/piece_movement.dart';
import 'chess_move.dart';
import 'chess_position.dart';
import 'ended_game/checkmate_end.dart';
import 'ended_game/draw_end.dart';
import 'ended_game/ended_game.dart';
import 'pieces/piece.dart';
import 'pieces/piece_enum.dart';
import 'position.dart';

part 'board_state.freezed.dart';

@freezed
class BoardState with _$BoardState {
  const BoardState._();

  @With<MovableBoardState>()
  factory BoardState.running({
    required ChessPosition currentPosition,
    required ISet<PlayerColor> inCheck,
    required PlayerColor playerToMoveNext,
    required ProcessedPlayerMove lastChessMove,
    required bool canCurrentPlayerMove,
    required IMap<Position, ISet<AvailableMove>> availableMoves,
  }) = RunningState;

  @With<MovableBoardState>()
  factory BoardState.start({
    required ChessPosition currentPosition,
    required ISet<PlayerColor> inCheck,
    required PlayerColor playerToMoveNext,
    required IMap<Position, ISet<AvailableMove>> availableMoves,
  }) = StartState;

  factory BoardState.defaultStart() => StartState(
        currentPosition: ChessPosition(defaultStartingBoard, IMap()),
        inCheck: ISet(),
        playerToMoveNext: PlayerColor.white,
        availableMoves: defaultAvailableMoves,
      );

  factory BoardState.ended({
    required ChessPosition currentPosition,
    required ISet<PlayerColor> inCheck,
    required EndedGame gameEndedObject,
    required PlayerColor playerToMoveNext,
    required ProcessedPlayerMove lastChessMove,
  }) = EndedState;

  EndedState toEndedState(EndedGame endType) {
    return EndedState(
        currentPosition: currentPosition,
        inCheck: inCheck,
        gameEndedObject: endType,
        playerToMoveNext: playerToMoveNext,
        lastChessMove: map(
          running: (boardState) => boardState.lastChessMove,
          ended: (boardState) => boardState.lastChessMove,
          start: (_) => throw Exception("Can't end game without moves"),
        ));
  }
}

mixin MovableBoardState {
  ChessPosition get currentPosition;

  ISet<PlayerColor> get inCheck;

  PlayerColor get playerToMoveNext;

  IMap<Position, ISet<AvailableMove>> get availableMoves;

  Future<BoardState> onPlayerMovePromo(PlayerMove playerMove,
      [Future<PieceType> Function(ChessMove)? onPromotion]) async {
    return playerMove.when(
        missTurn: () => _onMissTurn(),
        chessMove: (chessMove) => _onChessMovePromo(chessMove));
  }

  Future<BoardState> _onChessMovePromo(ChessMove chessMove,
      [Future<PieceType> Function(ChessMove)? onPromotion]) async {
    onPromotion ??= (chessMove) => Future<PieceType>.value(PieceType.queen);
    final piece = currentPosition[chessMove.start];
    if (piece != null &&
        piece.pieceType == PieceType.pawn &&
        chessMove.end.indexOfRank == 0 &&
        chessMove.end.side != piece.pieceColor) {
      PieceType newPieceType = await onPromotion(chessMove);
      return Future.value(
          _onChessMove(chessMove.copyWith(promotion: newPieceType)));
    }
    return Future.value(_onChessMove(chessMove));
  }

  BoardState onPlayerMove(PlayerMove playerMove) {
    return playerMove.when(
      missTurn: () => _onMissTurn(),
      chessMove: (ChessMove chessMove) => _onChessMove(chessMove),
    );
  }

  BoardState _onMissTurn() {
    final thisState = this;
    if (thisState is RunningState && thisState.canCurrentPlayerMove) {
      throw _invalidMove(MissTurn().toPlayerMove());
    }
    final newPlayerToMoveNext = playerToMoveNext.next;
    final newAvailableMoves =
        _calculateAvailableMoves(currentPosition, newPlayerToMoveNext);
    final newCanCurrentPlayerMove = _calculateCanPlayerMove(newAvailableMoves);
    return RunningState(
        currentPosition: currentPosition,
        playerToMoveNext: newPlayerToMoveNext,
        lastChessMove: const ProcessedPlayerMove.missTurn(),
        inCheck: inCheck,
        canCurrentPlayerMove: newCanCurrentPlayerMove,
        availableMoves: newAvailableMoves);
  }

  BoardState _onChessMove(ChessMove chessMove) {
    //Check if valid and if not throw Exception
    AvailableMove? availableMove = availableMoves[chessMove.start]
        ?.firstWhereOrNull((move) => move.end == chessMove.end);
    if (availableMove == null) {
      throw _invalidMove(chessMove.toPlayerMove());
    }
    final piece = currentPosition[chessMove.start]!;
    ChessPosition newBoardPosition =
        currentPosition.positionAfterNotEmptyChessMove(availableMove);
    final newPlayerToMoveNext = playerToMoveNext.next;
    final newInCheck = _calculateInCheck(newBoardPosition);
    final newAvailableMoves =
        _calculateAvailableMoves(newBoardPosition, newPlayerToMoveNext);
    final newCanCurrentPlayerMove = _calculateCanPlayerMove(newAvailableMoves);
    for (PlayerColor playerColor
        in PlayerColor.values.where((element) => element != playerToMoveNext)) {
      if (isInCheck(newBoardPosition, inCheckCandidate: playerColor)) {
        availableMove.copyWith(
            moveType: availableMove.moveType.add(MoveType.check));
      }
    }
    ProcessedChessMove newLastChessMove =
        availableMove.toProcessed(piece.pieceId);

    //on Promotion
    if (piece.pieceType == PieceType.pawn &&
        chessMove.end.indexOfRank == 0 &&
        chessMove.end.side != piece.pieceColor) {
      PieceType newPieceType = chessMove.promotion;
      final mutableBoard = newBoardPosition.boardPosition.unlock;
      mutableBoard[chessMove.end] = IPiece(
          PieceId(pieceType: newPieceType, pieceColor: piece.pieceColor), true);
      newBoardPosition =
          ChessPosition(mutableBoard.lock, newBoardPosition.enpassentable);
    }
    //If King is taken
    if (availableMove.moveType.contains(MoveType.take)) {
      final takenPiece = currentPosition[availableMove.end]!;
      newLastChessMove = newLastChessMove.copyWith(
          moveType: newLastChessMove.moveType.add(MoveType.checkMate));
      if (takenPiece.pieceId.pieceType == PieceType.king) {
        return EndedState(
            currentPosition: currentPosition,
            inCheck: inCheck.remove(takenPiece.pieceColor),
            gameEndedObject: CheckmateEnd(
                checkmatedPlayer: takenPiece.pieceColor,
                winner: piece.pieceColor),
            playerToMoveNext: playerToMoveNext,
            lastChessMove: newLastChessMove.toProcessedPlayerMove());
      }
    }
    //Draw by no moves
    if (!newCanCurrentPlayerMove && !newInCheck.contains(newPlayerToMoveNext)) {
      return EndedState(
          currentPosition: currentPosition,
          inCheck: newInCheck,
          gameEndedObject: DrawEnd(DrawType.noMoves),
          playerToMoveNext: newPlayerToMoveNext,
          lastChessMove: newLastChessMove.toProcessedPlayerMove());
    }
    //New movable state
    return RunningState(
        currentPosition: newBoardPosition,
        playerToMoveNext: newPlayerToMoveNext,
        lastChessMove: newLastChessMove.toProcessedPlayerMove(),
        inCheck: newInCheck,
        canCurrentPlayerMove: newCanCurrentPlayerMove,
        availableMoves: newAvailableMoves);
  }

  ISet<PlayerColor> _calculateInCheck(ChessPosition chessPosition) {
    Set<PlayerColor> inCheck = {};
    for (PlayerColor playerColor in PlayerColor.values) {
      if (isInCheck(chessPosition, inCheckCandidate: playerColor)) {
        inCheck.add(playerColor);
      }
    }
    return inCheck.lock;
  }

  IMap<Position, ISet<AvailableMove>> _calculateAvailableMoves(
      ChessPosition chessPosition, PlayerColor playerColor) {
    Map<Position, ISet<AvailableMove>> resultMap = {};
    for (MapEntry<Position, IPiece> pieceEntry
        in chessPosition.boardPosition.entries) {
      IPiece piece = pieceEntry.value;
      if (piece.pieceId.pieceColor == playerColor) {
        Position position = pieceEntry.key;
        PieceCalculator pieceModel =
            PieceCalculator.pieceFactory(piece.pieceId, position);
        resultMap[position] = pieceModel.availableMoves(chessPosition);
      }
    }
    return resultMap.lock;
  }

  bool _calculateCanPlayerMove(
      IMap<Position, ISet<AvailableMove>> availableMovesMap) {
    for (MapEntry<Position, ISet<AvailableMove>> availableMoveEntry
        in availableMovesMap.entries) {
      if (availableMoveEntry.value.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  static Exception _invalidMove(PlayerMove chessMove) {
    return Exception(
        'Tried to construct invalid BoardState with chessMove: ${chessMove.toString()}');
  }
}
