// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../data/adjacent_tiles.dart';
import '../data/side_data.dart';
import '../data/tile_color_data.dart';
import '../utils/board_enums.dart';
import 'adjacent_tile.dart';

enum Position {
  A1,
  B1,
  C1,
  D1,
  E1,
  F1,
  G1,
  H1,
  A2,
  B2,
  C2,
  D2,
  E2,
  F2,
  G2,
  H2,
  A3,
  B3,
  C3,
  D3,
  E3,
  F3,
  G3,
  H3,
  A4,
  B4,
  C4,
  D4,
  E4,
  F4,
  G4,
  H4,
  A8,
  B8,
  C8,
  D8,
  I8,
  J8,
  K8,
  L8,
  A7,
  B7,
  C7,
  D7,
  I7,
  J7,
  K7,
  L7,
  A6,
  B6,
  C6,
  D6,
  I6,
  J6,
  K6,
  L6,
  A5,
  B5,
  C5,
  D5,
  I5,
  J5,
  K5,
  L5,
  L12,
  K12,
  J12,
  I12,
  E12,
  F12,
  G12,
  H12,
  L11,
  K11,
  J11,
  I11,
  E11,
  F11,
  G11,
  H11,
  L10,
  K10,
  J10,
  I10,
  E10,
  F10,
  G10,
  H10,
  L9,
  K9,
  J9,
  I9,
  E9,
  F9,
  G9,
  H9,
}

extension ITileExtension on Position {
   static Position fromString(String positionString){
     if (!validatePositionString(positionString)) {
       _invalidInputException();
     }
     return stringToPosition(positionString);
  }
   static Position fromAxes({required String letterAxis, required int numberAxis}) {
     if (!validatePosition(letterAxis, numberAxis)) {
       _invalidInputException();
     }
     return stringToPosition(letterAxis + numberAxis.toString());
   }

  String positionString() => toString().split('.')[1];

  int numberAxis() => int.parse(positionString().substring(1));

  String letterAxis() => positionString()[0];

  PlayerColor get side => boardSideTo(this);

  TileColor get color => tileColorOf(this);

  AdjacentPositions get adjacentTiles => adjacentPositionsTo(this);

   Position equalPosition(PlayerColor playerColor){
     if(side == playerColor){
       return this;
     }
     String newLetter = charCoordinatesOf(playerColor)[indexOfRow];
     String newNumber = numCoordinatesOf(playerColor)[indexOfRank].toString();
     return stringToPosition(newLetter+newNumber);
   }

   int get indexOfRank {
     return numCoordinatesOf(side).indexOf(numberAxis());
   }

   int get indexOfRow {
     return charCoordinatesOf(side).indexOf(letterAxis());
   }

   static _invalidInputException() {
     throw Exception('input Position invalid');
   }

   static bool validatePositionString(String position) {
     if (position.length < 2 || position.length > 3) {
       return false;
     }
     String letter = position[0];
     int? number = int.tryParse(position.substring(1));
     if (number == null) {
       return false;
     }
     if (!validatePosition(letter, number)) {
       return false;
     }
     return true;
   }

   static bool validatePosition(String letter, int number){
     if (!validateLetterBasic(letter)){
       return false;
     }
     bool check_A_D(int number) {
       if(number >= 1 && number <= 8){
         return true;
       }
       return false;
     }
     bool check_E_H(int number) {
       if((number >= 1 && number <= 4) || (number >= 9 && number <= 12)){
         return true;
       }
       return false;
     }
     bool check_I_L(int number) {
       if(number >= 8 && number <= 12){
         return true;
       }
       return false;
     }
     bool isLetterInBetween(String letter, String start, String end){
       if(letter.compareTo(start) >= 0 && letter.compareTo(end) <= 0){
         return true;
       }
       return false;
     }
     if(isLetterInBetween(letter, 'A', 'D')){
       return check_A_D(number);
     }
     if(isLetterInBetween(letter, 'E', 'H')){
       return check_E_H(number);
     }
     if(isLetterInBetween(letter, 'I', 'L')){
       return check_I_L(number);
     }
     return false;
   }

   static bool validateLetterBasic(String letter) {
     if (letter.length > 1 || letter.isEmpty) {
       return false;
     }
     if (letter.toLowerCase() == letter) {
       return false;
     }
     return true;
   }
}

IList<String> charCoordinatesOf(PlayerColor playerColor) {
  switch(playerColor){
    case PlayerColor.white:
      return IList(['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']);
    case PlayerColor.black:
      return IList(['L', 'K', 'J', 'I', 'D', 'C', 'B', 'A']);
    case PlayerColor.red:
      return IList(['H', 'G', 'F', 'E', 'I', 'J', 'K', 'L']);
  }
}

IList<int> numCoordinatesOf(PlayerColor playerColor) {
  switch(playerColor){
    case PlayerColor.white:
      return IList([1, 2, 3, 4]);
    case PlayerColor.black:
      return IList([8, 7, 6, 5]);
    case PlayerColor.red:
      return IList([12, 11, 10, 9]);
  }
}

Position stringToPosition(String string) {
  final position_candidate = _stringToPosition[string];
  if(position_candidate != null){
    return position_candidate;
  }
  throw Exception("Tried to parse invalid position string: $string");
}

const Map<String, Position> _stringToPosition = {
  'A1': Position.A1,
  'B1': Position.B1,
  'C1': Position.C1,
  'D1': Position.D1,
  'E1': Position.E1,
  'F1': Position.F1,
  'G1': Position.G1,
  'H1': Position.H1,
  'A2': Position.A2,
  'B2': Position.B2,
  'C2': Position.C2,
  'D2': Position.D2,
  'E2': Position.E2,
  'F2': Position.F2,
  'G2': Position.G2,
  'H2': Position.H2,
  'A3': Position.A3,
  'B3': Position.B3,
  'C3': Position.C3,
  'D3': Position.D3,
  'E3': Position.E3,
  'F3': Position.F3,
  'G3': Position.G3,
  'H3': Position.H3,
  'A4': Position.A4,
  'B4': Position.B4,
  'C4': Position.C4,
  'D4': Position.D4,
  'E4': Position.E4,
  'F4': Position.F4,
  'G4': Position.G4,
  'H4': Position.H4,
  'A8': Position.A8,
  'B8': Position.B8,
  'C8': Position.C8,
  'D8': Position.D8,
  'I8': Position.I8,
  'J8': Position.J8,
  'K8': Position.K8,
  'L8': Position.L8,
  'A7': Position.A7,
  'B7': Position.B7,
  'C7': Position.C7,
  'D7': Position.D7,
  'I7': Position.I7,
  'J7': Position.J7,
  'K7': Position.K7,
  'L7': Position.L7,
  'A6': Position.A6,
  'B6': Position.B6,
  'C6': Position.C6,
  'D6': Position.D6,
  'I6': Position.I6,
  'J6': Position.J6,
  'K6': Position.K6,
  'L6': Position.L6,
  'A5': Position.A5,
  'B5': Position.B5,
  'C5': Position.C5,
  'D5': Position.D5,
  'I5': Position.I5,
  'J5': Position.J5,
  'K5': Position.K5,
  'L5': Position.L5,
  'L12': Position.L12,
  'K12': Position.K12,
  'J12': Position.J12,
  'I12': Position.I12,
  'E12': Position.E12,
  'F12': Position.F12,
  'G12': Position.G12,
  'H12': Position.H12,
  'L11': Position.L11,
  'K11': Position.K11,
  'J11': Position.J11,
  'I11': Position.I11,
  'E11': Position.E11,
  'F11': Position.F11,
  'G11': Position.G11,
  'H11': Position.H11,
  'L10': Position.L10,
  'K10': Position.K10,
  'J10': Position.J10,
  'I10': Position.I10,
  'E10': Position.E10,
  'F10': Position.F10,
  'G10': Position.G10,
  'H10': Position.H10,
  'L9': Position.L9,
  'K9': Position.K9,
  'J9': Position.J9,
  'I9': Position.I9,
  'E9': Position.E9,
  'F9': Position.F9,
  'G9': Position.G9,
  'H9': Position.H9,
};
