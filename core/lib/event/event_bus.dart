import 'dart:async';
import 'dart:collection';

import 'package:rxdart/rxdart.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/06/27
/// Time: 1:32 오후
class RxEventBus {
  final ReplaySubject<dynamic> _replaySubject = ReplaySubject(sync: true);
  final PublishSubject<dynamic> _publishSubject = PublishSubject(sync: true);
  static RxEventBus? _instance;
  final Map<String, StreamSubscription> _map = HashMap();

  RxEventBus._();

  static RxEventBus getInstance() {
    return _instance ??= RxEventBus._();
  }

  void registerListener<E>(OnEventListener<E> listener) {
    StreamSubscription listen = _publishSubject.whereType<E>().listen((event) {
      listener.onEvent(event);
    });
    _map[listener.runtimeType.toString()] = listen;
  }

  void oneEventRegisterListener<E>(OnEventListener<E> listener) async {
    if (_map.containsKey(listener.runtimeType.toString())) {
      _map[listener.runtimeType.toString()]?.cancel();
      _map.remove(listener.runtimeType.toString());
    }

    final lastCount = _replaySubject.values.whereType<E>().length - 1;
    if(lastCount == -1){
      return;
    }
    final StreamSubscription listen = _replaySubject.whereType<E>().elementAt(lastCount).asStream().listen((event) {
      listener.onEvent(event);
      unRegisterListener(listener.runtimeType);
    });
    _map[listener.runtimeType.toString()] = listen;
  }

  void unRegisterListener(Type key) {
    _map[key.toString()]?.cancel();
    if (_map.containsKey(key.toString())) {
      _map.remove(key.toString());
    }
  }

  void postEvent(dynamic event, {Function(void)? callback}) {
    _publishSubject.sink.add(event);
    if (callback != null) {
      callback;
    }
  }

  void postOneEvent(dynamic event, {Function(void)? callback}) {
    _replaySubject.sink.add(event);
    if (callback != null) {
      callback;
    }
  }
}

abstract class OnEventListener<E> {
  void onEvent(E e);
}
