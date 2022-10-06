import 'package:core/data/repositories/shared_pref.dart';
import 'package:core/data/usecase/local_save_usecase.dart';
import 'package:core/network/base_rest_client.dart';
import 'package:core/network/response_status.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/*
RestClient 객체 생성 클래스
* */
class APIClient {
  final bool needToken;
  final String? baseUrl;
  BaseRestClient? restClient;
  final Dio _dio = Dio();

  APIClient({this.needToken = true, this.baseUrl, this.restClient}) {
    restClient ??= baseUrl == null ? BaseRestClient(_dio) : BaseRestClient(_dio, baseUrl: baseUrl!);
  }

  BaseRestClient getApiClient({String refreshTokenUrl = ''}) {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) => response(e, handler),
      onRequest: (options, handler) => requestInterceptor(options, handler, needToken),
      onError: (error, handler) => onErrorInterceptor(error, handler, _dio,refreshTokenUrl: refreshTokenUrl),
    ));
    return restClient!;
  }

  response(Response e, ResponseInterceptorHandler handler) {
    // var logger = Logger();
    // logger.d(e.data);
    if (e.data is List<dynamic>) {
      List<dynamic> tempList = [];
      for (var element in (e.data as List<dynamic>)) {
        final Map<String, dynamic> temp = Map.of(element as Map<String, dynamic>);
        temp['statusCode'] = e.statusCode;
        tempList.add(temp);
      }
      e.data = tempList;
    }

    if (e.data is Map<String, dynamic>) {
      final Map<String, dynamic> temp = Map.of(e.data as Map<String, dynamic>);
      temp['statusCode'] = e.statusCode;
      e.data = temp;
    }
    handler.next(e);
  }

  requestInterceptor(RequestOptions options, RequestInterceptorHandler handler, bool needToken) async {
    var logger = Logger();
    final StringBuffer buffer = StringBuffer();
    buffer.write("--> ${options.method.toUpperCase()}");
    buffer.write(" ${options.baseUrl}${options.path}");

    if (needToken) {
      final accessToken = await SharedPref.getInstance().loadData('ACCESS_TOKEN');
      options.headers['Authorization'] = 'Bearer $accessToken';
      buffer.write("\n headers -> ${options.headers}");
    }
    buffer.write("\n queryParameters -> ${options.queryParameters}");
    buffer.write("\n params -> ${options.data}");
    logger.d(buffer.toString());
    handler.next(options);
  }

  onErrorInterceptor(DioError error, ErrorInterceptorHandler handler, Dio dio,{String refreshTokenUrl = ''}) async {
    var logger = Logger();

    logger.d("--> ${error.response?.statusCode} ${"${error.response?.statusMessage}"}");

    switch (error.response?.statusCode) {
      // AccessToken 만료
      case ResponseStatus.unauthorized:
        final LocalSaveUseCase localSaveUseCase = LocalSaveUseCase();
        final refreshToken = await localSaveUseCase.loadRefreshToken();
        // final refreshToken = SocialType.TEST.refreshToken;

        var refreshDio = Dio();
        /// 토큰 갱신 API 요청 시 AccessToken(만료), RefreshToken 포함
        refreshDio.options.headers['Authorization'] = 'Bearer $refreshToken';

        /// 토큰 갱신 API 요청
          final StringBuffer buffer = StringBuffer();
           refreshDio.post(refreshTokenUrl,data: {'clientId':'WALLET'}).then((value){
             final Map<String, dynamic> map = value.data;
             final newAccessToken = map['accessToken'];
             final newRefreshToken = map['refreshToken'];
             localSaveUseCase.saveAccessToken(accessToken: newAccessToken);
             localSaveUseCase.saveRefreshToken(refreshToken: newRefreshToken);
             /// AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
             error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

             /// 수행하지 못했던 API 요청 복사본 생성
             dio.request(error.requestOptions.baseUrl + error.requestOptions.path,
                 options: Options(method: error.requestOptions.method, headers: error.requestOptions.headers), data: error.requestOptions.data, queryParameters: error.requestOptions.queryParameters)
                 .then((value){
               return handler.resolve(value);
             },onError: (error){
               logger.log(Level.error, error.toString());
               if(error is DioError){
                 final res =(error).response;
                 buffer.clear();
                 buffer.write('원래 api 재요청 실패');
                 buffer.write('\n${res!.statusMessage}');
                 logger.log(Level.error, buffer.toString());
                 handler.next(error);
               }
             });
              ///요청 로그
             buffer.clear();
             buffer.write("dio 수행하지 못했던 API 요청 복사본 요청");
             buffer.write("\n--> ${error.requestOptions.method.toUpperCase()}");
             buffer.write('\n${error.requestOptions.baseUrl}${error.requestOptions.path}');
             buffer.write("\n headers -> ${error.requestOptions.headers}");
             buffer.write("\n queryParameters -> ${error.requestOptions.queryParameters}");
             buffer.write("\n params -> ${error.requestOptions.data}");
             logger.log(Level.error,buffer.toString());
             ///API 복사본으로 재요청

           },onError: (error){
             logger.log(Level.error, error.toString());
             if(error is DioError){
               final res =(error).response;
               buffer.clear();
               buffer.write('리플레쉬 토큰 갱신 에러');
               buffer.write('\n${res!.statusMessage}');
               logger.log(Level.error, buffer.toString());
             }
             error.response?.statusCode = ResponseStatus.reLogin;
             error.response?.statusMessage = "reLogin";
             handler.next(error);
           });
           ///refreshToken 토큰 로그
          buffer.clear();
          buffer.write("dio refreshToken 요청");
          buffer.write("\n--> ${refreshDio.options.method.toUpperCase()}");
          buffer.write('\n$refreshTokenUrl');
          buffer.write("\n headers -> ${refreshDio.options.headers}");
          buffer.write("\n queryParameters -> ${refreshDio.options.queryParameters}");
          buffer.write("\n params -> ${refreshDio.options.extra}");
          logger.log(Level.error,buffer.toString());
        return 'ok';
      default:
        return handler.next(error);
    }
  }
}
