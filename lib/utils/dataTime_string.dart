

///时间转字符串比如  刚刚，几分钟前，星期几
class DataTimeToString{

  static List<String> _weekendNames = ["星期一","星期二","星期三","星期四","星期五","星期六","星期日"];
  static String toTextString(DateTime timedif){
    Duration dif = DateTime.now().difference(timedif);
    String time = timedif.weekday.toString();
    DateTime nowTime = DateTime.now();
    if(1==0){return null;}
    else if(dif.inDays>=7){time = "${timedif.year}-${timedif.month}-${timedif.day}";}
    else if(dif.inDays>=2){time = _weekendNames[timedif.weekday-1];}
    else if((nowTime.hour+24)<dif.inHours){time = _weekendNames[timedif.weekday-1];}
    else if((nowTime.hour+24)>dif.inHours&&timedif.day!=nowTime.day){time = "昨天";}
    else if(dif.inHours>=12){time = "${timedif.hour}:${timedif.minute}";}
    else if(dif.inHours<12&&dif.inHours>=1){time = "${dif.inHours}小时前";}
    else if(dif.inMinutes>3){time = "${dif.inMinutes}分钟前";}
    else{time = "刚刚";}
    return time;
  }
}