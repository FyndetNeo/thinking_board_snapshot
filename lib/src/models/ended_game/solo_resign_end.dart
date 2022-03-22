import '../../utils/better_enum_util.dart';
import '../../utils/board_enums.dart';
import 'ended_game.dart';

class SoloResignEnd extends EndedGame {
  final PlayerColor resignee;

  SoloResignEnd(this.resignee)
      : super.fromMap(
            map: {resignee: WinState.fullLoose},
            defaultWinState: WinState.halfWin);

  @override
  SoloResignEnd copy() {
    return SoloResignEnd(resignee);
  }

  @override
  String get endedString => '${resignee.string} resigned';
}
