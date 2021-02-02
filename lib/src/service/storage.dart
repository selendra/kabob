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
    if (_preferences.containsKey(_path)) {
      var _dataString = _preferences.getString(_path);
      ls = List<Map<String, dynamic>>.from(jsonDecode(_dataString));
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
    List<TxHistory> txHistoryList = [];
    _preferences = await SharedPreferences.getInstance();

    await StorageServices.fetchData('txhistory').then((value) {
      print('My value $value');
      if (value != null) {
        for (var i in value) {
          print(i);
          txHistoryList.add(TxHistory(
            date: i['date'],
            destination: i['destination'],
            sender: i['sender'],
            amount: i['amount'],
            fee: i['fee'],
          ));
        }
        txHistoryList.add(txHistory);
      } else {
        txHistoryList.add(txHistory);
      }

      //var responseJson = json.decode(value);
      //print(responseJson);
    });
    print('finalList: ${txHistoryList.length}');
    await _preferences.setString(key, jsonEncode(txHistoryList));
    await _preferences.setString('test', 'test');

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

  static Future<SharedPreferences> setUserID(String _data, String _path) async {
    _preferences = await SharedPreferences.getInstance();
    _decode = jsonEncode(_data);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<dynamic> fetchData(String _path) async {
    _preferences = await SharedPreferences.getInstance();
    var _data = _preferences.getString(_path);
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
