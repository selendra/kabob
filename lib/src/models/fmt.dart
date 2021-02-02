import 'dart:math';

import 'package:intl/intl.dart';

class Fmt {
  static String doubleFormat(
    double value, {
    int length = 4,
    int round = 0,
  }) {
    if (value == null) {
      return '~';
    }
    NumberFormat f =
        NumberFormat(",##0${length > 0 ? '.' : ''}${'#' * length}", "en_US");
    return f.format(value);
  }

  static String balance(
    String raw,
    int decimals, {
    int length = 4,
  }) {
    if (raw == null || raw.length == 0) {
      return '~';
    }
    return doubleFormat(bigIntToDouble(balanceInt(raw), decimals),
        length: length);
  }

  static String token(
    BigInt value,
    int decimals, {
    int length = 4,
  }) {
    if (value == null) {
      return '~';
    }
    return doubleFormat(bigIntToDouble(value, decimals), length: length);
  }

  static BigInt balanceInt(String raw) {
    if (raw == null || raw.length == 0) {
      return BigInt.zero;
    }
    if (raw.contains(',') || raw.contains('.')) {
      return BigInt.from(NumberFormat(",##0.000").parse(raw));
    } else {
      return BigInt.parse(raw);
    }
  }

  static BigInt tokenInt(String value, int decimals) {
    if (value == null) {
      return BigInt.zero;
    }
    double v = 0;
    try {
      if (value.contains(',') || value.contains('.')) {
        v = NumberFormat(",##0.${"0" * decimals}").parse(value);
      } else {
        v = double.parse(value);
      }
    } catch (err) {
      print('Fmt.tokenInt() error: ${err.toString()}');
    }
    return BigInt.from(v * pow(10, decimals));
  }

  static double bigIntToDouble(BigInt value, int decimals) {
    if (value == null) {
      return 0;
    }
    return value / BigInt.from(pow(10, decimals));
  }

  ///

}
