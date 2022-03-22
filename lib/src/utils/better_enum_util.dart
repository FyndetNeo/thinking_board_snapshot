extension BetterEnumString on Enum {
  String get string => toString().split('.')[1];
}
