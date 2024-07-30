import 'package:flutter/material.dart';

class AmityGeneralCompomemt {
  static void showOptionsBottomSheet(
      BuildContext context, List<Widget> listTiles) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: const EdgeInsetsDirectional.only(top: 20, bottom: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Wrap(
            children: listTiles,
          ),
        );
      },
    );
  }
}

class TimeAgoWidget extends StatelessWidget {
  final DateTime createdAt; // Assuming createdAt is a DateTime object
  final Color? textColor;

  const TimeAgoWidget({Key? key, required this.createdAt, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDate(createdAt),
      style: TextStyle(
        color: textColor ?? Colors.grey,
      ),
    );
  }

  String _formatDate(DateTime date) {
    DateTime localDate = date.toLocal();
    Duration difference = DateTime.now().difference(localDate);

    // Calculate the difference in weeks, months, and years
    int weeks = (difference.inDays / 7).floor();
    int months = (difference.inDays / 30).floor(); // Approximation
    int years = (difference.inDays / 365).floor(); // Approximation

    if (years > 0) {
      return '$years ${years > 1 ? 'من سنوات' : 'سنة'}'; //year
    } else if (months > 0) {
      return '$months ${months > 1 ? 'من الشهور' : 'شهر'}'; // month
    } else if (weeks > 0) {
      return '$weeks ${weeks > 1 ? 'من الأسابيع' : 'اسبوع'}'; //week
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays > 1 ? 'من الأيام' : 'يوم'}'; //day
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours > 1 ? 'من الساعات' : 'ساعة'}'; //hour
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes > 1 ? 'من الدقائق' : 'دقيقة'} '; //minute
    } else {
      return 'الآن'; //Just now
    }
  }
}
