import 'package:core/presentation/back_callback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DefaultContainer extends StatelessWidget {
  final Widget child;
  final Widget titleChild;
  final bool isLeadingShow;
  final Widget? trailingChild;
  final bool disableSafeArea;
  final Color? backgroundColor;
  final BackCallBack? backButtonCallback;

  const DefaultContainer({
    Key? key,
    required this.child,
    this.titleChild = const SizedBox(),
    this.isLeadingShow = true,
    this.trailingChild,
    this.backgroundColor = Colors.white,
    this.disableSafeArea = false,
    this.backButtonCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: SizedBox(
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: Visibility(
                    visible: isLeadingShow,
                    child: InkWell(
                      borderRadius : const BorderRadius.all(Radius.circular(44)),
                      onTap: () async {
                        await backButtonCallback?.backCallBack();
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          fit: BoxFit.contain,
                          'assets/images/icons/icon_chevron_left_black.svg',
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              titleChild,
              Positioned(
                right: 15,
                child: trailingChild ?? Container(),
              )
            ],
          ),
        ),
      ),
      body: disableSafeArea
          ? Container(
              child: child,
            )
          : SafeArea(
              child: child,
            ),
    );
  }
}
