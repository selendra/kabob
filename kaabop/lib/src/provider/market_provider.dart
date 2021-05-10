import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wallet_apps/src/provider/contract_provider.dart';

import '../../index.dart';

class MarketProvider {
  List<String> id = ['kiwigo', 'ethereum', 'binancecoin', 'polkadot'];

  Future<void> fetchTokenMarketPrice(BuildContext context) async {
    final contract = Provider.of<ContractProvider>(context, listen: false);
    final api = Provider.of<ApiProvider>(context, listen: false);
    for (int i = 0; i < id.length; i++) {
      try {
        final response =
            await http.get('${AppConfig.coingeckoBaseUrl}${id[i]}');
        if (response.statusCode == 200) {
          final jsonResponse = convert.jsonDecode(response.body);

          if (i == 0) {
            contract.setkiwigoMarket(
                jsonResponse[0]['current_price'].toString(),
                jsonResponse[0]['price_change_percentage_24h']
                    .toStringAsFixed(2)
                    .toString());
          } else if (i == 1) {
            contract.setEtherMarket(
                jsonResponse[0]['current_price'].toString(),
                jsonResponse[0]['price_change_percentage_24h']
                    .toStringAsFixed(2)
                    .toString());
          } else if (i == 2) {
            contract.setBnbMarket(
                jsonResponse[0]['current_price'].toString(),
                jsonResponse[0]['price_change_percentage_24h']
                    .toStringAsFixed(2)
                    .toString());
          } else if (i == 3) {
            contract.setReady();
            api.setDotMarket(
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
