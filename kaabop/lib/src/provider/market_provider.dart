import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';

import '../../index.dart';

class MarketProvider {
  List<String> id = [
    'kiwigo',
    'ethereum',
    'binancecoin',
    'polkadot',
    'bitcoin'
  ];

  Market parsePhotos(String responseBody) {
    Market data;
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    for (var i in parsed) {
      data = Market.fromJson(i as Map<String, dynamic>);
    }
    return data;
    //print(parsed);
  }

  Future<List<List<double>>> fetchLineChartData(String id) async {
    List<List<double>> prices;
    final res = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=usd&days=1'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      //print(data);

      CryptoData mData = CryptoData.fromJson(data);

      prices = mData.prices;

      //print(mData.marketCaps.first);
    }

    return prices ?? null;
  }

  Future<void> fetchTokenMarketPrice(BuildContext context) async {
    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);

    for (int i = 0; i < id.length; i++) {
      try {
        final response =
            await http.get('${AppConfig.coingeckoBaseUrl}${id[i]}');
        final lineChartData = await fetchLineChartData(id[i]);

        if (response.statusCode == 200) {
          final jsonResponse = convert.jsonDecode(response.body);

          final res = parsePhotos(response.body);

          //final market = Market.fromJson(jsonResponse);

          if (i == 0) {
            contract.setkiwigoMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 1) {
            contract.setEtherMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 2) {
            contract.setBnbMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 3) {
            api.setDotMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
          } else if (i == 4) {
            api.setBtcMarket(
              res,
              lineChartData,
              jsonResponse[0]['current_price'].toString(),
              jsonResponse[0]['price_change_percentage_24h']
                  .toStringAsFixed(2)
                  .toString(),
            );
            contract.setReady();
          }
        } else {
          contract.setReady();
        }
      } catch (e) {
        contract.setReady();
      }
    }
  }
}
