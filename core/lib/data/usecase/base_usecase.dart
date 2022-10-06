import 'dart:async';
import 'dart:collection';

import 'package:core/network/network_data_helper.dart';
import 'package:get/get.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/07/11
/// Time: 1:42 오후
abstract class BaseUseCase {
  final Rxn<NetworkDataHelper> _helper = Rxn();
  final Map<String, StreamSubscription> _streamSubscription = HashMap();
  final Queue<NotifyManager> _rxItems = Queue();
  setNetWorkDataHelper(NetworkDataHelper helper) {
    _helper.value = helper;
  }

  void addStreamSubscription(String registerKey, StreamSubscription subscription){
    if (_streamSubscription.containsKey(registerKey)) {
      _streamSubscription[registerKey]!.cancel();
    }
    _streamSubscription[registerKey] = subscription;
  }
  void addRxItems(List<NotifyManager> item){
    item.map((e) => _rxItems.add(e));
  }

  NetworkDataHelper getNetWorkHelper() {
    if (_helper.value == null) {
      throw Exception('NetworkDataHelper Not Setting');
    }
    return _helper.value!;
  }

  void onClose() {
    _helper.close();
    for (var element in _streamSubscription.values) {
      element.cancel();
    }
    for (var element in _rxItems) {
      if(!element.subject.isClosed){
        element.close();
      }
    }
    _streamSubscription.clear();
    _rxItems.clear();
  }
}
