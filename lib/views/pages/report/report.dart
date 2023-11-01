import 'package:bams_tms/views/components/filters/dated_filter.dart';
import 'package:bams_tms/views/components/filters/filter_head.dart';
import 'package:bams_tms/views/pages/users/usershome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/common/common.dart';
import '../../styles/colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  var sideNavigation = "";
  String title = 'User Report';
  String lstrSelectedMode = '';

  int reportsTypeCount = 0;

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  DateTime now = DateTime.now();

  var lResultList = [];

  var blSideScreen = true;

  @override
  void initState() {
    fnPageLoad();
    super.initState();
  }

  @override
  void dispose() {
    _selectedGroupByItems = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      endDrawer: Container(
        width: 350,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
      body: Container(
        //color: greyLight.withOpacity(0.5),
        //decoration: boxImageDecoration("assets/images/bg.png", 0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  wLeftSideBar(),
                  wCenterSection(),
                  blSideScreen ? gapWC(0) : wRightFilterSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wLeftSideBar() {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 10),
      decoration: boxBaseDecoration(Colors.black, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(),
          Row(
            children: [
              Bounce(
                duration: const Duration(milliseconds: 110),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const UserHome(),
                    ),
                  );
                },
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  // decoration: boxGradientDecoration(22, 15),
                  decoration: boxBaseDecoration(Colors.white, 15),
                  padding: const EdgeInsets.all(0),
                  // child: tc('TM', Colors.white, 15),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
              ),
              gapWC(10),
              tcn('Reports', Colors.white, 18),
            ],
          ),
          gapHC(20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  wMenuCard(Icons.sticky_note_2_outlined, "User Report", "U"),
                  wMenuCard(Icons.sticky_note_2_outlined, "Client Report", "C"),
                ],
              ),
            ),
          ),
          Bounce(
            onPressed: () {
              Get.offAll(() => const UserHome());
            },
            duration: const Duration(milliseconds: 110),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: boxOutlineCustom1(
                  Colors.black,
                  25,
                  Colors.white,
                  0.5,
                ),
                child: const Center(
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget wCenterSection() {
    return Flexible(
      flex: 8,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(),
            Container(
              decoration: boxDecoration(Colors.white, 10),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      tc(title, Colors.deepOrange, 15),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              blSideScreen = blSideScreen ? false : true;
                            });
                          }
                        },
                        child: Icon(
                          blSideScreen
                              ? Icons.filter_alt_rounded
                              : Icons.filter_alt_off_rounded,
                          color: Colors.deepOrange,
                          size: 20,
                        ),
                      ),
                      // TODO Export and Clear Here
                      gapWC(10),
                      Bounce(
                        onPressed: () {
                          //fnExport();
                          // apiGetTaskExport();
                          //fnShowNotification("msg");
                        },
                        duration: const Duration(milliseconds: 110),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          decoration: boxGradientDecorationBase(6, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.download,
                                color: Colors.white,
                                size: 12,
                              ),
                              gapWC(5),
                              tcn1('Export', Colors.white, 12),
                            ],
                          ),
                        ),
                      ),
                      gapWC(10),
                      Bounce(
                        onPressed: () {
                          // fnFilterClear();
                          // apiGetTask("");
                        },
                        duration: const Duration(milliseconds: 110),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          decoration: boxOutlineCustom1(
                              Colors.white, 30, Colors.black, 0.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.clear_all_outlined,
                                color: Colors.black,
                                size: 12,
                              ),
                              gapWC(5),
                              tcn1('Clear', Colors.black, 12),
                            ],
                          ),
                        ),
                      ),
                      gapWC(10),
                    ],
                  ),
                  if (_selectedGroupByItems.isNotEmpty) gapHC(10),
                  if (_selectedGroupByItems.isNotEmpty)
                    Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                  if (_selectedGroupByItems.isNotEmpty) gapHC(10),
                  if (_selectedGroupByItems.isNotEmpty) _selectedGroupByView(),
                ],
              ),
            ),
            gapHC(10),
            FilterHead(
              headList: defaultHeadList,
              dataMap: {
                'grouped': _groupingData,
              },
            ),
            gapHC(10),
            /*if (_selectedGroupByItems.isNotEmpty)
              for (int i = 0; i < _groupByData.length; i++)
                _groupedTreeStructure(i, _selectedGroupByItems.first['key']),*/
          ],
        ),
      ),
    );
  }

  Widget wRightFilterSection() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(10),
      decoration: boxBaseDecoration(Colors.white, 0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: boxOutlineCustom1(Colors.white, 10, black, 0.5),
              padding: const EdgeInsets.all(10),
              child: DatedFilter(
                otherFilters: [
                  Row(
                    children: [
                      const Icon(
                        Icons.dashboard_outlined,
                        color: Colors.teal,
                        size: 16,
                      ),
                      gapWC(10),
                      Text(
                        'Group By',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  gapHC(10),
                  // groupBy(),
                  Wrap(
                    children: [
                      for (var item in _groupByItems) _groupBy(item),
                    ],
                  ),
                ],
                filterFunction: (from, to) => setDateRange(from, to),
                onClear: () {},
                onApply: () {},
              ),
            ),
          ),
          gapHC(10),
        ],
      ),
    );
  }

  Widget wMenuCard(icon, text, mode) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: () {
        if (mounted) {
          setState(() {
            title = text;
          });
        }
      },
      child: InkWell(
        onHover: (b) {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: /*lstrMenuHoverMode == mode
                  ? boxBaseDecoration(greyLight.withOpacity(0.3), 10)
                  : */
                  boxBaseDecoration(Colors.transparent, 0),
              child: Row(
                children: [
                  gapWC(5),
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 14,
                  ),
                  gapWC(5),
                  tcn1(text, Colors.white, 13)
                ],
              ),
            ),
            gapHC(5),
            lineC(1.0, greyLight.withOpacity(0.2)),
            gapHC(5),
          ],
        ),
      ),
    );
  }

  setDateRange(DateTime from, DateTime to) async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      fromDate = from;
      toDate = to;
    });
  }

  fnPageLoad() {
    _selectedGroupByItems = [];
  }

  _manageGrouping() {
    setState(() {
      _groupingData = {
        'data': _groupByData,
        'selectedGroupBy': _selectedGroupByItems,
      };
    });
    _apiDataFetch(_groupByData);
  }

  _groupBy(item) {
    return Bounce(
      onPressed: () {
        setState(() {
          if (_selectedGroupByItems.contains(item)) {
            _selectedGroupByItems.remove(item);
          } else {
            _selectedGroupByItems.add(item);
          }
          _manageGrouping();
        });
      },
      duration: const Duration(milliseconds: 110),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: boxOutlineCustom1(
          Colors.white,
          5,
          Colors.grey.shade300,
          0.5,
        ),
        child: Row(
          children: [
            if (_selectedGroupByItems.contains(item))
              const SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: Icon(
                    Icons.check,
                    color: color2,
                    size: 18,
                  ),
                ),
              ),
            if (_selectedGroupByItems.contains(item)) gapWC(10),
            Text(
              item['TITLE'] ?? '',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectedGroupByView() {
    return Row(
      children: [
        const Icon(
          Icons.dashboard_outlined,
          color: Colors.teal,
          size: 18,
        ),
        if (_selectedGroupByItems.isNotEmpty)
          for (var item in _selectedGroupByItems)
            _selectedGroupByItemView(item),
      ],
    );
  }

  _selectedGroupByItemView(item) {
    return Row(
      children: [
        const Icon(
          Icons.arrow_right_sharp,
          color: Colors.black,
        ),
        gapWC(5),
        Text(
          item['TITLE'],
        ),
        gapWC(5),
      ],
    );
  }

  _apiDataFetch(data) {
    lResultList = [];

    //1. selected group list
    var orderNo = 0;

    for (var e in _selectedGroupByItems) {
      var responseKey = (e["KEY"] ?? "").toString();

      var index = 0;

      for (var de in data) {
        // if (orderNo == 0) {
        if (lResultList
            // .where((re) => re["DATA"] == de[responseKey])
            .where((re) => re['DATA'] == de[responseKey])
            .toList()
            .isEmpty) {
          //2.ADD TO RESULT DATA

          var count = 0;
          var hour = 0.0;
          var dataSorList =
              data.where((re) => re[responseKey] == de[responseKey]).toList();

          /*lResultList.add({
            "GROUP": orderNo,
            "KEY": responseKey,
            "DATA": (de[responseKey] ?? "").toString(),
          });*/

          lResultList.add(GroupingData(
            level: orderNo,
            index: index,
            /*user: de['USER'],
              clientId: de['CLIENT_ID'],
              module: de['MODULE'],*/
            data: de[responseKey],
            timeHr: 0.0,
            count: 0,
            parentData: {},
          ).toJson());
          index += 1;
        }
        // } else {
        // for (int i = 0; i < ){
        /* if () {
            lResultList.add(GroupingData(
              user: 'user',
              clientId: 'clientId',
              module: 'module',
              timeHr: 0.0,
              count: 0,
              parentData: {},
            ));
          }*/
        // }
        // }
      }

      orderNo += 1;
    }

    dprint("=========================## RESULTLIST");
    dprint(lResultList);
  }
}

Map _groupingData = {};

List _groupByItems = [
  {
    'TITLE': 'User',
    'KEY': 'USER',
    'PARAM': '',
  },
  /*{
    'TITLE': 'Date',
    'KEY': '',
    'PARAM': '',
  },*/
  {
    'TITLE': 'Client',
    'KEY': 'CLIENT_ID',
    'PARAM': '',
  },
  {
    'TITLE': 'Module',
    'KEY': 'MODULE',
    'PARAM': '',
  },
  /*{
    'TITLE': 'Issue',
    'KEY': '',
    'PARAM': '',
  },
  {
    'TITLE': 'Department',
    'KEY': '',
    'PARAM': '',
  },
  {
    'TITLE': 'Priority',
    'KEY': '',
    'PARAM': '',
  },*/
];

List _selectedGroupByItems = [];

List _groupByData = [
  {
    'USER': 'Hakeem',
    'CLIENT_ID': 'Beams',
    'MODULE': 'JOB',
    'TIME_HR': 15.0,
    'COUNT': 1,
    // 'CONTENT_SHOWN': false,
  },
  {
    'USER': 'Hakeem',
    'CLIENT_ID': 'Splash',
    'MODULE': 'APP',
    'TIME_HR': 10.0,
    'COUNT': 5,
    // 'CONTENT_SHOWN': false,
  },
  {
    'USER': 'Ashiq',
    'CLIENT_ID': 'Beams',
    'MODULE': 'APP',
    'TIME_HR': 5.0,
    'COUNT': 10,
    // 'CONTENT_SHOWN': false,
  },
];

class GroupingData {
  // String id;
  int level;
  int index;
  /*String? user;
  String? clientId;
  String? module;*/
  String data;
  double timeHr;
  int count;
  Map<String, dynamic> parentData;
  bool contentShown;

  GroupingData({
    // required this.id,
    required this.level,
    required this.index,
    /*this.user,
    this.clientId,
    this.module,*/
    required this.data,
    required this.timeHr,
    required this.count,
    required this.parentData,
    this.contentShown = false,
  });

  factory GroupingData.fromJson(json) {
    return GroupingData(
      // id: json['ID'],
      level: json['GROUP'],
      index: json['INDEX'],
      /*user: json['USER'] ?? '',
      clientId: json['CLIENT_ID'] ?? '',
      module: json['MODULE'] ?? '',*/
      data: json['DATA'],
      timeHr: json['TIME_HR'],
      count: json['COUNT'],
      parentData: json['PARENT_DATA'],
      contentShown: json['CONTENT_SHOWN'] ?? false,
    );
  }

  Map toJson() {
    return {
      // 'ID': id,
      'GROUP': level,
      'INDEX': index,
      /*'USER': user,
      'CLIENT_ID': clientId,
      'MODULE': module,*/
      'DATA': data,
      'TIME_HR': timeHr,
      'COUNT': count,
      'PARENT_DATA': parentData,
      'CONTENT_SHOWN': contentShown,
    };
  }
}
