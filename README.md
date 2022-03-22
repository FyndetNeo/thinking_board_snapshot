
This library makes it possible to implement Three Player Chess in dart.

## Usage

```dart
GameState gameState = GameState.newGame();
gameState = gameState.newChessMove(PlayerMove.chessMove(start: Position.E2, end: Position.E4));

print(gameState.playerToMoveNext)
print(gameState.boardStates.last.availableMoves())

gameState = gameState.resign(PlayerColor.black)

print(gameState is EndedGameState)
```
