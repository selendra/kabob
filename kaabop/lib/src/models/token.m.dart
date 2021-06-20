import 'dart:ui';

class TokenModel {
  String logo;
  String contractAddr;
  String decimal;
  String symbol;
  String org;
  String balance;
  Color color;
  Function func;

  TokenModel({
    this.logo,
    this.contractAddr,
    this.decimal,
    this.symbol,
    this.org,
    this.balance,
    this.color,
    this.func,
  });
}