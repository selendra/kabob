import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/tx_history.dart';

// ignore: avoid_classes_with_only_static_members
class StorageServices {
  static String _decode;
  static SharedPreferences _preferences;

  static Future<SharedPreferences> setData(dynamic _data, String _path) async {
    _preferences = await SharedPreferences.getInstance();
    _decode = jsonEncode(_data);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<SharedPreferences> addMoreData(
      Map<String, dynamic> _data, String _path) async {
    List<Map<String, dynamic>> ls = [];
    _preferences = await SharedPreferences.getInstance();
    if (_preferences.containsKey(_path)) {
      final _dataString = _preferences.getString(_path);

      ls = List<Map<String, dynamic>>.from(jsonDecode(_dataString) as List);
      ls.add(_data);
    } else {
      ls.add(_data);
    }

    _decode = jsonEncode(ls);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<SharedPreferences> addTxHistory(
      TxHistory txHistory, String key) async {
    final List<TxHistory> txHistoryList = [];
    _preferences = await SharedPreferences.getInstance();

    await StorageServices.fetchData('txhistory').then((value) {
      //print('My value $value');
      if (value != null) {
        for (final i in value) {
          txHistoryList.add(TxHistory(
            date: i['date'].toString(),
            symbol: i['symbol'].toString(),
            destination: i['destination'].toString(),
            sender: i['sender'].toString(),
            amount: i['amount'].toString(),
            org: i['fee'].toString(),
          ));
        }
        txHistoryList.add(txHistory);
      } else {
        txHistoryList.add(txHistory);
      }
    });

    await _preferences.setString(key, jsonEncode(txHistoryList));

    return _preferences;
  }

  // ignore: avoid_positional_boolean_parameters
  static Future<void> saveBool(String key, bool value) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setBool(key, value);
  }

  static Future<bool> readBool(String key) async {
    _preferences = await SharedPreferences.getInstance();
    final res = _preferences.getBool(key);

    return res ?? false;
  }

  // ignore: avoid_positional_boolean_parameters
  static Future<void> saveBio(bool enable) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.setBool('bio', enable);
  }

  static Future<bool> readSaveBio() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences.getBool('bio') ?? false;
  }

  static Future<SharedPreferences> setUserID(String _data, String _path) async {
    _preferences = await SharedPreferences.getInstance();
    _decode = jsonEncode(_data);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<dynamic> fetchData(String _path) async {
    _preferences = await SharedPreferences.getInstance();

    final _data = _preferences.getString(_path);

    if (_data == null) {
      return null;
    } else {
      return json.decode(_data);
    }
  }

  static Future<void> removeKey(String path) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.remove(path);
  }
}
