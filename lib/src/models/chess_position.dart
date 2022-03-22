// Flutter imports:


import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/board_enums.dart';
import 'chess_move.dart';
import 'pieces/king.dart';
import 'pieces/pawn.dart';
import 'pieces/piece.dart';
import 'pieces/piece_enum.dart';
import 'position.dart';

part 'chess_position.freezed.dart';

typedef BoardPosition = IMap<Position, IPiece>;
typedef Enpassentable = IMap<PlayerColor, Position>;

@freezed
class ChessPosition with _$ChessPosition {
  const ChessPosition._();

  factory ChessPosition._internal(BoardPosition boardPosition,
      Enpassentable enpassentable,
      IMap<PlayerColor, Position> kingPosition) = _ChessPosition;

  factory ChessPosition(BoardPosition boardPosition, Enpassentable enpassentable) =>
      ChessPosition._internal(
          boardPosition,
          enpassentable,
          _calculateKingPosition(boardPosition));

  static IMap<PlayerColor, Position> _calculateKingPosition(BoardPosition boardPosition) {
    Map<PlayerColor, Position> resultMap = {};
    for (MapEntry<Position, IPiece> boardEntry in boardPosition.entries) {
      final piece = boardEntry.value;
      if (piece.pieceType == PieceType.king) {
        resultMap[piece.pieceColor] = boardEntry.key;
      }
    }
    return resultMap.lock;
  }

  IPiece? operator [](Position position) {
    return boardPosition[position];
  }

  ChessPosition positionAfterChessMove(PlayerMove chessMove){
    return chessMove.when(
      missTurn: () => this,
      chessMove: (ChessMove chessMove) => positionAfterNotEmptyChessMove(chessMove),);
  }

  ChessPosition positionAfterNotEmptyChessMove(ChessMove chessMove){
    return chessMove.map(
          (ChessMove chessMove) => positionAfterMove(chessMove),
      availableMove: (AvailableMove chessMove) => positionAfterAvailableMove(chessMove),
      processed: (ProcessedChessMove chessMove) => positionAfterAvailableMove(chessMove.toAvailable()),
    );
  }

  ChessPosition positionAfterAvailableMove(AvailableMove chessMove) {
    final piece = this[chessMove.start];
    if (piece == null) {
      throw Exception(
          'Tried to get position after move without a piece moving');
    }

    final newEnpassent = enpassentable.unlock;
    newEnpassent.remove(piece.pieceColor);
    final newBoardPosition = boardPosition.unlock;

    if (chessMove.moveType.contains(MoveType.enpassent)) {
      newBoardPosition.remove(chessMove.end.adjacentTiles[Direction.top].first);
    } else if (chessMove.moveType.contains(MoveType.turbo)) {
      newEnpassent[piece.pieceColor] = chessMove.end;
    } else if (chessMove.moveType.contains(MoveType.castle)) {
      _castleRook(chessMove, piece, newBoardPosition);
    }

    newBoardPosition.remove(chessMove.start);
    newBoardPosition[chessMove.end] = piece.copyWith(newDidMove: true);
    return ChessPosition(newBoardPosition.lock, newEnpassent.lock);
  }

  ChessPosition positionAfterMove(ChessMove chessMove) {
    final piece = this[chessMove.start];
    if (piece == null) {
      throw Exception(
          'Tried to get position after move without a piece moving');
    }

    final newEnpassent = enpassentable.unlock;
    newEnpassent.remove(piece.pieceColor);
    final newBoardPosition = boardPosition.unlock;

    bool isEnpassent = piece.pieceType == PieceType.pawn &&
        Pawn(piece.pieceColor, chessMove.start)
            .checkEnpassent(ChessPosition(newBoardPosition.lock, IMap()))
            .firstWhereOrNull((element) => element.flattened == chessMove.flattened) != null;

    if (isEnpassent) {
      newBoardPosition.remove(chessMove.end.adjacentTiles[Direction.top].first);
    } else {
      bool isTurbo = piece.pieceType == PieceType.pawn &&
          Pawn(piece.pieceColor, chessMove.start)
              .checkTurbo(ChessPosition(newBoardPosition.lock, IMap()))
              .firstWhereOrNull((element) => element.flattened == chessMove.flattened) != null;
      if (isTurbo) {
        newEnpassent[piece.pieceColor] = chessMove.end;
      } else {
        bool isCastling = piece.pieceType == PieceType.king &&
            King(piece.pieceColor, chessMove.start)
                .checkForCastling(ChessPosition(newBoardPosition.lock, IMap()))
                .contains(chessMove);

        if (isCastling) {
          _castleRook(chessMove, piece, newBoardPosition);
        }
      }
    }

    newBoardPosition.remove(chessMove.start);
    newBoardPosition[chessMove.end] = piece.copyWith(newDidMove: true);
    return ChessPosition(newBoardPosition.lock, newEnpassent.lock);
  }

  void _castleRook(ChessMove chessMove, IPiece piece,
      Map<Position, IPiece> newBoardPosition) {
    if ((chessMove.end.indexOfRow - chessMove.start.indexOfRow) == -2) {
      Position rookPosition = Position.A1.equalPosition(piece.pieceColor);
      Position newRookPosition = Position.D1.equalPosition(piece.pieceColor);
      IPiece rook = newBoardPosition[rookPosition]!;
      newBoardPosition.remove(rookPosition);
      newBoardPosition[newRookPosition] = rook.copyWith(newDidMove: true);
    } else if ((chessMove.end.indexOfRow - chessMove.start.indexOfRow) == 2) {
      Position rookPosition = Position.H1.equalPosition(piece.pieceColor);
      Position newRookPosition = Position.F1.equalPosition(piece.pieceColor);
      IPiece rook = newBoardPosition[rookPosition]!;
      newBoardPosition.remove(rookPosition);
      newBoardPosition[newRookPosition] = rook.copyWith(newDidMove: true);
    }
  }
}
