import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

Future<DateTime?> dateDialog(BuildContext context, DateTime minDateTime, DateTime focusedDate) {
  return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(children: [
          SizedBox(
              width: 200,
              child: TableCalendar(
                focusedDay: focusedDate,
                firstDay: minDateTime,
                lastDay: DateTime.now().add(const Duration(days: 700)),
                onDaySelected: (d1, d2) {
                  Navigator.pop(context, d1);
                },
              ))
        ]);
      });
}