import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'base_rest_client.g.dart';
/// app-flutter
/// Created by Lim JaeHyo 
/// Date: 2022/09/28
/// Time: 4:26 PM
///
@RestApi(baseUrl: "https://picsum.photos/")
abstract class BaseRestClient {
  factory BaseRestClient(Dio dio, {String baseUrl}) = _BaseRestClient;
}