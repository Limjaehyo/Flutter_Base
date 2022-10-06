import 'package:core/data/repositories/shared_pref.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/07/07
/// Time: 10:10 오전
class LocalRepository {
  void sharedPrefSave({required String key, required value}) {
    SharedPref.getInstance().saveData(key, value);
  }

  Future<String?> sharedPrefLoad({required String key}) async {
    return await SharedPref.getInstance().loadData(key);
  }

  void sharedPrefRemove() async {
    SharedPref.getInstance().clearData();
  }

  void removeEntry(String key) {
    SharedPref.getInstance().removeEntry(key);
  }
}
