import 'package:polkawallet_sdk/api/types/balanceData.dart';

import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/models/contract.m.dart';

class CreateAccModel {
  WalletSDK sdk;
  Keyring keyring;

  List<ContractModel> mContractModel = [];
  ContractModel contractModel = ContractModel();

  List mnemonicList;
  String mnemonic;

  String password;

  BalanceData balance;
  bool sdkReady = false;
  bool apiConnected = false;
  String mBalance = '';
  String msgChannel;
  String kpiSupply = '';
}
