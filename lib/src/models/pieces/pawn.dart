import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/board_enums.dart';
import '../../utils/piece_movement.dart';
import '../chess_move.dart';
import '../chess_position.dart';
import '../position.dart';
import 'piece.dart';

class Pawn extends PieceCalculator {
  Pawn(PlayerColor pieceColor, Position position) : super(pieceColor, position);

  ISet<AvailableMove> checkEnpassent(ChessPosition chessPosition) {
    Set<AvailableMove> resultSet = {};
    if (position.indexOfRank == 3) {
      final candidateSets = [
        position.adjacentTiles[Direction.left],
        position.adjacentTiles[Direction.right]
      ];
      final potentialPawns = [
        if(candidateSets[0].isNotEmpty) candidateSets[0].first,
        if(candidateSets[1].isNotEmpty) candidateSets[1].first,      ];
      for (Position enpassentCandidate in potentialPawns) {
        final piece = chessPosition[enpassentCandidate];
        if (piece != null &&
            chessPosition.enpassentable[position.side] == enpassentCandidate) {
          resultSet.add(AvailableMove(
              start: position,
              end: enpassentCandidate.adjacentTiles[Direction.bottom].first,
              moveType: ISet(const {MoveType.enpassent, MoveType.take})));
          break;
        }
      }
    }
    return resultSet.lock;
  }

  ISet<AvailableMove> checkTurbo(ChessPosition chessPosition) {
    Set<AvailableMove> resultSet = {};
    if (chessPosition[position]?.didMove == false &&
        position.indexOfRank == 1) {
      final onePositionAhead = position.adjacentTiles[Direction.top].first;
      final oneTileAhead = chessPosition[onePositionAhead];

      final twoPositionAhead =
          onePositionAhead.adjacentTiles[Direction.top].first;
      final twoTileAhead = chessPosition[twoPositionAhead];

      if (oneTileAhead == null && twoTileAhead == null) {
        resultSet.add(AvailableMove(
            start: position,
            end: twoPositionAhead,
            moveType: ISet(const {MoveType.turbo})));
      }
    }
    return resultSet.lock;
  }

  @override
  ISet<AvailableMove> availableMoves(ChessPosition chessPosition) {
    Set<AvailableMove> resultSet = {};
    for (Direction direction in {Direction.leftTop, Direction.topRight}) {
      resultSet.addAll(canMoveStep(
        chessPosition,
        startingTile: position,
        direction: direction,
        requestingPlayer: pieceColor,
        canTake: true,
        canOnlyTake: true,
      ));
    }
    resultSet.addAll(canMoveStep(
      chessPosition,
      startingTile: position,
      direction: Direction.top,
      requestingPlayer: pieceColor,
      canTake: false,
      canOnlyTake: false,
    ));
    resultSet.addAll(checkTurbo(chessPosition));

    resultSet.addAll(checkEnpassent(chessPosition));

    return filterInCheckChessMove(chessPosition, resultSet);
  }

}
