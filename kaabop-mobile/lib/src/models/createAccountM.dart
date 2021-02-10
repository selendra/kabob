import 'package:polkawallet_sdk/api/types/balanceData.dart';
import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/models/contract.m.dart';
import 'package:wallet_apps/src/models/user.m.dart';

class CreateAccModel {

  List mnemonicList;
  BalanceData balance;
  bool sdkReady = false;
  bool apiConnected = false;
  String mBalance = '';
  String msgChannel;
  String kpiSupply = '';
  String password;
  String mnemonic;

  WalletSDK sdk;
  Keyring keyring;
  ContractModel contractModel = ContractModel();
  UserModel userModel = UserModel();

  List<ContractModel> mContractModel = [];
  
}
