import '../../utils/better_enum_util.dart';
import '../../utils/board_enums.dart';
import 'ended_game.dart';

class AgreedResignEnd extends EndedGame {
  final PlayerColor winner;

  AgreedResignEnd(this.winner)
      : super.fromMap(
            map: {winner: WinState.fullWin},
            defaultWinState: WinState.halfLoose);

  @override
  AgreedResignEnd copy() {
    return AgreedResignEnd(winner);
  }

  @override
  String get endedString => 'Resigned to ${winner.string}';
}
