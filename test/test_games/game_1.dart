import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:thinking_board/src/models/chess_move.dart';
import 'package:thinking_board/src/models/position.dart';

final IList<PlayerMove> game_1 = IList([
  PlayerMove.chessMove(ChessMove(start: Position.E2, end: Position.E4)),
  PlayerMove.chessMove(ChessMove(start: Position.D7, end: Position.D5)),
  PlayerMove.chessMove(ChessMove(start: Position.E11, end: Position.E9)),
  PlayerMove.chessMove(ChessMove(start: Position.D1, end: Position.G4)),
  PlayerMove.chessMove(ChessMove(start: Position.K8, end: Position.L6)),
  PlayerMove.chessMove(ChessMove(start: Position.H11, end: Position.H10)),
  PlayerMove.chessMove(ChessMove(start: Position.G4, end: Position.E10)),
  PlayerMove.chessMove(ChessMove(start: Position.B8, end: Position.A6)),
  PlayerMove.chessMove(ChessMove(start: Position.H10, end: Position.H9)),
  PlayerMove.chessMove(ChessMove(start: Position.E10, end: Position.K10)),
  PlayerMove.chessMove(ChessMove(start: Position.A6, end: Position.B4)),
  PlayerMove.chessMove(ChessMove(start: Position.F12, end: Position.E11)),
  PlayerMove.chessMove(ChessMove(start: Position.D2, end: Position.D4)),
  PlayerMove.chessMove(ChessMove(start: Position.B4, end: Position.A6)),
  PlayerMove.chessMove(ChessMove(start: Position.H12, end: Position.H11)),
  PlayerMove.chessMove(ChessMove(start: Position.C1, end: Position.F4)),
  PlayerMove.chessMove(ChessMove(start: Position.A6, end: Position.B8)),
  PlayerMove.chessMove(ChessMove(start: Position.H11, end: Position.H12)),
  PlayerMove.chessMove(ChessMove(start: Position.F4, end: Position.E9)),
  PlayerMove.chessMove(ChessMove(start: Position.L8, end: Position.K8)),
  PlayerMove.chessMove(ChessMove(start: Position.H12, end: Position.H11)),
  PlayerMove.chessMove(ChessMove(start: Position.K10, end: Position.J11)),
  PlayerMove.chessMove(ChessMove(start: Position.B8, end: Position.A6)),
  PlayerMove.missTurn(),
  PlayerMove.chessMove(ChessMove(start: Position.J11, end: Position.I12)),
]);
