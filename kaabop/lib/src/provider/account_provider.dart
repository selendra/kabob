import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/account.m.dart';

class AccountProvider with ChangeNotifier {
  final WalletSDK sdk;
  final Keyring keyring;
  AccountProvider({this.sdk, this.keyring});

  

}
