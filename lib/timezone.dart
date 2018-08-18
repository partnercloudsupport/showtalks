library timezone;

class TimeZone {
  static Map<String,String> timezones = {
    "GMT": "UTC",
    "UTC": "UTC",
    "ECT": "UTC+1:00",
    "EET": "UTC+2:00",
    "ART": "UTC+2:00",
    "EAT": "UTC+3:00",
    "MET": "UTC+3:30",
    "NET": "UTC+4:00",
    "PLT": "UTC+5:00",
    "IST": "UTC+5:30",
    "BST": "UTC+6:00",
    "VST": "UTC+7:00",
    "CTT": "UTC+8:00",
    "JST": "UTC+9:00",
    "ACT": "UTC+9:30",
    "AET": "UTC+10:00",
    "SST": "UTC+11:00",
    "NST": "UTC+12:00",
    "MIT": "UTC-11:00",
    "HST": "UTC-10:00",
    "AST": "UTC-9:00",
    "PST": "UTC-8:00",
    "PNT": "UTC-7:00",
    "MST": "UTC-7:00",
    "CST": "UTC-6:00",
    "EST": "UTC-5:00",
    "EDT": "UTC-4:00",
    "IET": "UTC-5:00",
    "PRT": "UTC-4:00",
    "CNT": "UTC-3:30",
    "AGT": "UTC-3:00",
    "BET": "UTC-3:00",
    "CAT": "UTC-1:00",
  };

  static Duration _getOffset(String timeZoneAbbr){
    String offsetString = timezones[timeZoneAbbr];
    offsetString = offsetString?.substring(4,offsetString.length);
    var split = offsetString.split(":");
    int hours = int.tryParse(split[0]);
    int minutes = int.tryParse(split[1]);
    return new Duration(hours: hours,minutes: minutes);
  }
  ///Converts the given Time to the Time of the given TimeZone.
  static DateTime convert(DateTime time,String toTimeZoneAbbr){
    Duration toTimeOffset = _getOffset(toTimeZoneAbbr);
    DateTime utcConvert = time.toUtc();
    if(timezones[toTimeZoneAbbr].contains("+")){
      return utcConvert.add(toTimeOffset);
    }else if(timezones[toTimeZoneAbbr].contains("-")){
      return utcConvert.subtract(toTimeOffset);
    }else{
      return null;
    }
  }
  String getTimeZoneName(){
    return new DateTime.now().timeZoneName;
  }
  static String parseMonth(int number){
    switch (number){
      case 1 :
        return "Jan";
        break;
      case 2 :
        return "Feb";
        break;
      case 3 :
        return "March";
        break;
      case 4 :
        return "April";
        break;
      case 5 :
        return "May";
        break;
      case 6 :
        return "June";
        break;
      case 7 :
        return "July";
        break;
      case 8 :
        return "Aug";
        break;
      case 9 :
        return "Sept";
        break;
      case 10 :
        return "Oct";
        break;
      case 11 :
        return "Nov";
        break;
      case 12 :
        return "Dec";
        break;

        default:
          return "Invalid";

    }
  }

  static String parseToString(DateTime dateTime){
    DateTime today = new DateTime.now();
    String timezone = today.timeZoneName;
    DateTime convertedTime = convert(dateTime, timezone);
    if(convertedTime.day == today.day && convertedTime.month == today.month && convertedTime.year == today.year){
      return "Today";
    }else if(convertedTime.day == today.day+1 && convertedTime.month == today.month && convertedTime.year == today.year){
      return "Tommorow";
    }else {
      String date = dateTime.day.toString();
      String month = parseMonth(dateTime.month);
      String year = dateTime.year.toString();
      String s = "$date " + "$month " + "$year ";
      return s;
    }
  }
  static String parseAsTimeString(String timeStamp){
    DateTime time = DateTime.tryParse(timeStamp);
    String timeZone = new DateTime.now().timeZoneName;
    DateTime converted = convert(time, timeZone);
    return converted.hour.toString() + ":" + converted.minute.toString();
  }
  ///Get current time in the given Timezone.
  static DateTime getNow(String timeZoneAbbr){
    DateTime now = new DateTime.now();
    return convert(now, timeZoneAbbr);
  }
}
