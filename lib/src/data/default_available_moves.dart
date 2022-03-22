import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../models/chess_move.dart';
import '../models/position.dart';
import '../utils/board_enums.dart';

final IMap<Position, ISet<AvailableMove>> defaultAvailableMoves = IMap({
  Position.A2: {
    AvailableMove(start: Position.A2, end: Position.A3),
    AvailableMove(
        start: Position.A2, end: Position.A4, moveType: {MoveType.turbo}.lock),
  }.lock,
  Position.B2: {
    AvailableMove(start: Position.B2, end: Position.B3),
    AvailableMove(
        start: Position.B2, end: Position.B4, moveType: {MoveType.turbo}.lock),
  }.lock,
  Position.C2: {
    AvailableMove(start: Position.C2, end: Position.C3),
    AvailableMove(
        start: Position.C2, end: Position.C4, moveType: {MoveType.turbo}.lock),
  }.lock,
  Position.D2: {
    AvailableMove(start: Position.D2, end: Position.D3),
    AvailableMove(
        start: Position.D2, end: Position.D4, moveType: {MoveType.turbo}.lock),
  }.lock,
  Position.E2: {
    AvailableMove(start: Position.E2, end: Position.E3),
    AvailableMove(
        start: Position.E2, end: Position.E4, moveType: {MoveType.turbo}.lock),
  }.lock,
  Position.F2: {
    AvailableMove(start: Position.F2, end: Position.F3),
    AvailableMove(
        start: Position.F2, end: Position.F4, moveType: {MoveType.turbo}.lock),
  }.lock,
  Position.G2: {
    AvailableMove(start: Position.G2, end: Position.G3),
    AvailableMove(
        start: Position.G2, end: Position.G4, moveType: {MoveType.turbo}.lock),
  }.lock,
  Position.H2: {
    AvailableMove(start: Position.H2, end: Position.H3),
    AvailableMove(
        start: Position.H2, end: Position.H4, moveType: {MoveType.turbo}.lock),
  }.lock,
  Position.A1: ISet(),
  Position.B1: {
    AvailableMove(start: Position.B1, end: Position.A3),
    AvailableMove(start: Position.B1, end: Position.C3),
  }.lock,
  Position.C1: ISet(),
  Position.D1: ISet(),
  Position.E1: ISet(),
  Position.F1: ISet(),
  Position.G1: {
    AvailableMove(start: Position.G1, end: Position.F3),
    AvailableMove(start: Position.G1, end: Position.H3),
  }.lock,
  Position.H1: ISet(),
});

