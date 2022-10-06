import 'package:flutter/material.dart';

/// app-flutter
/// Created by Lim JaeHyo 
/// Date: 2022/07/21
/// Time: 10:18 오전
class ErrorView {
  Widget defaultErrorBottomWidget(String message ,Function() confirm , Function() cancel, {String title = ''}){
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: title.isNotEmpty,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 133,
                child: MaterialButton(
                  onPressed: cancel,
                  height: 55,
                  elevation: 0,
                  color: const Color.fromARGB(255, 232, 232, 232),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: const Text('취소',
                      style: TextStyle(color: Color.fromARGB(255, 115, 115, 115),)
                  ),
                ),
              ),
              const Spacer(
                flex: 10,
              ),
              Expanded(
                flex: 202,
                child:
                MaterialButton(
                  onPressed: confirm,
                  height: 55,
                  elevation: 0,
                  color: Colors.black,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  child: const Text('확인',
                      style: TextStyle(color: Colors.white)
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  Widget singleErrorBottomWidget(String message ,Function() confirm, {String title = ''}){
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Visibility(
            visible: title.isNotEmpty,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.black, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          MaterialButton(
            onPressed: confirm,
            height: 55,
            elevation: 0,
            color: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: const Text('확인',
                style: TextStyle(color: Colors.white)
            ),
          ),
        ],
      ),
    );
  }
}