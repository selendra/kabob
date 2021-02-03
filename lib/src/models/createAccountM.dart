import 'package:polkawallet_sdk/api/types/balanceData.dart';
import 'package:polkawallet_sdk/plugin/index.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class CreateAccModel {
  WalletSDK sdk;
  Keyring keyring;
  List mnemonicList;
  String mnemonic;

  String password;


  PolkawalletPlugin network;
  BalanceData balance;
  bool sdkReady = false;
  bool apiConnected = false;
  String mBalance = '0';
  String kpiBalance = '0';
  String msgChannel;
}