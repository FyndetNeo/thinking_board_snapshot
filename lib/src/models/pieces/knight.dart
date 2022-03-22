import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../utils/board_enums.dart';
import '../../utils/piece_movement.dart';
import '../chess_move.dart';
import '../chess_position.dart';
import '../position.dart';
import 'piece.dart';
import 'piece_enum.dart';

const List<List<List<Direction>>> _knightDirectionListList = [
  [
    [Direction.left, Direction.top, Direction.top],
    [Direction.top, Direction.top, Direction.left],
  ],
  [
    [Direction.right, Direction.top, Direction.top],
    [Direction.top, Direction.top, Direction.right],
  ],
  [
    [Direction.top, Direction.left, Direction.left],
    [Direction.left, Direction.left, Direction.top],
  ],
  [
    [Direction.bottom, Direction.left, Direction.left],
    [Direction.left, Direction.left, Direction.bottom],
  ],
  [
    [Direction.left, Direction.bottom, Direction.bottom],
    [Direction.bottom, Direction.bottom, Direction.left],
  ],
  [
    [Direction.right, Direction.bottom, Direction.bottom],
    [Direction.bottom, Direction.bottom, Direction.right],
  ],
  [
    [Direction.top, Direction.right, Direction.right],
    [Direction.right, Direction.right, Direction.top],
  ],
  [
    [Direction.bottom, Direction.right, Direction.right],
    [Direction.right, Direction.right, Direction.bottom],
  ],
];

class Knight extends PieceCalculator {
  Knight(PlayerColor pieceColor, Position position) : super(pieceColor, position);

  static const int stepAmount = 8;

  static ISet<AvailableMove> canMoveKnightStep(ChessPosition chessPosition, {
    required Position startingTile,
    required int moveIndex,
    required PlayerColor requestingPlayer,
  }){
    final firstComplexStep = canMoveComplexStep(chessPosition,
        startingTile: startingTile,
        directionList: _knightDirectionListList[moveIndex][0],
        requestingPlayer: requestingPlayer);
    final secondComplexStep = canMoveComplexStep(chessPosition,
        startingTile: startingTile,
        directionList: _knightDirectionListList[moveIndex][1],
        requestingPlayer: requestingPlayer);
    return firstComplexStep.intersection(secondComplexStep);
  }

  static ISet<Position> isOccupiedKnightStep(ChessPosition chessPosition, {
    required Position startingTile,
    required int moveIndex,
    required PlayerColor requestingPlayer,
    required Set<PieceType> typesToLookFor,
  }){
    final firstComplexStep = isOccupiedComplexStep(chessPosition,
        typesToLookFor: typesToLookFor,
        startingTile: startingTile,
        directionList: _knightDirectionListList[moveIndex][0],
        requestingPlayer: requestingPlayer);
    final secondComplexStep = isOccupiedComplexStep(chessPosition,
        typesToLookFor: typesToLookFor,
        startingTile: startingTile,
        directionList: _knightDirectionListList[moveIndex][1],
        requestingPlayer: requestingPlayer);
    return firstComplexStep.intersection(secondComplexStep);
  }

  @override
  ISet<AvailableMove> availableMoves(ChessPosition chessPosition) {
    Set<AvailableMove> resultSet = {};
    for (int i = 0; i < stepAmount; i++) {
      resultSet.addAll(canMoveKnightStep(chessPosition,
          startingTile: position,
          moveIndex: i,
          requestingPlayer: pieceColor));
    }
    return filterInCheckChessMove(chessPosition, resultSet);
  }
}
