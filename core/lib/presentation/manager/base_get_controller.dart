import 'dart:async';
import 'dart:collection';

import 'package:core/data/usecase/base_usecase.dart';
import 'package:core/event/event_model.dart';
import 'package:core/network/network_data_helper.dart';
import 'package:core/presentation/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/06/24
/// Time: 10:50 오전
abstract class BaseGetXController extends GetxController with NetworkState  {
  final List<BaseUseCase> _useCases = [];
  final Rxn<StreamSubscription> _keyboardSubscription = Rxn();
  final Rxn<ScrollController> _listScrollController = Rxn();
  final Rx<ErrorMessageEvent> _errorEvent = Rx(ErrorMessageEvent(''));
  final Map<String, StreamSubscription> _streamSubscriptionMap = HashMap();
  final Queue<NotifyManager> _rxItems = Queue();

  List<BaseUseCase> creationUseCase();

  void registerKeyboardSubscription(StreamSubscription subscription){
    _keyboardSubscription.value = subscription;
  }

  void registerListScrollController(ScrollController scrollController){
    _listScrollController.value = scrollController;
  }
  void addRxItems(List<NotifyManager> item){
    item.map((e) => _rxItems.add(e));
  }

  ScrollController? getScrollController(){
    return _listScrollController.value;
  }

  void addStreamSubscription(String registerKey, StreamSubscription subscription){
    if (_streamSubscriptionMap.containsKey(registerKey)) {
      _streamSubscriptionMap[registerKey]!.cancel();
    }
    _streamSubscriptionMap[registerKey] = subscription;
  }

  sendErrorMessage(String message , {ErrorViewType type = ErrorViewType.confirm, String title = ''}){
    final ErrorMessageEvent event = ErrorMessageEvent(message ,type: type, title: title);
    _errorEvent.value = event;
  }

  Rx<ErrorMessageEvent> getErrorMessageEvent(){
    return _errorEvent;
  }

  @override
  void onInit() {
    super.onInit();
    _useCases.addAll(creationUseCase());
    for (var element in _useCases) {
      element.setNetWorkDataHelper(getNetworkDataHelper());
    }
    addRxItems([_errorEvent,]);
  }

  @override
  void onClose() {
    super.onClose();
    _keyboardSubscription.value?.cancel();
    _listScrollController.value?.dispose();
    getNetworkDataHelper().cancelAll();
    _streamSubscriptionMap.forEach((key, value) {
      value.cancel();
    });
    for (var element in _useCases) {element.onClose();}
    for (var element in _rxItems) {
      if(!element.subject.isClosed){
        element.close();
      }
    }
    _rxItems.clear();
    _useCases.clear();

  }

}
