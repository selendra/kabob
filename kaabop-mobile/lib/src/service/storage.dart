import 'package:wallet_apps/index.dart';
import 'package:wallet_apps/src/models/tx_history.dart';

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
      dynamic _data, String _path) async {
    List<Map<String, dynamic>> ls = [];
    _preferences = await SharedPreferences.getInstance();
    print(_preferences.containsKey(_path));
    if (_preferences.containsKey(_path)) {
      var _dataString = _preferences.getString(_path);
      print("Get string $_dataString");
      ls = List<Map<String, dynamic>>.from(jsonDecode(_dataString));
      ls.add(_data);
    } else {
      ls.add(_data);
    }

    print("Contact adding $ls");

    _decode = jsonEncode(ls);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<SharedPreferences> addTxHistory(
      TxHistory txHistory, String key) async {
    List<TxHistory> txHistoryList = [];
    _preferences = await SharedPreferences.getInstance();
    print(txHistory.symbol);

    await StorageServices.fetchData('txhistory').then((value) {
      print('My value $value');
      if (value != null) {
        for (var i in value) {
          print(i);
          txHistoryList.add(TxHistory(
            date: i['date'],
            symbol: i['symbol'],
            destination: i['destination'],
            sender: i['sender'],
            amount: i['amount'],
            org: i['fee'],
          ));
        }
        txHistoryList.add(txHistory);
        print('1 ${txHistory.symbol}');
      } else {
        txHistoryList.add(txHistory);
        print('2 ${txHistory.symbol}');
      }
    });

    print('3 ${txHistoryList[0].symbol}');

    for (var i in txHistoryList) {
      print(i.symbol);
    }

    await _preferences.setString(key, jsonEncode(txHistoryList));

    // print('finalList: ${txHistoryList.length}');
    // await _preferences.setString(key, jsonEncode(txHistoryList));
    // await _preferences.setString('test', 'test');

    // if (_preferences.containsKey(key)) {
    //   var data = _preferences.getString(key);
    //   txHistoryList = List<TxHistory>.from(jsonDecode(data));
    //   print('data: $data');
    //   txHistoryList.add(txHistory);
    //   print('added');
    // } else {
    //   txHistoryList.add(txHistory);
    //   print('added');
    // }

//    await setData(jsonEncode(txHistoryList), 'txhistory');

    return _preferences;
  }

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

    var _data = _preferences.getString(_path);
    print("Data $_data");
    if (_data == null)
      return null;
    else {
      return json.decode(_data);
    }
  }

  static Future<void> removeKey(String path) async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.remove(path);
  }

  static Future<String> fetchId(String _path) async {
    _preferences = await SharedPreferences.getInstance();
    _decode = jsonDecode(_preferences.getString(_path));
    return _decode;
  }
}
