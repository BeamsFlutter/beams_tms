import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';

import '../../styles/colors.dart';
import '../common/common.dart';

class DateFilter extends StatefulWidget {
  final Function(DateTime, DateTime) filterFunction;

  const DateFilter({
    super.key,
    required this.filterFunction,
  });

  @override
  createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  DateMode ldmSelectedMode = DateMode.tw;

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  @override
  build(context) {
    return Column(
      children: [
        Wrap(
          children: [
            wSelectModeButton('THIS YEAR', DateMode.ty),
            wSelectModeButton('THIS MONTH', DateMode.tm),
            wSelectModeButton('LAST MONTH', DateMode.lm),
            wSelectModeButton('THIS WEEK', DateMode.tw),
            wSelectModeButton('LAST WEEK', DateMode.lw),
            wSelectModeButton('YESTERDAY', DateMode.y),
            wSelectModeButton('TODAY', DateMode.t),
            wSelectModeButton('FROM-TO', DateMode.ft),
          ],
        ),
        gapHC(10),
        Bounce(
          duration: const Duration(milliseconds: 110),
          onPressed: () {
            wSelectFromDate();
          },
          child: Container(
            decoration: boxDecoration(Colors.white, 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Colors.black,
                ),
                Text(
                  setDate(17, fromDate),
                  style: const TextStyle(
                    color: buttonColor,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        gapHC(10),
        Bounce(
          duration: const Duration(milliseconds: 110),
          onPressed: () {
            wSelectToDate();
          },
          child: Container(
            decoration: boxDecoration(Colors.white, 12),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Colors.black,
                ),
                Text(
                  setDate(17, toDate),
                  style: const TextStyle(
                    color: buttonColor,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        gapHC(10),
      ],
    );
  }

  wSelectModeButton(title, mode) {
    return Bounce(
      onPressed: () {
        fnSetMode(mode);
      },
      duration: const Duration(milliseconds: 110),
      child: Container(
        decoration: boxBaseDecoration(
            ldmSelectedMode == mode
                ? color1.withOpacity(0.8)
                : Colors.grey.shade300,
            10),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: ldmSelectedMode == mode ? Colors.white : Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  fnSetMode(DateMode mode) {
    ldmSelectedMode = mode;
    DateTime now = DateTime.now();
    switch (mode) {
      case DateMode.ty:
        fromDate = DateTime(now.year);
        toDate = DateTime(now.year, 12, 31);
        widget.filterFunction(fromDate, toDate);
        break;
      case DateMode.tm:
        fromDate = DateTime(now.year, now.month);
        toDate = DateTime(now.year, now.month + 1, 0);
        widget.filterFunction(fromDate, toDate);
        break;
      case DateMode.lm:
        fromDate = DateTime(now.year, now.month - 1);
        toDate = DateTime(now.year, now.month, 0);
        widget.filterFunction(fromDate, toDate);
        break;
      case DateMode.tw:
        fromDate = now.subtract(Duration(days: now.weekday - 1));
        toDate = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
        widget.filterFunction(fromDate, toDate);
        break;
      case DateMode.lw:
        now = now.subtract(const Duration(days: DateTime.daysPerWeek));
        fromDate = now.subtract(Duration(days: now.weekday - 1));
        toDate = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
        widget.filterFunction(fromDate, toDate);
        break;
      case DateMode.y:
        fromDate = DateTime.now().subtract(const Duration(days: 1));
        toDate = DateTime.now().subtract(const Duration(days: 1));
        widget.filterFunction(fromDate, toDate);
        break;
      case DateMode.t:
        fromDate = DateTime.now();
        toDate = DateTime.now();
        widget.filterFunction(fromDate, toDate);
        break;
      case DateMode.ft:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> wSelectFromDate() async {
    if (ldmSelectedMode != DateMode.ft) {
      return;
    }
    final DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now(),
        initialDate: fromDate);
    if (pickedDate != null && pickedDate != fromDate) {
      fromDate = pickedDate;
      dprint(fromDate);
    }
  }

  Future<void> wSelectToDate() async {
    if (ldmSelectedMode != DateMode.ft) {
      return;
    }
    final DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2500, 8),
        initialDate: toDate);
    if (pickedDate != null && pickedDate != toDate) {
      toDate = pickedDate;
      dprint(toDate);
    }
  }
}

enum DateMode {
  ty,
  tm,
  lm,
  tw,
  lw,
  y,
  t,
  ft,
}
