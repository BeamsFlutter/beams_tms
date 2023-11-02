import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';

import '../../styles/colors.dart';
import '../common/common.dart';

class DatedFilter extends StatefulWidget {
  final List<Widget> otherFilters;
  final Function(DateTime, DateTime) filterFunction;
  final VoidCallback onClear;
  final VoidCallback onApply;
  final VoidCallback onDateChange;

  const DatedFilter({
    super.key,
    this.otherFilters = const [],
    required this.filterFunction,
    required this.onClear,
    required this.onApply,
    required this.onDateChange,
  });

  @override
  createState() => _DatedFilterState();
}

class _DatedFilterState extends State<DatedFilter> {
  DateMode ldmSelectedMode = DateMode.tw;

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  @override
  initState() {
    setState(() {
      ldmSelectedMode = DateMode.tw;
      fromDate =
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      toDate = DateTime.now()
          .add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday));
      widget.filterFunction(fromDate, toDate);
    });
    super.initState();
  }

  @override
  build(context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.filter_alt_outlined,
                  color: color3,
                  size: 20,
                ),
                gapWC(5),
                tc('Filters', color3, 14),
                gapWC(5),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_sharp,
              color: color3,
              size: 10,
            )
          ],
        ),
        gapHC(5),
        lineC(0.5, Colors.grey),
        gapHC(5),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ListView(
                  children: [
                    Wrap(
                      children: [
                        _wSelectModeButton('This Year', DateMode.ty),
                        _wSelectModeButton('This Month', DateMode.tm),
                        _wSelectModeButton('Last Month', DateMode.lm),
                        _wSelectModeButton('This Week', DateMode.tw),
                        _wSelectModeButton('Last Week', DateMode.lw),
                        _wSelectModeButton('Yesterday', DateMode.y),
                        _wSelectModeButton('Today', DateMode.t),
                        _wSelectModeButton('From-To', DateMode.ft),
                      ],
                    ),
                    gapHC(10),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Colors.black,
                        ),
                        gapWC(10),
                        Flexible(
                          child: Container(
                            decoration: boxDecoration(Colors.white, 12),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Bounce(
                                  duration: const Duration(milliseconds: 110),
                                  onPressed: () {
                                    _wSelectFromDate();
                                  },
                                  child: Text(
                                    setDate(6, fromDate),
                                    style: const TextStyle(
                                      color: buttonColor,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const Text('to'),
                                Bounce(
                                  duration: const Duration(milliseconds: 110),
                                  onPressed: () {
                                    _wSelectToDate();
                                  },
                                  child: Text(
                                    setDate(6, toDate),
                                    style: const TextStyle(
                                      color: buttonColor,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    /*gapHC(10),
                    Bounce(
                      duration: const Duration(milliseconds: 110),
                      onPressed: () {
                        _wSelectToDate();
                      },
                      child: Container(
                        decoration: boxDecoration(Colors.white, 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            ),
                            Text(
                              setDate(6, toDate),
                              style: const TextStyle(
                                color: buttonColor,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),*/
                    gapHC(20),
                    for (Widget w in widget.otherFilters) w,
                  ],
                ),
              ),
              /*Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  gapHC(10),
                  const SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Bounce(
                        //   onPressed: () {
                        //     _fnSetMode(DateMode.tw);
                        //     widget.onClear();
                        //   },
                        //   duration: const Duration(milliseconds: 110),
                        //   child: Container(
                        //     decoration: boxBaseDecoration(Colors.blueGrey.withOpacity(0.2), 20),
                        //     padding: const EdgeInsets.all(7),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         const Icon(
                        //           Icons.close,
                        //           color: Colors.black,
                        //           size: 14,
                        //         ),
                        //         gapWC(10),
                        //         tcn1('Clear', Colors.black, 14),
                        //         gapWC(5),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // gapHC(10),
                        // Bounce(
                        //   onPressed: () {
                        //     widget.filterFunction(fromDate, toDate);
                        //     widget.onApply();
                        //   },
                        //   duration: const Duration(milliseconds: 110),
                        //   child: Container(
                        //     decoration: boxBaseDecoration(Colors.green, 20),
                        //     padding: const EdgeInsets.all(7),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       children: [
                        //         const Icon(
                        //           Icons.check,
                        //           color: Colors.white,
                        //           size: 14,
                        //         ),
                        //         gapWC(10),
                        //         tcn1('Apply', Colors.white, 14),
                        //         gapWC(5),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  _wSelectModeButton(title, mode) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Bounce(
        onPressed: () {
          _fnSetMode(mode);
        },
        duration: const Duration(milliseconds: 110),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          /*decoration: boxBaseDecoration(
              ldmSelectedMode == mode ? Colors.orange : Colors.grey.shade300,
              10),*/
          decoration: ldmSelectedMode == mode
              ? boxGradientDecoration(7, 20)
              : boxBaseDecoration(Colors.grey.shade200, 20),
          child: Text(
            title,
            style: TextStyle(
              color: ldmSelectedMode == mode ? Colors.white : Colors.black,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  _fnSetMode(DateMode mode) {
    setState(() {
      ldmSelectedMode = mode;
    });
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

  Future<void> _wSelectFromDate() async {
    if (ldmSelectedMode != DateMode.ft) {
      return;
    }
    final DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now(),
        initialDate: fromDate);
    if (pickedDate != null && pickedDate != fromDate) {
      setState(() {
        fromDate = pickedDate;
      });
      dprint(fromDate);
    }
  }

  Future<void> _wSelectToDate() async {
    if (ldmSelectedMode != DateMode.ft) {
      return;
    }
    final DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2500, 8),
        initialDate: toDate);
    if (pickedDate != null && pickedDate != toDate) {
      setState(() {
        toDate = pickedDate;
      });
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
