import 'dart:async';

import 'package:core/event/event_model.dart';
import 'package:core/network/network_data_helper.dart';
import 'package:core/presentation/enums.dart';
import 'package:core/presentation/error_view_mixin.dart';
import 'package:core/presentation/manager/base_get_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/06/23
/// Time: 6:58 오후
mixin BaseViewMixin {
  final RxBool _isProgress = RxBool(false);
  final RxBool _isErrorProgress = RxBool(false);
  final Rxn<BuildContext> _context = Rxn<BuildContext>();
  final ErrorView _errorView = ErrorView();
  final Rxn<StreamSubscription> _errorSubscription = Rxn<StreamSubscription>();
  final Rxn<StreamSubscription> _netWorkStateSubscription = Rxn<StreamSubscription>();
  final Rxn<FToast> _fToast = Rxn<FToast>();

  baseViewMixinInit(BuildContext context, BaseGetXController controller) {
    setContext(context);
    setNetworkDataHelper(controller);
    setEventMessage(controller);
  }

  setContext(BuildContext context) {
    _context.value = context;

    _fToast.value = FToast().init(context);

    ///프로그래스바 설정
    _isProgress.listen((value) {
      value ? showProgressBarUI() : dismissProgressBarUI();
    });
  }

  RxBool getProgressValue() {
    return _isProgress;
  }

  RxBool getErrorProgress() {
    return _isErrorProgress;
  }

  setEventMessage(BaseGetXController controller) {
    _errorSubscription.value?.cancel();
    _errorSubscription.value = controller.getErrorMessageEvent().listen((event) {
      if (event.message.isNotEmpty) {
        showErrorMessage(event, _errorView);
      }
    });
  }

  ///network progress 바인딩 메소드
  setNetworkDataHelper(NetworkState state) {
    _netWorkStateSubscription.value?.cancel();
    _netWorkStateSubscription.value = state.getNetWorkState().listen((state) {
      switch (state) {
        case NetWorkState.Idle:
          _isErrorProgress.value = false;
          _isProgress.value = true;
          break;
        case NetWorkState.Completion:
          _isProgress.value = false;
          _isErrorProgress.value = false;
          break;
        case NetWorkState.Error:
          _isProgress.value = false;
          _isErrorProgress.value = true;
          break;
        case NetWorkState.Loading:
          _isProgress.value = true;
          _isErrorProgress.value = false;
          break;
      }
    });
  }

  BuildContext getContext() {
    return _context.value!;
  }

  void showProgressBar() {
    _isProgress.value = true;
  }

  void dismissProgressBar() {
    _isProgress.value = false;
  }

  void showProgressBarUI() {
    if (Get.isDialogOpen ?? false) return;
    Get.dialog(const Center(child: CircularProgressIndicator()), useSafeArea: true, barrierDismissible: false);
  }

  void dismissProgressBarUI() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void dismissBottom() {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }
  void toast({required String msg}){
   _fToast.value?.showToast(child: _showToast(msg));
  }

  Widget _showToast(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Text(msg,style: const TextStyle(color: Colors.white),),
    );
  }

  void showBottom({double? height, required Widget contentsWidget, bool isScrollControlled = true, bool isDismissible = false, bool enableDrag = true}) {

    Get.bottomSheet(
        Container(
          height: height,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: SafeArea(
            child: contentsWidget,
          ),
        ),
        isScrollControlled: isScrollControlled,
        isDismissible: isDismissible,
        enableDrag: enableDrag);
  }

  void showSnackBar({
    required String contentText,
    Duration duration = const Duration(seconds: 1),
    Duration animationDuration = const Duration(milliseconds: 200),
    double bottom = 100,
  }) {
    Get.showSnackbar(
      GetSnackBar(
          borderRadius: 50,
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.6),
          maxWidth: 300,
          margin: EdgeInsets.only(
            bottom: bottom,
          ),
          animationDuration: animationDuration,
          duration: duration,
          messageText: Text(
            contentText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              height: 1,
            ),
          )),
    );
  }

  void showErrorMessage(ErrorMessageEvent event, ErrorView view) {
    showBottom(height: _context.value!.size!.height * 0.35, contentsWidget: view.singleErrorBottomWidget(event.message, () => Get.back(), title: event.title));
  }
}
