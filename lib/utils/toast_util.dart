import 'package:toast/toast.dart';

class ToastUtil {
  static void show(msg, context) {
    if (context != null && msg != null && msg != 'null' && msg != '') {
      Toast.show(msg, context);
    }
  }
}