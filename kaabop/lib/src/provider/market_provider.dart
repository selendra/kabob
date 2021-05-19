import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';

import '../../index.dart';

class MarketProvider {
  List<String> id = ['kiwigo', 'ethereum', 'binancecoin', 'polkadot'];

  Market parsePhotos(String responseBody) {
    Market data;
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    for (var i in parsed) {
      data = Market.fromJson(i as Map<String, dynamic>);
    }
    return data;
    //print(parsed);
  }

  Future<void> fetchTokenMarketPrice(BuildContext context) async {
    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);

    for (int i = 0; i < id.length; i++) {
      try {
        final response =
            await http.get('${AppConfig.coingeckoBaseUrl}${id[i]}');
        if (response.statusCode == 200) {
          final jsonResponse = convert.jsonDecode(response.body);

        

          final res = parsePhotos(response.body);

          //final market = Market.fromJson(jsonResponse);

          if (i == 0) {
            contract.setkiwigoMarket(
                res,
                jsonResponse[0]['current_price'].toString(),
                jsonResponse[0]['price_change_percentage_24h']
                    .toStringAsFixed(2)
                    .toString());
          } else if (i == 1) {
            contract.setEtherMarket(
                res,
                jsonResponse[0]['current_price'].toString(),
                jsonResponse[0]['price_change_percentage_24h']
                    .toStringAsFixed(2)
                    .toString());
          } else if (i == 2) {
            contract.setBnbMarket(
                res,
                jsonResponse[0]['current_price'].toString(),
                jsonResponse[0]['price_change_percentage_24h']
                    .toStringAsFixed(2)
                    .toString());
          } else if (i == 3) {
            contract.setReady();
            api.setDotMarket(
                res,
                jsonResponse[0]['current_price'].toString(),
                jsonResponse[0]['price_change_percentage_24h']
                    .toStringAsFixed(2)
                    .toString());
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
