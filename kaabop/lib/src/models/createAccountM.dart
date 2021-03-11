import 'package:polkawallet_sdk/api/types/balanceData.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/models/contract.m.dart';
import 'package:wallet_apps/src/models/user.m.dart';

class CreateAccModel {
  List mnemonicList;
  BalanceData balance;
  bool sdkReady = false;
  bool apiConnected = false;
  bool dataReady = false;
  bool kmpiReady = false;
  bool atdReady = false;
  String nativeBalance = '0';
  String chainDecimal = '';
  String msgChannel;
  String kpiSupply = '';
  String password;
  String mnemonic;

  WalletSDK sdk;
  Keyring keyring;
  String nativeToken = 'assets/native_token.png';
  String nativeSymbol = 'SEL';
  String nativeOrg = 'SELENDRA';
  ContractModel contractModel = ContractModel();
  UserModel userModel = UserModel();
  List<String> asset = ['KMPI', 'ATD'];
}
