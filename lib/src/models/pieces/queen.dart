import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/board_enums.dart';
import '../../utils/piece_movement.dart';
import '../chess_move.dart';
import '../chess_position.dart';
import '../position.dart';
import 'piece.dart';

class Queen extends PieceCalculator {
  Queen(PlayerColor pieceColor, Position position) : super(pieceColor, position);

  @override
  ISet<AvailableMove> availableMoves(ChessPosition chessPosition) {
    Set<AvailableMove> resultSet = {};
    for (Direction direction in Direction.values) {
      resultSet.addAll(canMoveLine(chessPosition,
          startingTile: position,
          direction: direction,
          requestingPlayer: pieceColor));
    }
    return filterInCheckChessMove(chessPosition, resultSet);
  }
}
