enum PlayerColor {
  white,
  black,
  red,
}

extension PlayerColorUtil on PlayerColor {
  PlayerColor get next {
    return PlayerColor.values[(index +1) % 3];
  }
  PlayerColor get previous {
    return PlayerColor.values[(index +2) % 3];
  }
}

enum TileColor { white, black }

enum TileHighlight {
  inCheck,
  movable
}


enum Direction {
  bottomRight,
  bottom,
  bottomLeft,
  left,
  leftTop,
  top,
  topRight,
  right,
}

extension DirectionUtil on Direction{
  Direction get opposite {
    return Direction.values[(index + 4) % 8];
  }
  static Set<Direction> get diagonals => {Direction.leftTop, Direction.bottomRight, Direction.bottomLeft, Direction.topRight};
  static Set<Direction> get straight => {Direction.top, Direction.right, Direction.bottom, Direction.left};
}

enum MoveType {
  take,
  check,
  enpassent,
  castle,
  checkMate,
  turbo,
}

enum DrawType {
  repetition,
  agreement,
  material,
  noMoves,
  fiftyMovesRule,
}

enum WinState {
  fullLoose,
  halfLoose,
  draw,
  halfWin,
  fullWin
}