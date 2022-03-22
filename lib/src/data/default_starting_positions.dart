import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../models/pieces/piece.dart';
import '../models/pieces/piece_enum.dart';
import '../models/position.dart';
import '../utils/board_enums.dart';

final IMap<Position, IPiece> defaultStartingBoard = const {
  Position.A2: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.white,
  )),
  Position.B2: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.white,
  )),
  Position.C2: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.white, )),
  Position.D2: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.white, )),
  Position.E2: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.white, )),
  Position.F2: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.white, )),
  Position.G2: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.white, )),
  Position.H2: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.white, )),
  Position.A1: IPiece(PieceId(
    pieceType: PieceType.rook,
    pieceColor: PlayerColor.white, )),
  Position.B1: IPiece(PieceId(
    pieceType: PieceType.knight,
    pieceColor: PlayerColor.white, )),
  Position.C1: IPiece(PieceId(
    pieceType: PieceType.bishop,
    pieceColor: PlayerColor.white, )),
  Position.D1: IPiece(PieceId(
    pieceType: PieceType.queen,
    pieceColor: PlayerColor.white, )),
  Position.E1: IPiece(PieceId(
    pieceType: PieceType.king,
    pieceColor: PlayerColor.white, )),
  Position.F1: IPiece(PieceId(
    pieceType: PieceType.bishop,
    pieceColor: PlayerColor.white, )),
  Position.G1: IPiece(PieceId(
    pieceType: PieceType.knight,
    pieceColor: PlayerColor.white, )),
  Position.H1: IPiece(PieceId(
    pieceType: PieceType.rook,
    pieceColor: PlayerColor.white, )),
  Position.L7: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.black, )),
  Position.K7: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.black, )),
  Position.J7: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.black, )),
  Position.I7: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.black, )),
  Position.D7: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.black, )),
  Position.C7: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.black, )),
  Position.B7: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.black, )),
  Position.A7: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.black, )),
  Position.L8: IPiece(PieceId(
    pieceType: PieceType.rook,
    pieceColor: PlayerColor.black, )),
  Position.K8: IPiece(PieceId(
    pieceType: PieceType.knight,
    pieceColor: PlayerColor.black, )),
  Position.J8: IPiece(PieceId(
    pieceType: PieceType.bishop,
    pieceColor: PlayerColor.black, )),
  Position.I8: IPiece(PieceId(
    pieceType: PieceType.queen,
    pieceColor: PlayerColor.black, )),
  Position.D8: IPiece(PieceId(
    pieceType: PieceType.king,
    pieceColor: PlayerColor.black, )),
  Position.C8: IPiece(PieceId(
    pieceType: PieceType.bishop,
    pieceColor: PlayerColor.black, )),
  Position.B8: IPiece(PieceId(
    pieceType: PieceType.knight,
    pieceColor: PlayerColor.black, )),
  Position.A8: IPiece(PieceId(
    pieceType: PieceType.rook,
    pieceColor: PlayerColor.black, )),
  Position.H11: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.red, )),
  Position.G11: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.red, )),
  Position.F11: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.red, )),
  Position.E11: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.red, )),
  Position.I11: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.red, )),
  Position.J11: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.red, )),
  Position.K11: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.red, )),
  Position.L11: IPiece(PieceId(
    pieceType: PieceType.pawn,
    pieceColor: PlayerColor.red, )),
  Position.H12: IPiece(PieceId(
    pieceType: PieceType.rook,
    pieceColor: PlayerColor.red, )),
  Position.G12: IPiece(PieceId(
    pieceType: PieceType.knight,
    pieceColor: PlayerColor.red, )),
  Position.F12: IPiece(PieceId(
    pieceType: PieceType.bishop,
    pieceColor: PlayerColor.red, )),
  Position.E12: IPiece(PieceId(
    pieceType: PieceType.queen,
    pieceColor: PlayerColor.red, )),
  Position.I12: IPiece(PieceId(
    pieceType: PieceType.king,
    pieceColor: PlayerColor.red, )),
  Position.J12: IPiece(PieceId(
    pieceType: PieceType.bishop,
    pieceColor: PlayerColor.red, )),
  Position.K12: IPiece(PieceId(
    pieceType: PieceType.knight,
    pieceColor: PlayerColor.red, )),
  Position.L12: IPiece(PieceId(
    pieceType: PieceType.rook,
    pieceColor: PlayerColor.red, )),
}.lock;
