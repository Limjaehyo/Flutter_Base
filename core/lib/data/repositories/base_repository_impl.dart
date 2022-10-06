import 'package:core/network/api_client.dart';
import 'package:core/network/base_rest_client.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/06/20
/// Time: 5:44 오후
abstract class BaseRepository {
  abstract String baseUrl;
  final Map<String, dynamic> queriesMap = {};

  BaseRestClient getAPIClient({bool needToken = true}) {
    return APIClient(needToken: needToken, baseUrl: baseUrl).getApiClient(refreshTokenUrl: '$baseUrl/api/sign-in/token');
  }
}
