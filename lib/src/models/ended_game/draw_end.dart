import '../../utils/better_enum_util.dart';
import '../../utils/board_enums.dart';
import 'ended_game.dart';

class DrawEnd extends EndedGame {
  final DrawType drawType;

  DrawEnd(this.drawType)
      : super(white: WinState.draw, black: WinState.draw, red: WinState.draw);

  @override
  DrawEnd copy() {
    return DrawEnd(drawType);
  }

  @override
  String get endedString => 'Draw by ${drawType.string}';
}
