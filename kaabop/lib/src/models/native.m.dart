import 'package:wallet_apps/src/models/asset_m.dart';

class NativeM {
  String id;
  String chainDecimal;
  String symbol;
  String balance;
  String logo;
  String org;
  Market marketData;
  String marketPrice;
  String change24h;
  bool isContain;


  NativeM({
    this.id,
    this.chainDecimal,
    this.symbol,
    this.balance,
    this.logo,
    this.org,
    this.marketData,
    this.marketPrice,
    this.change24h,
    this.isContain,
  });
}
