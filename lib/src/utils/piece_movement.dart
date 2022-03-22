import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../models/chess_move.dart';
import '../models/chess_position.dart';
import '../models/pieces/knight.dart';
import '../models/pieces/piece.dart';
import '../models/pieces/piece_enum.dart';
import '../models/position.dart';
import 'board_enums.dart';

ISet<Position> isOccupiedLine(ChessPosition chessPosition, {
  required Position startingTile,
  required Direction direction,
  required PlayerColor requestingPlayer,
  required Set<PieceType> typesToLookFor,
}) {
  Set<Position> _nextStep(Position fromTile, [Set<Position>? set]) {
    set ??= {};
    ISet<Position> nextTiles = fromTile.adjacentTiles
        .fromPlayerPerspective(direction,  startingTile.side);
    for (Position tile in nextTiles) {
      IPiece? piece = chessPosition[tile];
      if (piece == null) {
        _nextStep(tile, set);
        break;
      }
      if (piece.pieceColor != requestingPlayer &&
          typesToLookFor.contains(piece.pieceType)) {
        set.add(tile);
        break;
      }
    }
    return set;
  }

  return _nextStep(startingTile).lock;
}

ISet<AvailableMove> canMoveLine(ChessPosition chessPosition, {
  required Position startingTile,
  required Direction direction,
  required PlayerColor requestingPlayer,
}) {
  Set<AvailableMove> _nextStep(Position fromTile, [Set<AvailableMove>? set]) {
    set ??= {};
    ISet<Position> nextTiles = fromTile.adjacentTiles
        .fromPlayerPerspective(direction, startingTile.side);
    for (Position tile in nextTiles) {
      IPiece? piece = chessPosition[tile];
      if (piece == null) {
        set
            .add(AvailableMove(start: startingTile, end: tile));
        _nextStep(tile, set);
      } else if (piece.pieceColor != requestingPlayer) {
        set.add(AvailableMove(start: startingTile,
            end: tile, moveType: ISet(const {MoveType.take})));
      }
    }
    return set;
  }


  return _nextStep(startingTile).lock;
}

ISet<Position> isOccupiedStep(ChessPosition chessPosition,
    {required Position startingTile,
      required Direction direction,
      required PlayerColor requestingPlayer,
      required Set<PieceType> typesToLookFor,
      bool canTake = true}) {
  Set<Position> nextTiles = startingTile.adjacentTiles
      .fromPlayerPerspective(direction, requestingPlayer).unlock;
  Set<Position> resultSet = {};
  for (Position tile in nextTiles) {
    IPiece? piece = chessPosition[tile];
    if (piece?.pieceColor != requestingPlayer &&
        typesToLookFor.contains(piece?.pieceType) &&
        canTake) {
      resultSet.add(tile);
    }
  }
  return resultSet.lock;
}

ISet<AvailableMove> canMoveStep(ChessPosition chessPosition,
    {required Position startingTile,
      required Direction direction,
      required PlayerColor requestingPlayer,
      bool canTake = true,
      bool canOnlyTake = false}) {
  ISet<Position> nextTiles = startingTile.adjacentTiles
      .fromPlayerPerspective(direction, requestingPlayer);
  Set<AvailableMove> resultSet = {};
  for (Position tile in nextTiles) {
    IPiece? piece = chessPosition[tile];
    if (piece == null) {
      if (!canOnlyTake) {
        resultSet
            .add(AvailableMove(start: startingTile, end: tile));
      }
    } else if (piece.pieceColor != requestingPlayer) {
      if (canTake) {
        resultSet.add(AvailableMove(start: startingTile,
            end: tile, moveType: ISet(const {MoveType.take})));
      }
    }
  }
  return resultSet.lock;
}

ISet<Position> isOccupiedComplexStep(ChessPosition chessPosition,
    {required Position startingTile,
      required List<Direction> directionList,
      required PlayerColor requestingPlayer,
      required Set<PieceType> typesToLookFor}) {
  Set<Position> _nextStep(Position tile, int index, [Set<Position>? set]) {
    set ??= {};
    if (index == directionList.length) {
      IPiece? piece = chessPosition[tile];
      if (piece?.pieceColor != requestingPlayer &&
          typesToLookFor.contains(piece?.pieceType)) {
        set.add(tile);
      }
    }
    else {
      int newIndex = index +1;
      tile.adjacentTiles
          .fromPlayerPerspective(directionList[index], requestingPlayer)
          .forEach((position) => _nextStep(position, newIndex, set));
    }
    return set;
  }

  return _nextStep(startingTile, 0).lock;
}

ISet<AvailableMove> canMoveComplexStep(ChessPosition chessPosition, {
  required Position startingTile,
  required List<Direction> directionList,
  required PlayerColor requestingPlayer,
}) {
  Set<AvailableMove> _nextStep(Position tile, int index, [Set<AvailableMove>? set]) {
    set ??= {};
    if (index == directionList.length) {
      IPiece? piece = chessPosition[tile];
      if (piece == null) {
        set
            .add(AvailableMove(start: startingTile, end: tile));
      } else if (piece.pieceColor != requestingPlayer) {
        set.add(AvailableMove(start: startingTile,
            end: tile, moveType: ISet(const {MoveType.take})));
      }
    }
    else{
      int newIndex = index +1;
      tile.adjacentTiles
          .fromPlayerPerspective(directionList[index], requestingPlayer)
          .forEach((position) => _nextStep(position, newIndex, set));
    }
    return set;
  }

  return _nextStep(startingTile, 0).lock;
}

bool checkIfCovered(ChessPosition chessPosition, {
  required Position position,
  required PlayerColor requestingPlayer,
}) {
  for (Direction direction in DirectionUtil.straight) {
    if (isOccupiedLine(chessPosition,
        startingTile: position,
        direction: direction,
        typesToLookFor: {PieceType.queen, PieceType.rook},
        requestingPlayer: requestingPlayer)
        .isNotEmpty) {
      return true;
    }
  }
  for (Direction direction in DirectionUtil.diagonals) {
    if (isOccupiedLine(chessPosition,
        startingTile: position,
        direction: direction,
        typesToLookFor: {PieceType.queen, PieceType.bishop},
        requestingPlayer: requestingPlayer)
        .isNotEmpty) {
      return true;
    }
  }
  for (Direction direction in Direction.values) {
    if (isOccupiedStep(chessPosition,
        startingTile: position,
        direction: direction,
        typesToLookFor: {
          PieceType.king,
        },
        requestingPlayer: requestingPlayer)
        .isNotEmpty) {
      return true;
    }
  }
  for (int i = 0; i < Knight.stepAmount; i++) {
    if (Knight.isOccupiedKnightStep(chessPosition,
        startingTile: position,
        moveIndex: i,
        typesToLookFor: {
          PieceType.knight,
        },
        requestingPlayer: requestingPlayer)
        .isNotEmpty) {
      return true;
    }
  }
  for (Direction direction in {Direction.leftTop, Direction.topRight}) {
    if (isOccupiedStep(
      chessPosition,
      startingTile: position,
      direction: direction,
      typesToLookFor: {
        PieceType.pawn,
      },
      requestingPlayer: requestingPlayer,
      canTake: true,
    ).isNotEmpty) {
      return true;
    }
  }
  if (isOccupiedStep(chessPosition,
      startingTile: position,
      direction: Direction.top,
      typesToLookFor: {
        PieceType.pawn,
      },
      requestingPlayer: requestingPlayer,
      canTake: false)
      .isNotEmpty) {
    return true;
  }
  return false;
}

bool isInCheck(ChessPosition chessPosition, {
  required PlayerColor inCheckCandidate,
}) {
  final kingPosition = chessPosition.kingPosition[inCheckCandidate];
  if (kingPosition == null) {
    return false;
  }
  return checkIfCovered(chessPosition,
      position: kingPosition, requestingPlayer: inCheckCandidate);
}
