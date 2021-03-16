import 'package:flutter/material.dart';
import '../../index.dart';

class WalletProvider with ChangeNotifier {
  final List<PortfolioM> _portfolioM = [];
  List<Map<String, String>> availableToken = [];

  List<Color> pieColorList = [
    hexaCodeToColor("#D65B09"),
    hexaCodeToColor(AppColors.secondary),
    hexaCodeToColor("#F0C90A"),
  ];

  Map<String, double> dataMap = {
    'SEL': 100.0,
    'KMPI': 0.0,
    'ATD': 0.0,
  };
  List<PortfolioM> get portfolio => _portfolioM;

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

    double temp = 0.0;

    await getTotal().then((total) {
      double percen = 0.0;
      for (int i = 0; i < availableToken.length; i++) {
        temp = double.parse(availableToken[i]['balance']) / total;

        if (total == 0.0) {
          _portfolioM.add(PortfolioM(
              color: pieColorList[i],
              symbol: availableToken[i]['symbol'],
              percentage: '0'));
        } else {
          if (availableToken[i]['symbol'] == 'SEL') {
            percen = temp * 100;
            _portfolioM.add(PortfolioM(
              color: pieColorList[0],
              symbol: 'SEL',
              percentage: percen.toStringAsFixed(4),
            ));
            dataMap.update('SEL',
                (value) => value = double.parse(percen.toStringAsFixed(4)));
          } else if (availableToken[i]['symbol'] == 'KMPI') {
            percen = temp * 100;
            _portfolioM.add(PortfolioM(
                color: pieColorList[1],
                symbol: 'KMPI',
                percentage: percen.toStringAsFixed(4)));
            dataMap.update('KMPI',
                (value) => value = double.parse(percen.toStringAsFixed(4)));
          } else if (availableToken[i]['symbol'] == 'ATD') {
            percen = temp * 100;
            _portfolioM.add(PortfolioM(
                color: pieColorList[2],
                symbol: 'ATD',
                percentage: percen.toStringAsFixed(4)));
            dataMap.update('ATD',
                (value) => value = double.parse(percen.toStringAsFixed(4)));
          }
        }
      }
    });

    notifyListeners();
  }
}
