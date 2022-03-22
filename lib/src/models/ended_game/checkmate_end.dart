import '../../utils/better_enum_util.dart';
import '../../utils/board_enums.dart';
import 'ended_game.dart';

class CheckmateEnd extends EndedGame {
  final PlayerColor checkmatedPlayer;
  final PlayerColor winner;

  CheckmateEnd({required this.winner, required this.checkmatedPlayer})
      : super.fromMap(
            map: {winner: WinState.fullWin},
            defaultWinState: WinState.halfLoose);

  @override
  CheckmateEnd copy() {
    return CheckmateEnd(winner: winner, checkmatedPlayer: checkmatedPlayer);
  }

  @override
  String get endedString =>
      '${winner.string} checkmated ${checkmatedPlayer.string}';
}
