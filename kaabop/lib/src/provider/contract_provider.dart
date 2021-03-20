import 'package:flutter/material.dart';
import 'package:polkawallet_sdk/kabob_sdk.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';
import 'package:wallet_apps/src/models/atd.dart';
import 'package:wallet_apps/src/models/kmpi.dart';
import 'package:wallet_apps/src/provider/api_provider.dart';
import '../../index.dart';

class ContractProvider with ChangeNotifier {
  ContractProvider({this.sdk1, this.keyring1});

  final WalletSDK sdk1;
  final Keyring keyring1;

  final WalletSDK sdk = ApiProvider.sdk;

  final Keyring keyring = ApiProvider.keyring;

  Atd atd = Atd();
  Kmpi kmpi = Kmpi();

  Future<void> initKmpi() async {
    kmpi.isContain = true;
    kmpi.logo = 'assets/koompi_white_logo.png';
    kmpi.symbol = 'KMPI';
    kmpi.org = 'KOOMPI';
    kmpi.balanceReady = false;

    await sdk.api.callContract();
    await fetchKmpiHash();
    fetchKmpiBalance();
    notifyListeners();
  }

  Future<void> fetchKmpiHash() async {
    final res =
        await sdk.api.getHashBySymbol(keyring.current.address, kmpi.symbol);
    kmpi.hash = res.toString();
  }

  Future<void> fetchKmpiBalance() async {
    final res = await sdk.api.balanceOfByPartition(
        keyring.current.address, keyring.current.address, kmpi.hash);
    kmpi.balance = BigInt.parse(res['output'].toString()).toString();
    kmpi.balanceReady = true;

    notifyListeners();
  }

  Future<void> initAtd() async {
    atd.isContain = true;
    atd.logo = 'assets/FingerPrint1.png';
    atd.symbol = 'ATD';
    atd.org = 'KOOMPI';
    atd.balanceReady = false;

    await sdk.api.initAttendant();
    notifyListeners();
  }

  Future<void> fetchAtdBalance() async {
    final res = await sdk.api.getAToken(keyring.current.address);
    atd.balance = BigInt.parse(res).toString();
    atd.balanceReady = true;

    notifyListeners();
  }

  Future<void> addToken(
    String symbol,
    BuildContext context,
  ) async {
    if (symbol == 'KMPI') {
      initKmpi().then((value) async {
        await StorageServices.saveBool(kmpi.symbol, true);
      });
    } else {
      initAtd().then((value) async {
        await StorageServices.saveBool(atd.symbol, true);
      });
    }
    Navigator.pushNamedAndRemoveUntil(
        context, Home.route, ModalRoute.withName('/'));
  }

  Future<void> removeToken(String symbol) async {
    if (symbol == 'KMPI') {
      kmpi.isContain = false;
      await StorageServices.removeKey('KMPI');
    } else {
      atd.isContain = false;
      await StorageServices.removeKey('ATD');
    }
    notifyListeners();
  }

  Future<void> getAStatus() async {
    final res = await sdk.api.getAStatus(keyring.keyPairs[0].address);
    atd.status = res;
    notifyListeners();
  }
}
