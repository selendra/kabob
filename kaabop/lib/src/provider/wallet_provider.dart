import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../index.dart';

class WalletProvider with ChangeNotifier {
  final List<PortfolioM> _portfolioM = [];
  List<Map<String, String>> availableToken = [];

  List<String> listSymbol = ['SEL','DOT','BNB','ETH','SEL (BEP-20)','KGO (BEP-20)'];

  List<Color> pieColorList = const [
    Color(0xFFff7675),
    Color(0xFF74b9ff),
    Color(0xFF55efc4),
    Color(0xFFffeaa7),
    Color(0xFFa29bfe),
    Color(0xFFfd79a8),
    Color(0xFFe17055),
    Color(0xFF00b894),
  ];

  Map<String, double> dataMap = {};
  List<PortfolioM> get portfolio => _portfolioM;

  void setProfolio() {
    clearPortfolio();
    getPortfolio();
  }

  void addTokenSymbol(String symbol) {
    listSymbol.add(symbol);
    notifyListeners();
  }

  void removeTokenSymbol(String symbol) {
    listSymbol.remove(symbol);
    notifyListeners();
  }

  void addAvaibleToken(Map<String, String> token) {
    availableToken.add(token);
    notifyListeners();
  }

  void updateAvailableToken(Map<String, String> token) {
    for (int i = 0; i < availableToken.length; i++) {
      if (availableToken[i]['symbol'] == token['symbol']) {
        availableToken[i].update('balance', (value) => token['balance']);
      } else {
        addAvaibleToken(token);
      }
    }
    notifyListeners();
  }

  void removeAvailableToken(Map<String, String> token) {
    availableToken.remove(token);
    notifyListeners();
  }

  void setPortfolio(BuildContext context) {
    clearPortfolio();

    Provider.of<WalletProvider>(context, listen: false).getPortfolio();
  }

  void clearPortfolio() {
    availableToken.clear();
    _portfolioM.clear();
    notifyListeners();
  }

  Future<double> getTotal() async {
    double total = 0;

    for (int i = 0; i < availableToken.length; i++) {
      total = total + double.parse(availableToken[i]['balance']);
    }

    return total;
  }

  void resetDatamap() {
    dataMap.update('SEL', (value) => value = 100);
    dataMap.update('KMPI', (value) => value = 0);
    dataMap.update('ATD', (value) => value = 0);
    notifyListeners();
  }

  Future<void> getPortfolio() async {
    _portfolioM.clear();
    dataMap.clear();

    double temp = 0.0;

    await getTotal().then((total) {
      double percen = 0.0;

      for (int i = 0; i < availableToken.length; i++) {
        temp = double.parse(availableToken[i]['balance']) / total;

        if (total == 0.0) {
          _portfolioM.add(
            PortfolioM(
                color: pieColorList[i],
                symbol: availableToken[i]['symbol'],
                percentage: '0'),
          );
        } else {
          percen = temp * 100;

          _portfolioM.add(PortfolioM(
            color: pieColorList[i],
            symbol: availableToken[i]['symbol'],
            percentage: percen.toStringAsFixed(4),
          ));

          dataMap.addAll({
            availableToken[i]['symbol']: double.parse(percen.toStringAsFixed(4))
          });
        }
        notifyListeners();
      }
    });
  }
}
