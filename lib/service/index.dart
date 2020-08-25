import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:polkawallet_sdk/service/account.dart';
import 'package:polkawallet_sdk/service/keyring.dart';
import 'package:polkawallet_sdk/storage/localStorage.dart';

class SubstrateService {
  SubstrateService(this.storage);

  final KeyringStorage storage;

  ServiceKeyring keyring;
  ServiceAccount account;

  Map<String, Function> _msgHandlers = {};
  Map<String, Completer> _msgCompleters = {};
  FlutterWebviewPlugin _web;
  int _evalJavascriptUID = 0;

  bool _jsCodeUpdated = false;

  Function _connectFunc;

  /// preload js code for opening dApps
  String asExtensionJSCode;

  void init() {
    keyring = ServiceKeyring(this);
    account = ServiceAccount(this);

    launchWebview();

//    DefaultAssetBundle.of(context)
//        .loadString('lib/js_as_extension/dist/main.js')
//        .then((String js) {
//      print('asExtensionJSCode loaded');
//      asExtensionJSCode = js;
//    });
  }

//  Future<void> _checkJSCodeUpdate() async {
//    // check js code update
//    final network = store.settings.endpoint.info;
//    final jsVersion = await WalletApi.fetchPolkadotJSVersion(network);
//    final bool needUpdate =
//        await UI.checkJSCodeUpdate(context, jsVersion, network);
//    if (needUpdate) {
//      await UI.updateJSCode(context, jsStorage, network, jsVersion);
//    }
//  }

  void _startJSCode(String js) {
    // inject js file to webview
    _web.evalJavascript(js);

    // load keyPairs from local data
//    account.initAccounts();
    // connect remote node
//    _connectFunc();
  }

  Future<void> launchWebview({bool customNode = false}) async {
//    _msgHandlers = {'txStatusChange': store.account.setTxStatus};

    _evalJavascriptUID = 0;
    _msgCompleters = {};

//    _connectFunc = customNode ? connectNode : connectNodeAll;

//    await _checkJSCodeUpdate();
    if (_web != null) {
      _web.reload();
      return;
    }

    _web = FlutterWebviewPlugin();

    _web.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.finishLoad) {
        String network = 'kusama';
        print('webview loaded for network $network');
        rootBundle
            .loadString('packages/polkawallet_sdk/js_api/dist/main.js')
            .then((String js) {
          print('js file loaded');
          _startJSCode(js);
        });
      }
    });

    _web.launch(
      'about:blank',
      javascriptChannels: [
        JavascriptChannel(
            name: 'PolkaWallet',
            onMessageReceived: (JavascriptMessage message) {
              print('received msg: ${message.message}');
              compute(jsonDecode, message.message).then((msg) {
                final String path = msg['path'];
                if (_msgCompleters[path] != null) {
                  Completer handler = _msgCompleters[path];
                  handler.complete(msg['data']);
                  if (path.contains('uid=')) {
                    _msgCompleters.remove(path);
                  }
                }
                if (_msgHandlers[path] != null) {
                  Function handler = _msgHandlers[path];
                  handler(msg['data']);
                }
              });
            }),
      ].toSet(),
      ignoreSSLErrors: true,
//        withLocalUrl: true,
//        localUrlScope: 'lib/polkadot_js_service/dist/',
      hidden: true,
    );
  }

  int _getEvalJavascriptUID() {
    return _evalJavascriptUID++;
  }

  Future<dynamic> evalJavascript(
    String code, {
    bool wrapPromise = true,
    bool allowRepeat = false,
  }) async {
    // check if there's a same request loading
    if (!allowRepeat) {
      for (String i in _msgCompleters.keys) {
        String call = code.split('(')[0];
        if (i.contains(call)) {
          print('request $call loading');
          return _msgCompleters[i].future;
        }
      }
    }

    if (!wrapPromise) {
      String res = await _web.evalJavascript(code);
      return res;
    }

    Completer c = new Completer();

    String method = 'uid=${_getEvalJavascriptUID()};${code.split('(')[0]}';
    _msgCompleters[method] = c;

    String script = '$code.then(function(res) {'
        '  PolkaWallet.postMessage(JSON.stringify({ path: "$method", data: res }));'
        '}).catch(function(err) {'
        '  PolkaWallet.postMessage(JSON.stringify({ path: "log", data: err.message }));'
        '})';
    _web.evalJavascript(script);

    return c.future;
  }

//  Future<void> connectNode() async {
//    String node = store.settings.endpoint.value;
//    // do connect
//    String res = await evalJavascript('settings.connect("$node")');
//    if (res == null) {
//      print('connect failed');
//      store.settings.setNetworkName(null);
//      return;
//    }
//    fetchNetworkProps();
//  }
//
//  Future<void> connectNodeAll() async {
//    List<String> nodes =
//        store.settings.endpointList.map((e) => e.value).toList();
//    // do connect
//    String res =
//        await evalJavascript('settings.connectAll(${jsonEncode(nodes)})');
//    if (res == null) {
//      print('connect failed');
//      store.settings.setNetworkName(null);
//      return;
//    }
//    int index = store.settings.endpointList.indexWhere((i) => i.value == res);
//    if (index < 0) return;
//    store.settings.setEndpoint(store.settings.endpointList[index]);
//    fetchNetworkProps();
//  }
//
//  Future<void> fetchNetworkProps() async {
//    // fetch network info
//    List<dynamic> info = await Future.wait([
//      evalJavascript('settings.getNetworkConst()'),
//      evalJavascript('api.rpc.system.properties()'),
//      evalJavascript('api.rpc.system.chain()'),
//    ]);
//    store.settings.setNetworkConst(info[0]);
//    store.settings.setNetworkState(info[1]);
//    store.settings.setNetworkName(info[2]);
//
//    // fetch account balance
//    if (store.account.accountListAll.length > 0) {
//      if (store.settings.endpoint.info == networkEndpointAcala.info ||
//          store.settings.endpoint.info == networkEndpointLaminar.info) {
//        laminar.subscribeTokenPrices();
//        await assets.fetchBalance();
//        return;
//      }
//
//      await Future.wait([
//        assets.fetchBalance(),
//        staking.fetchAccountStaking(),
//        account.fetchAccountsBonded(
//            store.account.accountList.map((i) => i.pubKey).toList()),
//      ]);
//    }
//
//    // fetch staking overview data as initializing
//    staking.fetchStakingOverview();
//  }

  Future<void> subscribeBestNumber(Function callback) async {
    final String channel = "BestNumber";
    subscribeMessage(
        'settings.subscribeMessage("chain", "bestNumber", [], "$channel")',
        channel,
        callback);
  }

  Future<void> unsubscribeBestNumber() async {
    unsubscribeMessage('BestNumber');
  }

  Future<void> subscribeMessage(
    String code,
    String channel,
    Function callback,
  ) async {
    _msgHandlers[channel] = callback;
    evalJavascript(code, allowRepeat: true);
  }

  Future<void> unsubscribeMessage(String channel) async {
    _web.evalJavascript('unsub$channel()');
  }
}