import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/board_enums.dart';
import '../../utils/piece_movement.dart';
import '../chess_move.dart';
import '../chess_position.dart';
import '../position.dart';
import 'bishop.dart';
import 'king.dart';
import 'knight.dart';
import 'pawn.dart';
import 'piece_enum.dart';
import 'queen.dart';
import 'rook.dart';

class PieceId extends Equatable {
  final PlayerColor pieceColor;
  final PieceType pieceType;

  const PieceId({required this.pieceType, required this.pieceColor});

  PieceId copyWith({PlayerColor? newPieceColor, PieceType? newPieceType}) {
    return PieceId(
        pieceType: newPieceType ?? pieceType,
        pieceColor: newPieceColor ?? pieceColor);
  }

  @override
  List<Object?> get props => [pieceColor, pieceType];
}

class IPiece {
  final PieceId pieceId;
  final bool didMove;

  PlayerColor get pieceColor => pieceId.pieceColor;

  PieceType get pieceType => pieceId.pieceType;

  const IPiece(this.pieceId, [this.didMove = false]);

  IPiece copyWith({PieceId? newPieceId, bool? newDidMove}) {
    return IPiece(newPieceId ?? pieceId, newDidMove ?? didMove);
  }
}

abstract class PieceCalculator {
  final PlayerColor pieceColor;
  final Position position;

  PieceCalculator(this.pieceColor, this.position);

  ISet<AvailableMove> availableMoves(ChessPosition chessPosition);

  ISet<AvailableMove> filterInCheckChessMove(ChessPosition chessPosition, Set<AvailableMove> inputSet) {
    return inputSet
        .where((availableMove) => !isInCheck(
        chessPosition.positionAfterAvailableMove(availableMove),
        inCheckCandidate: pieceColor))
        .toSet().lock;
  }

  static PieceCalculator pieceFactory(PieceId pieceId, Position position) {
    switch (pieceId.pieceType) {
      case PieceType.pawn:
        return Pawn(pieceId.pieceColor, position);
      case PieceType.rook:
        return Rook(pieceId.pieceColor, position);
      case PieceType.knight:
        return Knight(pieceId.pieceColor, position);
      case PieceType.bishop:
        return Bishop(pieceId.pieceColor, position);
      case PieceType.king:
        return King(pieceId.pieceColor, position);
      case PieceType.queen:
        return Queen(pieceId.pieceColor, position);
    }
  }
}
