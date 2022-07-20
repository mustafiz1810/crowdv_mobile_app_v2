import 'package:intl/intl.dart';

class DateFormatedUtils{
  static String getFormatedDate(DateTime date, String dateFormat){
   // var formatter = new DateFormat('yyy-MM-dd');
    var formatter = new DateFormat(dateFormat);
    String formattedDate = formatter.format(date);
    return formattedDate;
  }


}