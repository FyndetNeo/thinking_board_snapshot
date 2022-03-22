import '../../utils/board_enums.dart';

abstract class EndedGame {
  final Map<PlayerColor, WinState> _winStateMap;

  EndedGame({required WinState white, required WinState black, required WinState red}): _winStateMap = {
    PlayerColor.white: white,
    PlayerColor.black: black,
    PlayerColor.red: red,
  };

  EndedGame.fromMap({required Map<PlayerColor, WinState> map, required WinState defaultWinState}): _winStateMap = {
          PlayerColor.white: map[PlayerColor.white] ?? defaultWinState,
          PlayerColor.black: map[PlayerColor.black] ?? defaultWinState,
          PlayerColor.red: map[PlayerColor.red] ?? defaultWinState,
        };

  EndedGame copy();

  WinState getWinState(PlayerColor playerColor) {
    return _winStateMap[playerColor]!;
  }

  String get endedString;
}
