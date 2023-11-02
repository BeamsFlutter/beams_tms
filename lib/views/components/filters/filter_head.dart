import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

import '../../pages/report/report.dart';

class FilterHead extends StatefulWidget {
  final List<FilterHeadItem> headList;
  final Map dataMap;

  const FilterHead({
    super.key,
    this.headList = const [],
    this.dataMap = const {},
  });

  @override
  createState() => _FilterHeadState();
}

class _FilterHeadState extends State<FilterHead> {
  bool showCheckList = false;

  @override
  initState() {
    super.initState();
  }

  @override
  build(context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: boxDecoration(Colors.white, 10),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  for (var f in widget.headList)
                    if (f.isActive)
                      Flexible(
                        flex: f.width,
                        child: Row(
                          children: [
                            Flexible(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  tc(f.title, color3, 12),
                                  Bounce(
                                    onPressed: () {},
                                    duration:
                                        const Duration(milliseconds: 110),
                                    child: const Icon(
                                      Icons.filter_alt_rounded,
                                      color: Colors.black,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            gapWC(15),
                          ],
                        ),
                      ),
                  Bounce(
                    onPressed: () {
                      showHeadCheckList();
                    },
                    duration: const Duration(milliseconds: 110),
                    child: const Icon(
                      Icons.checklist,
                      color: Colors.deepOrange,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showCheckList)
          InkWell(
            onTap: () {
              hideHeadCheckList();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 40),
              color: Colors.grey.shade500.withOpacity(0.1),
              child: Align(
                alignment: const AlignmentDirectional(1, -1),
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    width: 250,
                    height: 400,
                    decoration: boxDecoration(Colors.white, 5),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: defaultHeadList.length,
                            itemBuilder: (context, index) => Material(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    defaultHeadList[index].isActive =
                                        !defaultHeadList[index].isActive;
                                  });
                                },
                                child: Container(
                                  decoration: boxOutlineCustom(
                                      Colors.white, 0, Colors.grey.shade200),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 15,
                                          height: 15,
                                          decoration: boxOutlineCustom(
                                              defaultHeadList[index].isActive
                                                  ? color2
                                                  : Colors.white,
                                              5,
                                              defaultHeadList[index].isActive
                                                  ? color2
                                                  : Colors.grey.shade300),
                                          child: const Center(
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                        gapWC(5),
                                        tc(defaultHeadList[index].title,
                                            Colors.black, 14),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /*groupedView(List data, List groups, int level) {
    List<GroupingData> formattedData = [];
    for (var x in data) {
      formattedData.add(GroupingData.fromJson(x));
    }
    groupedData = [];
    if (groups.isNotEmpty) {
      for (var d in formattedData) {
        dynamic count = 0;
        double hr = 0.0;
        if (groupedData.isEmpty) {
          groupedData.add(d);
        } else {
          if (groupedData
              .where((element) =>
                  element.toJson()[groups[level]['key']] ==
                  d.toJson()[groups[level]['key']])
              .toList()
              .isEmpty) {
            groupedData.add(d);
          } else {
            List currData = formattedData
                .where((element) =>
                    element.toJson()[groups[level]['key']] ==
                    d.toJson()[groups[level]['key']])
                .toList();
            for (GroupingData x in currData) {
              count = count + x.count;
              hr = hr + x.timeHr;
            }
            groupedData
                .where((element) =>
                    element.toJson()[groups[level]['key']] ==
                    d.toJson()[groups[level]['key']])
                .first
                .count = count;
            groupedData
                .where((element) =>
                    element.toJson()[groups[level]['key']] ==
                    d.toJson()[groups[level]['key']])
                .first
                .timeHr = hr;
          }
        }
      }
      for (int i = 0; i < groupedData.length; i++) {
        _groupItemsVisible['$level+$i'] = false;
      }
    }

    return ListView.builder(
      itemCount: groupedData.length,
      itemBuilder: (context, index) {
        return groupItemBuilder(data, groupedData, level, index, groups);
      },
    );
  }*/

  groupItemBuilder(List ungroupedData, List<GroupingData> groupedData,
      int level, int index, List groups) {
    /*List<GroupingData> formattedData = [];
    for (var x in ungroupedData) {
      formattedData.add(GroupingData.fromJson(x));
    }
    groupedData = [];*/
    /*if (groups.isNotEmpty) {
      for (var d in formattedData) {
        dynamic count = 0;
        double hr = 0.0;
        if (groupedData.isEmpty) {
          groupedData.add(d);
        } else {
          if (groupedData
              .where((element) =>
                  element.toJson()[groups[level]['key']] ==
                  d.toJson()[groups[level]['key']])
              .toList()
              .isEmpty) {
            groupedData.add(d);
          } else {
            List currData = formattedData
                .where((element) =>
                    element.toJson()[groups[level]['key']] ==
                    d.toJson()[groups[level]['key']])
                .toList();
            for (GroupingData x in currData) {
              count = count + x.count;
              hr = hr + x.timeHr;
            }
            groupedData
                .where((element) =>
                    element.toJson()[groups[level]['key']] ==
                    d.toJson()[groups[level]['key']])
                .first
                .count = count;
            groupedData
                .where((element) =>
                    element.toJson()[groups[level]['key']] ==
                    d.toJson()[groups[level]['key']])
                .first
                .timeHr = hr;
          }
        }
      }
      */ /*for (int i = 0; i < groupedData.length; i++) {
        _groupItemsVisible['$level+$i'] = false;
      }*/ /*
    }*/
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: level * 30.0, top: 10),
          child: Row(
            children: [
              Expanded(
                child: Bounce(
                  onPressed: () {
                    groupItemTapped(groupedData, level, index);
                  },
                  duration: const Duration(milliseconds: 110),
                  child: Container(
                    decoration: boxDecoration(Colors.white, 10),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // _groupItemsVisible['$level+$index'] == true
                            groupedData[index].contentShown
                                ? const Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.arrow_right_outlined,
                                    color: Colors.black,
                                  ),
                            gapWC(15),
                            tcn(
                                groupedData
                                        .elementAt(index)
                                        .toJson()[groups[level]['key']] ??
                                    '',
                                Colors.black,
                                14),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            tcn('Count: ${groupedData.elementAt(index).toJson()['count']}',
                                Colors.black, 14),
                            gapWC(15),
                            tcn('Hour: ${groupedData.elementAt(index).toJson()['time_hr']}',
                                Colors.black, 14),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (groupedData.elementAt(index).contentShown &&
            level + 1 < groups.length)
          groupItemBuilder(
              ungroupedData, groupedData, level + 1, index, groups),
      ],
    );
  }

  groupItemTapped(groupedData, level, index) {
    setState(() {
      if (groupedData.elementAt(index).contentShown == true) {
        groupedData.elementAt(index).contentShown = false;
      } else {
        groupedData.elementAt(index).contentShown = true;
      }
      // if (_groupItemsVisible['$level+$index'] == true) {
      //   _groupItemsVisible['$level+$index'] = false;
      // } else {
      //   _groupItemsVisible['$level+$index'] = true;
      // }
      dprint(groupedData.elementAt(index).toJson());
      // dprint(_groupItemsVisible);
    });
  }

  showHeadCheckList() {
    setState(() {
      showCheckList = true;
    });
  }

  hideHeadCheckList() {
    setState(() {
      showCheckList = false;
    });
  }
}

List<GroupingData> groupedData = [];

Map _groupItemsVisible = {};

class FilterHeadItem {
  String key;
  String title;
  int width;
  bool isActive;

  FilterHeadItem({
    required this.key,
    required this.title,
    required this.width,
    required this.isActive,
  });
}

List<FilterHeadItem> defaultHeadList = [
  FilterHeadItem(
    key: '',
    title: 'Task',
    width: 4,
    isActive: true,
  ),
  FilterHeadItem(
    key: '',
    title: 'Issue',
    width: 1,
    isActive: true,
  ),
  FilterHeadItem(
    key: '',
    title: 'Company',
    width: 3,
    isActive: true,
  ),
  FilterHeadItem(
    key: 'module',
    title: 'Module',
    width: 2,
    isActive: true,
  ),
  FilterHeadItem(
    key: '',
    title: 'Department',
    width: 2,
    isActive: true,
  ),
  FilterHeadItem(
    key: '',
    title: 'Status',
    width: 2,
    isActive: true,
  ),
  FilterHeadItem(
    key: '',
    title: 'Create Date',
    width: 2,
    isActive: true,
  ),
  FilterHeadItem(
    key: '',
    title: 'Priority',
    width: 2,
    isActive: true,
  ),
  FilterHeadItem(
    key: '',
    title: 'Created By',
    width: 2,
    isActive: true,
  ),
  FilterHeadItem(
    key: 'time_hr',
    title: 'Hour',
    width: 1,
    isActive: true,
  ),
];
