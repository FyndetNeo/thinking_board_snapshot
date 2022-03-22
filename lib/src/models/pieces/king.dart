import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/board_enums.dart';
import '../../utils/piece_movement.dart';
import '../chess_move.dart';
import '../chess_position.dart';
import '../position.dart';
import 'piece.dart';

class King extends PieceCalculator {
  King(PlayerColor pieceColor, Position position) : super(pieceColor, position);

  Set<AvailableMove> checkForCastling(ChessPosition chessPosition) {
    Set<AvailableMove> resultSet = {};
    if (chessPosition[position]?.didMove == false) {
      if (chessPosition[Position.A1.equalPosition(pieceColor)]
          ?.didMove ==
          false) {
        //Long castling
        if (chessPosition[
        Position.B1.equalPosition(pieceColor)] ==
            null &&
            chessPosition[Position.C1.equalPosition(pieceColor)] ==
                null &&
            chessPosition[Position.D1.equalPosition(pieceColor)] ==
                null) {
          resultSet.add(AvailableMove(
              start: position,
              end: Position.C1.equalPosition(pieceColor),
              moveType: ISet(const {MoveType.castle})));
        }
      }
      if (chessPosition[Position.H1.equalPosition(pieceColor)]
          ?.didMove ==
          false) {
        //short castling
        if (chessPosition[Position.G1.equalPosition(pieceColor)] ==
            null &&
            chessPosition[Position.F1.equalPosition(pieceColor)] ==
                null) {
          resultSet.add(AvailableMove(
              start: position,
              end: Position.G1.equalPosition(pieceColor),
              moveType: ISet(const {MoveType.castle})));
        }
      }
    }
    return resultSet;
  }

  @override
  ISet<AvailableMove> availableMoves(ChessPosition chessPosition) {
    Set<AvailableMove> resultSet = {};
    for (Direction direction in Direction.values) {
      resultSet.addAll(canMoveStep(chessPosition,
          startingTile: position,
          direction: direction,
          requestingPlayer: pieceColor,
          canOnlyTake: false,
          canTake: true));
    }
    resultSet.addAll(checkForCastling(chessPosition));
    return filterInCheckChessMove(chessPosition, resultSet);
  }
}
