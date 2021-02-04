import 'package:polkawallet_sdk/api/types/balanceData.dart';

import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class CreateAccModel {
  WalletSDK sdk;
  Keyring keyring;
  List mnemonicList;
  String mnemonic;

  String password;

  BalanceData balance;
  bool sdkReady = false;
  bool apiConnected = false;
  String mBalance = '';
  String kpiBalance = '';
  String msgChannel;
  String kpiSupply = '';
}
