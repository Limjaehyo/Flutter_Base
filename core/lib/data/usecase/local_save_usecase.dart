
import 'package:core/data/repositories/local_repository.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/07/07
/// Time: 10:08 오전
///
class LocalSaveUseCase {
  final LocalRepository _localRepository = LocalRepository();

  void saveAccessToken({required String accessToken}) {
    _localRepository.sharedPrefSave(key: 'ACCESS_TOKEN', value: accessToken);
  }

  void saveRefreshToken({required String refreshToken}) {
    _localRepository.sharedPrefSave(key: 'REFRESH_TOKEN', value: refreshToken);
  }

  Future<String?> loadAccessToken() {
    return _localRepository.sharedPrefLoad(key: 'ACCESS_TOKEN');
  }
  Future<String?> loadRefreshToken() {
    return _localRepository.sharedPrefLoad(key: 'REFRESH_TOKEN');
  }

  void removeAllData() {
    _localRepository.sharedPrefRemove();
  }

  void removeData() {
    _localRepository.removeEntry('ACCESS_TOKEN');
    _localRepository.removeEntry('REFRESH_TOKEN');
  }
}
