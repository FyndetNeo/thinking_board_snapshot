// Flutter imports:


import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/board_enums.dart';
import 'position.dart';

part 'adjacent_tile.freezed.dart';

@freezed
class AdjacentPositions with _$AdjacentPositions {
  const AdjacentPositions._();

  factory AdjacentPositions._internal(
          IMap<Direction, ISet<Position>> of, Position thisPosition) =
      _AdjacentPositions;

  factory AdjacentPositions(
          {required Position thisPosition,
          required ISet<Position> bottomRight,
          required ISet<Position> bottom,
          required ISet<Position> bottomLeft,
          required ISet<Position> left,
          required ISet<Position> leftTop,
          required ISet<Position> top,
          required ISet<Position> topRight,
          required ISet<Position> right}) =>
      AdjacentPositions._internal(
          IMap({
            Direction.bottomRight: bottomRight,
            Direction.bottom: bottom,
            Direction.bottomLeft: bottomLeft,
            Direction.left: left,
            Direction.leftTop: leftTop,
            Direction.top: top,
            Direction.topRight: topRight,
            Direction.right: right,
          }),
          thisPosition);

  ISet<Position> operator [](Direction direction) {
    ISet<Position>? positionSet = of[direction];
    if (positionSet == null) {
      throw Exception(
          'Direction map in AdjacentTiles is not correctly initialized. Any direction should match a list even when empty');
    }
    return positionSet;
  }

  ISet<Position> fromPlayerPerspective(Direction direction, PlayerColor playerColor) {
    PlayerColor side = thisPosition.side;
    ISet<Position>? tilesInDirection = this[
        AdjacentPositions.playerPerspectiveDirection(
            direction, playerColor, side)];
    return tilesInDirection;
  }

  static Direction playerPerspectiveDirection(Direction direction, PlayerColor playerColor, PlayerColor side) {
    return Direction.values[
    (playerColor != side) ? (direction.index + 4) % 8 : direction.index];
  }
}
