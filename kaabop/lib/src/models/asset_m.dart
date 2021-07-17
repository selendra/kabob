import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModelAsset {
  bool enable = false;
  bool loading = false;
  bool match = false;
  bool added = false;

  String assetBalance = '0';
  static const String assetSymbol = 'KMPI';
  static const String assetOrganization = 'KOOMPI';

  String responseAssetCode;
  String responseIssuer;

  GlobalKey<FormState> formStateAsset = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> result;

  TextEditingController controllerAssetCode = TextEditingController();
  TextEditingController controllerIssuer = TextEditingController();

  FocusNode nodeAssetCode = FocusNode();
  FocusNode nodeIssuer = FocusNode();
}

class Market {
  Market({
    this.id,
    this.symbol,
    this.name,
    this.image,
    this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.fullyDilutedValuation,
    this.totalVolume,
    this.high24H,
    this.low24H,
    this.priceChange24H,
    this.priceChangePercentage24H,
    this.marketCapChange24H,
    this.marketCapChangePercentage24H,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    this.ath,
    this.athChangePercentage,
    this.athDate,
    this.atl,
    this.atlChangePercentage,
    this.atlDate,
    this.roi,
    this.lastUpdated,
  });

  String id;
  String symbol;
  String name;
  String image;
  String currentPrice;
  String marketCap;
  String marketCapRank;
  String fullyDilutedValuation;
  String totalVolume;
  String high24H;
  String low24H;
  String priceChange24H;
  String priceChangePercentage24H;
  String marketCapChange24H;
  String marketCapChangePercentage24H;
  String circulatingSupply;
  String totalSupply;
  String maxSupply;
  String ath;
  String athChangePercentage;
  DateTime athDate;
  String atl;
  String atlChangePercentage;
  DateTime atlDate;
  String roi;
  DateTime lastUpdated;

  factory Market.fromJson(Map<String, dynamic> json) => Market(
        id: json["id"].toString(),
        symbol: json["symbol"].toString(),
        name: json["name"].toString(),
        image: json["image"].toString(),
        currentPrice: json["current_price"].toString(),
        marketCap: json["market_cap"].toString(),
        marketCapRank: json["market_cap_rank"].toString(),
        fullyDilutedValuation: json["fully_diluted_valuation"].toString(),
        totalVolume: json["total_volume"].toString(),
        high24H: json["high_24h"].toString(),
        low24H: json["low_24h"].toString(),
        priceChange24H: json["price_change_24h"].toString(),
        priceChangePercentage24H:
            json["price_change_percentage_24h"].toString(),
        marketCapChange24H: json["market_cap_change_24h"].toString(),
        marketCapChangePercentage24H:
            json["market_cap_change_percentage_24h"].toString(),
        circulatingSupply: json["circulating_supply"].toString(),
        totalSupply: json["total_supply"].toString(),
        maxSupply: json["max_supply"].toString(),
        ath: json["ath"].toString(),
        athChangePercentage: json["ath_change_percentage"].toString(),
        athDate: DateTime.parse(json["ath_date"].toString()),
        atl: json["atl"].toString(),
        atlChangePercentage: json["atl_change_percentage"].toString(),
        atlDate: DateTime.parse(json["atl_date"].toString()),
        roi: json["roi"].toString(),
        lastUpdated: DateTime.parse(json["last_updated"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "name": name,
        "image": image,
        "current_price": currentPrice,
        "market_cap": marketCap,
        "market_cap_rank": marketCapRank,
        "fully_diluted_valuation": fullyDilutedValuation,
        "total_volume": totalVolume,
        "high_24h": high24H,
        "low_24h": low24H,
        "price_change_24h": priceChange24H,
        "price_change_percentage_24h": priceChangePercentage24H,
        "market_cap_change_24h": marketCapChange24H,
        "market_cap_change_percentage_24h": marketCapChangePercentage24H,
        "circulating_supply": circulatingSupply,
        "total_supply": totalSupply,
        "max_supply": maxSupply,
        "ath": ath,
        "ath_change_percentage": athChangePercentage,
        "ath_date": athDate.toIso8601String(),
        "atl": atl,
        "atl_change_percentage": atlChangePercentage,
        "atl_date": atlDate.toIso8601String(),
        "roi": roi,
        "last_updated": lastUpdated.toIso8601String(),
      };
}
