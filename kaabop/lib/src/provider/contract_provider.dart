import 'package:flutter/material.dart';
import 'package:wallet_apps/src/provider/wallet_provider.dart';

class ContractProvider with ChangeNotifier {
  // String _kpiBalance = '';
  // final String _totalSupply = '';

  // String get kpiBalance => _kpiBalance;
  // String get totalSupply => _totalSupply;

  // Future<void> initContract() async {
  //   await WalletProvider().sdk.api.callContract();
  // }

  // Future<void> balanceOf(
  //   String from,
  //   String who,
  // ) async {
  //   final res = await WalletProvider().sdk.api.balanceOf(from, who);

  //   if (res != null) {
  //     _kpiBalance = BigInt.parse(res['output'].toString()).toString();
  //   } else {
  //    // print('res null');
  //   }

  //   notifyListeners();
  // }
}
