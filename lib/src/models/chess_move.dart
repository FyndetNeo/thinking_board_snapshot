// Flutter imports:


import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/board_enums.dart';
import 'pieces/piece.dart';
import 'pieces/piece_enum.dart';
import 'position.dart';

part 'chess_move.freezed.dart';

@freezed
class ChessMove with _$ChessMove {
  const ChessMove._();

  const factory ChessMove({required Position start,
    required Position end,
    @Default(PieceType.queen) PieceType promotion}) = _ChessMove;

  factory ChessMove.availableMove({required Position start,
    required Position end,
    @Default(ISetConst({})) ISet<MoveType> moveType,
    @Default(PieceType.queen) PieceType promotion}) = AvailableMove;

  factory ChessMove.processed({required Position start,
    required Position end,
    @Default(ISetConst({})) ISet<MoveType> moveType,
    required PieceId movedPiece,
    @Default(PieceType.queen) PieceType promotion}) = ProcessedChessMove;

  ChessMove get flattened => ChessMove(start: start, end: end, promotion: promotion);

  PlayerMove toPlayerMove() => PlayerMove.chessMove(this);

}

@freezed
class MissTurn with _$MissTurn {
  const MissTurn._();
  factory MissTurn() = _MissTurn;
  PlayerMove toPlayerMove() => const PlayerMove.missTurn();

  ProcessedPlayerMove toProcessedPlayerMove() =>
      const ProcessedPlayerMove.missTurn();
}

@freezed
class PlayerMove with _$PlayerMove {
  const PlayerMove._();

  @With<MissTurnConversions>()
  const factory PlayerMove.missTurn() = _PlayerMoveMissTurn;

  const factory PlayerMove.chessMove(ChessMove chessMove) = _PlayerChessMove;
}

@freezed
class ProcessedPlayerMove with _$ProcessedPlayerMove {
  const ProcessedPlayerMove._();

  @With<MissTurnConversions>()
  const factory ProcessedPlayerMove.missTurn() =
  _ProcessedPlayerMoveMissTurn;

  const factory ProcessedPlayerMove.chessMove(ProcessedChessMove info) =
  _ProcessedChessMove;
}

mixin MissTurnConversions{
  PlayerMove toPlayerMove() => const PlayerMove.missTurn();

  ProcessedPlayerMove toProcessedPlayerMove() =>
      const ProcessedPlayerMove.missTurn();

}

extension ChessMoveExtension on _ChessMove {
  ProcessedChessMove toProcessed(ISet<MoveType> moveType, PieceId movedPiece) =>
      ProcessedChessMove(
          start: start, end: end, moveType: moveType, movedPiece: movedPiece);

  AvailableMove toAvailable(ISet<MoveType> moveType) => AvailableMove(
      start: start, end: end, moveType: moveType, promotion: promotion);
}

extension AvailableMixin on AvailableMove {
  ProcessedChessMove toProcessed(PieceId movedPiece) => ProcessedChessMove(
      start: start,
      end: end,
      moveType: moveType,
      movedPiece: movedPiece,
      promotion: promotion);
}

extension ProcessedMixin on ProcessedChessMove{
  AvailableMove toAvailable() => AvailableMove(
      start: start, end: end, moveType: moveType, promotion: promotion);

  ProcessedPlayerMove toProcessedPlayerMove() =>
      ProcessedPlayerMove.chessMove(this);

  ProcessedPlayerMove toPPM() => toProcessedPlayerMove();
}
