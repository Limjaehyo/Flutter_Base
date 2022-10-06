import 'package:core/presentation/enums.dart';

/// app-flutter
/// Created by Lim JaeHyo
/// Date: 2022/06/27
/// Time: 1:44 오후

class ErrorMessageEvent {
  final String message;
  final ErrorViewType type;
  final String title;

  ErrorMessageEvent(this.message, {this.type = ErrorViewType.normal, this.title = ''});
}
