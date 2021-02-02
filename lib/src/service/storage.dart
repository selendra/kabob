import 'package:wallet_apps/index.dart';

class StorageServices{

  static String _decode;
  static SharedPreferences _preferences;

  static Future<SharedPreferences> setData(dynamic _data, String _path) async {
    _preferences = await SharedPreferences.getInstance();
    _decode = jsonEncode(_data);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<SharedPreferences> addMoreData(dynamic _data, String _path) async {
    List<Map<String, dynamic>> ls = [];
    _preferences = await SharedPreferences.getInstance();
    print(_preferences.containsKey(_path));
    if(_preferences.containsKey(_path)){
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

  static Future<SharedPreferences> setUserID(String _data, String _path) async {
    _preferences = await SharedPreferences.getInstance();
    _decode = jsonEncode(_data);
    _preferences.setString(_path, _decode);
    return _preferences;
  }

  static Future<dynamic>fetchData(String _path) async {
    _preferences = await SharedPreferences.getInstance();
    
    var _data = _preferences.getString(_path);
    print("Data $_data");
    if ( _data == null ) return null;
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