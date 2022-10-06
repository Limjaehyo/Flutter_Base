import 'dart:async';
import 'dart:collection';
import 'package:core/network/response_status.dart';
import 'package:core/presentation/enums.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/06/13
/// Time: 11:25 오전
/// https://mings.in/retrofit.dart/ 참고
class NetworkDataHelper {
  final Logger _logger = Logger();
  final Rx<NetWorkState> _networkState = NetWorkState.Idle.obs;
  final List<NetWorkState> _tempProgressList = [];
  final Map<String, CancelToken> _cancelToken = HashMap();
  final Rxn<Function()> reLoginCallBackFunc = Rxn();

  _setState(NetWorkState state) {
    switch (state) {
      case NetWorkState.Idle:
        _networkState.value = state;
        break;
      case NetWorkState.Loading:
        _tempProgressList.add(state);
        _networkState.value = state;
        break;
      case NetWorkState.Completion:
      case NetWorkState.Error:
        final int index = _tempProgressList.indexOf(NetWorkState.Loading);
        _tempProgressList.removeAt(index);
        if (_tempProgressList.isEmpty) {
          _networkState.value = state;
        }
        break;
    }
  }

  cancelAll() {
    for (var element in _cancelToken.keys) {
      _cancelToken[element]!.cancel('cancel');
    }
  }

  reLoginErrorCallback(Function() reLogin){
    reLoginCallBackFunc.value = reLogin;
  }

  _removeCancelToken(String key) {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        _cancelToken.remove(key);
      },
    );
  }

  execute<T>(Future<T> Function(CancelToken ct) item, Function(T) data, {bool isOverLapCheck = true, bool isShowProgress = true, Function(String err)? error}) {
    _baseExecute(item, data: data, error: error, isShowProgress : isShowProgress, isOverLapCheck: isOverLapCheck);
  }

  /// ex) helper.syncExecute2<List<AccountInfoEntity>,List<PriceInfoEntity>,List<WalletModel>>((cancelToken) => _getInfo(), (cancelToken, item) {
  ///       StringBuffer sb = StringBuffer();
  ///       for (var element in item) {
  ///         if (element.tokenInfo.publicKey.isNotEmpty) {
  ///           sb.write('${element.tokenInfo.publicKey},');
  ///         }
  ///       }
  ///       return _getPriceInfo(sb.toString());
  ///     } , (item ,item2) {
  ///       log(item.toString());
  ///       log(item2.toString());
  ///     }
  ///     );
  syncExecute2<A, B>(Future<A> Function(CancelToken ct) item, Future<B> Function(CancelToken ct, A a) item2, Function(A a, B b) data2,
      {bool isOverLapCheck = true, bool isShowProgress = true, Function(String err)? error}) async {
    ///중복 호출 방지용
    _baseExecute(item, item2: item2, data2: data2, error: error, isShowProgress: isOverLapCheck, isOverLapCheck: isOverLapCheck);
  }

  syncExecute3<A, B, C>(Future<A> Function(CancelToken ct) item, Future<B> Function(CancelToken ct, A a) item2, Future<C> Function(CancelToken ct, A a, B b) item3, Function(A a, B b, C c) data3,
      {bool isOverLapCheck = true, bool isShowProgress = true, Function(String err)? error}) {
    _baseExecute(item, item2: item2, item3: item3, data3: data3, error: error, isShowProgress: isOverLapCheck, isOverLapCheck: isOverLapCheck);
  }

  /// ex)  helper.multiExecute((cancelToken) {
  ///     List<Future<dynamic>> temp = [];
  ///     temp.add(_getInfo());
  ///     temp.add(_getInfo());
  ///     return temp;
  ///     },(p0) async{
  ///     log(p0.toString());
  ///     },);
  multiExecute(List<Future<dynamic>> Function(CancelToken ct) item, Function(List<dynamic>) data, {bool isOverLapCheck = true, bool isShowProgress = true, Function(String err)? error}) async {
    ///중복 호출 방지용
    if (isOverLapCheck) {
      if (_hasCancelTokenRegister(item.runtimeType.toString())) {
        return;
      }
    }
    if (isShowProgress) {
      _setState(NetWorkState.Idle);
      _setState(NetWorkState.Loading);
    }
    var cancelToken = CancelToken();

    ///캔슬이 필요할경우 관리 등록
    if (item.runtimeType.toString().contains('CancelToken')) {
      _cancelToken[item.runtimeType.toString()] = cancelToken;
    }
    await Future.wait(item(cancelToken)).then((value) {
      _logger.log(Level.debug, value.toString());
      if (isShowProgress) {
        _setState(NetWorkState.Completion);
      }
      data(value);
    }).catchError((Object obj) {
      _logger.log(Level.error, obj.toString());
      if (isShowProgress) {
        _setState(NetWorkState.Error);
      }
      _removeCancelToken(item.runtimeType.toString());
      _errorHandler(_logger, obj, error: error);
    });
  }

  _baseExecute<A, B, C>(Future<A> Function(CancelToken ct) item,
      {Function(A)? data,
      bool isOverLapCheck = true,
      Future<B> Function(CancelToken ct, A a)? item2,
      Function(A a, B b)? data2,
      Future<C> Function(CancelToken ct, A a, B b)? item3,
      Function(A a, B b, C c)? data3,
      bool isShowProgress = true,
      Function(String err)? error}) async {
    ///중복 호출 방지용
    if (isOverLapCheck) {
      if (_hasCancelTokenRegister(item.runtimeType.toString())) {
        return;
      }
    }
    if (isShowProgress) {
      _setState(NetWorkState.Idle);
      _setState(NetWorkState.Loading);
    }
    try {
      var cancelToken = _cancelTokenRegister(item.runtimeType.toString());
      var tempItem = await item(cancelToken);
      _logger.log(Level.debug, tempItem);

      _removeCancelToken(item.runtimeType.toString());
      if (item2 == null) {
        if (isShowProgress) {
          _setState(NetWorkState.Completion);
        }
        if (data != null) {
          data(tempItem);
        }

        return;
      }
      cancelToken = _cancelTokenRegister(item2.runtimeType.toString());
      var temp2Item = await item2(cancelToken, tempItem);
      _logger.log(Level.debug, temp2Item);
      _removeCancelToken(item2.runtimeType.toString());
      if (item3 == null) {
        if (isShowProgress) {
          _setState(NetWorkState.Completion);
        }
        data2!(tempItem, temp2Item);
        return;
      }

      cancelToken = _cancelTokenRegister(item3.runtimeType.toString());
      var temp3Item = await item3(cancelToken, tempItem, temp2Item);
      _logger.log(Level.debug, temp3Item);
      data3!(tempItem, temp2Item, temp3Item);
      if (isShowProgress) {
        _setState(NetWorkState.Completion);
      }
      _removeCancelToken(item3.runtimeType.toString());
      _setState(NetWorkState.Completion);
    } catch (obj) {
      _logger.log(Level.error, obj.toString());
      if (isShowProgress) {
        _setState(NetWorkState.Error);
      }
      _removeCancelToken(item.runtimeType.toString());
      _errorHandler(_logger, obj, error: error);
    }
  }

  bool _hasCancelTokenRegister(String key) {
    return _cancelToken.containsKey(key);
  }

  CancelToken _cancelTokenRegister(String key) {
    var cancelToken = CancelToken();
    _cancelToken[key] = cancelToken;
    return cancelToken;
  }

  _errorHandler(Logger logger, Object obj, {Function(String err)? error}) {
    switch (obj.runtimeType) {
      case DioError:
        final res = (obj as DioError).response;
        _logger.log(Level.error, 'Got error : ${res?.statusCode} -> ${res?.statusMessage}');
        if (res?.statusCode == ResponseStatus.reLogin && res?.statusMessage == 'reLogin') {
          if (reLoginCallBackFunc.value != null) {
            reLoginCallBackFunc.value!.call();
          }
          return;
        }
        if (error != null) {
          if (res?.data is Map<String, dynamic>) {
            error(res?.data['errorMessage'] ??= res.statusMessage ?? 'UnknownError');
          } else {
            error(res?.statusMessage ?? 'UnknownError');
          }
        }
        break;
      default:
        break;
    }
  }
}

mixin NetworkState {
  final NetworkDataHelper _helper = NetworkDataHelper();

  Rx<NetWorkState> getNetWorkState() {
    return _helper._networkState;
  }

  NetworkDataHelper getNetworkDataHelper() {
    return _helper;
  }
}