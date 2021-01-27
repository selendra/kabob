import 'package:polkawallet_sdk/polkawallet_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

class CreateAccModel {
  WalletSDK sdk;
  Keyring keyring;
  List mnemonicList;
  String mnemonic;

  String password;
}