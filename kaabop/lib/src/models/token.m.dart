import 'dart:ui';

class TokenModel {
  String logo;
  String decimal;
  String symbol;
  String org;
  String balance;
  Color color;
  Function func;

  TokenModel({
    this.logo,
    this.decimal,
    this.symbol,
    this.org,
    this.balance,
    this.color,
    this.func,
  });
}