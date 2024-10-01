// ignore: file_names
import 'package:intl/intl.dart';

class FormatedDateTime {
  static String formatedDateTime(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formatDate(DateTime date) => DateFormat("d MMM yyyy").format(date);
    return formatDate(date);
  }

  static String formatedTime(String dateString) {
    DateTime date = DateTime.parse(dateString).toLocal();
    String formatTime(DateTime date) => DateFormat("hh:mma").format(date);
    return formatTime(date);
  }



  static String formatedDateTimeNew(String dateString) {
    DateTime date = DateTime.parse(dateString).toLocal();
    String formatDay(DateTime date) => DateFormat("MMM-dd-yyyy h:mma").format(date);
    print("date.... ${formatDay(date)}");
    return formatDay(date);
  }

  static String formatedDateTimeTo(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formatDate(DateTime date) => DateFormat("MMM d yyyy").format(date);
    return formatDate(date);
  }
  static String formatedDateNotYear(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formatDate(DateTime date) => DateFormat("MMM d").format(date);
    return formatDate(date);
  }
}


class TimeAgo{
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate = DateFormat("dd-MM-yyyy h:mma").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} m ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 m ago' : 'A m ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} sec ago';
    } else {
      return 'Just now';
    }
  }

}
