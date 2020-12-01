class DateUtil {
  static Duration durationSinceTime(Object time) {
    if (time == null || time == "") {
      return Duration(seconds: 0);
    }

    DateTime sinceTime;

    if (time is String) {
      sinceTime = DateTime.parse(time);
    } else {
      sinceTime = time as DateTime;
    }

    return DateTime.now().difference(sinceTime);
  }
}