import 'package:kcarv_front/models/event.dart';

String monthFinder(String number){
  switch(number){
      case '01': return "January";
      case '02': return "February";
      case '03': return "March";
      case '04': return "April";
      case '05': return "May";
      case '06': return "June";
      case '07': return "July";
      case '08': return "August";
      case '09': return "September";
      case '10': return "October";
      case '11': return "November";
      case '12': return "December";
      default: return "Invalid month";
    }
}

String formatter(Event event){
  return '${event.date.substring(8,10)} ${monthFinder(event.date.substring(5,7))} ${event.date.substring(0,4)}';
}