import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateFormatters {
  // Private constructor
  DateFormatters._privateConstructor();

  // Singleton instance variable
  static DateFormatters? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to DateFormatters.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static DateFormatters get instance {
    _instance ??= DateFormatters._privateConstructor();
    return _instance!;
  }

  //get date in mm/yyyy format
  String mmYYYYFormat({required DateTime date}) {
    String _formattedDate = DateFormat('MM/yyyy').format(date);
    return _formattedDate;
  }

  //get date in mm/yyyy format
  String formatStringDate({required String dateString}) {
    String _formattedDate = "";

    DateTime? date = convertStringIntoDateTime(dateString);

    if (date != null) {
      _formattedDate = DateFormat('dd-MM-yyyy').format(date);
    }

    return _formattedDate;
  }

  //method to get time ago
  //just pass the datetime object from which you want to get the time difference
  String getTimeAgo({required DateTime date}) {
    return timeago.format(date);
  }

  //method to get time difference in seconds (between two dateTime objects)
  int getTimeDifferenceInSec({required DateTime start, required DateTime end}) {
    Duration difference = end.difference(start);
    return difference.inSeconds;
  }

  //method to convert seconds into hours
  String convertSecondsToHours(double seconds) {
    double hours = seconds / 3600;
    return hours.toStringAsFixed(2);
  }

  //method to convert string into dateTime object
  DateTime? convertStringIntoDateTime(String dateString) {
    try {
      DateTime dateTime = DateTime.parse(dateString);

      return dateTime;
    } catch (e) {
      return null;
    }
  }
}
