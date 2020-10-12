import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;
  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  int getList(test) => _sharedPrefs.getInt(test) ?? 0;

  void list(test, int value) {
    _sharedPrefs.setInt(test, value);
  }

}

final sharedPrefs = SharedPrefs();