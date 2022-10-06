import 'package:core/network/network_data_helper.dart';
import 'package:core/presentation/back_callback.dart';
import 'package:core/presentation/base_view_mixin.dart';
import 'package:core/presentation/default_container.dart';
import 'package:core/presentation/manager/base_get_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/06/22
/// Time: 3:54 오후

abstract class BaseViewWidget<T extends GetxController> extends StatelessWidget with BaseViewMixin{
  final T? controller;
  final bool useDefaultContainer;
  final bool disableSafeArea;
  final Color? backgroundColor;

  BaseViewWidget({
    Key? key,
    this.controller,
    this.useDefaultContainer = true,
    this.disableSafeArea = false,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  Widget buildChildWidget(T? controller);

  //todo: 앱바 타이틀 필요시 오버라이딩 필요.
  @protected
  Widget buildAppbarTitleChild() {
    return const SizedBox();
  }

  //todo: 앱바 끝쪽 필요시 오버라이딩
  @protected
  Widget buildAppbarTrailingChild() {
    return const SizedBox();
  }
  //todo: back 버튼 콜백 필요시 오버라이딩
  @protected
  BackCallBack? setBackButtonCallBack(){
    return null;
  }

  //todo: 왼쪽 아이콘 히든 하고싶으면 오버라이딩
  @protected
  bool setIsLeadingShow({bool isLeadingShow = true}) {
    return isLeadingShow;
  }

  @override
  Widget build(BuildContext context) {
    _init(context);
    if (useDefaultContainer) {
      return DefaultContainer(
        isLeadingShow: setIsLeadingShow(),
        titleChild: setAppbarTitleChildWidget(controller),
        trailingChild: setAppbarTrailingChildWidget(controller),
        disableSafeArea: disableSafeArea,
        backgroundColor: backgroundColor,
        backButtonCallback: setBackButtonCallBack(),
        child: buildChildWidget(controller),
      );
    }
    return buildChildWidget(controller);
  }

  _init(BuildContext context) {
    setContext(context);
    setIsLeadingShow();
    if (controller != null) {
      Get.put(controller);
      ///컨트롤러가 NetworkDataHelper 변환이 가능 하면 바인딩
      if (controller is NetworkState) {
        setNetworkDataHelper(controller as NetworkState);
      }
      if (controller is BaseGetXController) {
        setEventMessage(controller as BaseGetXController);
      }
    }
  }

  @protected
  Widget setAppbarTitleChildWidget(T? controller) {
    return const SizedBox(
      height: 50,
    );
  }

  @protected
  Widget setAppbarTrailingChildWidget(T? controller) {
    return const SizedBox();
  }
}

abstract class BaseTabViewWidget<T extends GetxController> extends BaseViewWidget<T> {
  final int tabCount;

  BaseTabViewWidget({Key? key, required this.tabCount, T? controller, useDefaultContainer = true})
      : super(
          key: key,
          controller: controller,
          useDefaultContainer: useDefaultContainer,
        );

  @override
  Widget build(BuildContext context) {
    _init(context);

    if (useDefaultContainer) {
      return DefaultTabController(
        length: tabCount,
        child: DefaultContainer(
          isLeadingShow: setIsLeadingShow(),
          titleChild: setAppbarTitleChildWidget(controller),
          trailingChild: setAppbarTrailingChildWidget(controller),
          disableSafeArea: disableSafeArea,
          backgroundColor: backgroundColor,
          backButtonCallback: setBackButtonCallBack(),
          child: buildChildWidget(controller),
        ),
      );
    }
    return DefaultTabController(
      length: tabCount,
      child: buildChildWidget(controller),
    );
  }
}
