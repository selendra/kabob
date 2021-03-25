import 'dart:convert';

import 'package:polkawallet_sdk/api/apiAccount.dart';
import 'package:polkawallet_sdk/api/apiGov.dart';
import 'package:polkawallet_sdk/api/apiKeyring.dart';
import 'package:polkawallet_sdk/api/apiRecovery.dart';
import 'package:polkawallet_sdk/api/apiSetting.dart';
import 'package:polkawallet_sdk/api/apiStaking.dart';
import 'package:polkawallet_sdk/api/apiTx.dart';
import 'package:polkawallet_sdk/api/apiUOS.dart';
import 'package:polkawallet_sdk/api/subscan.dart';
import 'package:polkawallet_sdk/api/types/networkParams.dart';
import 'package:polkawallet_sdk/service/index.dart';
import 'package:polkawallet_sdk/storage/keyring.dart';

/// The [KabobApi] instance is the wrapper of `polkadot-js/api`.
/// It provides:
/// * [ApiKeyring] of npm package [@polkadot/keyring](https://www.npmjs.com/package/@polkadot/keyring)
/// * [ApiSetting], the [networkConst] and [networkProperties] of `polkadot-js/api`.
/// * [ApiAccount], for querying on-chain data of accounts, like balances or indices.
/// * [ApiTx], sign and send tx.
/// * [ApiStaking] and [ApiGov], the staking and governance module of substrate.
/// * [ApiUOS], provides the offline-signature ability of polkawallet.
/// * [ApiRecovery], the social-recovery module of Kusama network.
class KabobApi {
  KabobApi(this.service);

  final SubstrateService service;

  NetworkParams _connectedNode;

  ApiKeyring keyring;
  ApiSetting setting;
  ApiAccount account;
  ApiTx tx;

  ApiStaking staking;
  ApiGov gov;
  ApiUOS uos;
  ApiRecovery recovery;

  final SubScanApi subScan = SubScanApi();

  void init() {
    keyring = ApiKeyring(this, service.keyring);
    setting = ApiSetting(this, service.setting);
    account = ApiAccount(this, service.account);
    tx = ApiTx(this, service.tx);

    staking = ApiStaking(this, service.staking);
    gov = ApiGov(this, service.gov);
    uos = ApiUOS(this, service.uos);
    recovery = ApiRecovery(this, service.recovery);
  }

  NetworkParams get connectedNode => _connectedNode;

  /// connect to a list of nodes, return null if connect failed.
  Future<NetworkParams> connectNode(
      Keyring keyringStorage, List<NetworkParams> nodes) async {
    _connectedNode = null;
    final NetworkParams res = await service.webView.connectNode(nodes);
    // print('api');
    if (res != null) {
      _connectedNode = res;

      // update indices of keyPairs after connect
      keyring.updateIndicesMap(keyringStorage);
    }
    return res;
  }

  Future<NetworkParams> connectNon(
      Keyring keyringStorage, List<NetworkParams> nodes) async {
    _connectedNode = null;
    final NetworkParams res = await service.webView.connectNon(nodes);

    if (res != null) {
      _connectedNode = res;

      // update indices of keyPairs after connect
      keyring.updateIndicesMap(keyringStorage);
    }
    return res;
  }

  Future<String> getPrivateKey(String mnemonic) async{
    final res = await service.webView.getPrivateKey(mnemonic);
    return res;
  }

  Future<List> getChainDecimal() async {
    final res = await service.webView.getChainDecimal();
    return res;
  }

  Future<String> callContract() async {
    final res = await service.webView.callContract();
    return res;
  }

  Future<String> initAttendant() async {
    final res = await service.webView.initAttendant();
    return res;
  }

  Future<String> getAToken(String attender) async {
    final res = await service.webView.getAToken(attender);
    return res;
  }

  Future<bool> getAStatus(String attender) async {
    final res = await service.webView.getAStatus(attender);
    return res;
  }

  Future<List> getCheckInList(String attender) async {
    final res = await service.webView.getCheckInList(attender);
    return res;
  }

  Future<List> getCheckOutList(String attender) async {
    final res = await service.webView.getCheckOutList(attender);
    return res;
  }

  Future<List> contractSymbol(String from) async {
    final res = await service.webView.contractSymbol(from);
    return res;
  }

  Future<dynamic> totalSupply(String from) async {
    final res = await service.webView.totalSupply(from);
    return res;
  }

  Future<dynamic> balanceOf(String from, String who) async {
    final res = await service.webView.balanceOf(who, from);
    return res;
  }

  Future<dynamic> balanceOfByPartition(
      String from, String who, String hash) async {
    final res = await service.webView.balanceOfByPartition(from, who, hash);
    return res;
  }

  Future<dynamic> getPartitionHash(String from) async {
    final res = await service.webView.getPartitionHash(from);

    return res;
  }

  Future<String> getHashBySymbol(String from, String symbol) async {
    final res = await service.webView.getHashBySymbol(from, symbol);
    return res;
  }

  Future<dynamic> allowance(String owner, String spender) async {
    final res = await service.webView.allowance(owner, spender);
    return res;
  }

  /// subscribe message.
  Future<void> subscribeMessage(
    String JSCall,
    List params,
    String channel,
    Function callback,
  ) async {
    service.webView.subscribeMessage(
      'settings.subscribeMessage($JSCall, ${jsonEncode(params)}, "$channel")',
      channel,
      callback,
    );
  }

  /// unsubscribe message.
  void unsubscribeMessage(String channel) {
    service.webView.unsubscribeMessage(channel);
  }
}
