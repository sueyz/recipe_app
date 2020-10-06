import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe_app/src/constants/strings.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;
  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  int get list => _sharedPrefs.getInt(listCount) ?? 0;

  set list(int value) {
    _sharedPrefs.setInt(listCount, value);
  }

}

final sharedPrefs = SharedPrefs();