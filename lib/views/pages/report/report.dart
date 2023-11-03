import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/views/components/filters/dated_filter.dart';
import 'package:bams_tms/views/pages/users/usershome.dart';
import 'package:bams_tms/views/pages/users/usershome.dart' as home;
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/PopupLookup/filterPopup.dart';
import '../../components/PopupLookup/searchpopup.dart';
import '../../components/common/common.dart';
import '../../components/filters/filter_head.dart';
import '../../components/lookup/filterLookup.dart';
import '../../components/lookup/lookup.dart';
import '../../styles/colors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ApiCall apiCall = ApiCall();
  final Global g = Global();

  late Future<dynamic> futureForm;
  var notificationList = [];

  var sideNavigation = "";
  String title = 'User Report';
  String lstrSelectedMode = '';

  int reportsTypeCount = 0;

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  DateTime now = DateTime.now();

  var lResultList = [];
  var lVisibleList = [];
  var blSideScreen = false;
  var blColorWise = false;
  var lstrViewKey = "";

  var lstrMenuHoverMode = "PROFILE";
  var lstrStatusList = [];
  var lstrPriorityList = [];
  var lstrIssueTypeList = [];
  var lstrTPrvDocno = "";
  var lstrViewDocno = "";
  var lstrTSubTaskOf = "";
  var lstrTTaskDocno = "";
  var lstrTTaskDoctype = "";
  var lstrTMainCompanyCode = "";
  var lstrTMainCompany = "";
  var lstrTCompany = "";
  var lstrTCompanyCode = "";
  var lstrTCompanyId = "";
  var lstrTaskList = [];
  var lstrTaskListPageNo = 0;

  var openTicket = 0;
  var closedTicket = 0;
  var droppedTicket = 0;
  var overdueTicket = 0;
  var holdTickets = 0;
  var activeTickets = 0;

  var fOpenTicket = 0;
  var fClosedTicket = 0;
  var fDroppedTicket = 0;
  var fOverdueTicket = 0;
  var fActiveTickets = 0;
  var fHoldTickets = 0;

  var moduleCount = [];
  var priorityCount = [];
  var issueCount = [];

  var flStatus = "";
  var flOverDueYn = "N";
  var flSortColumn = "";
  var flSortColumnName = "";
  var flSortColumnDir = "";
  var flPriorityList = [];
  var flIssueTypeList = [];
  var flCompanyList = [];
  var flUserList = [];
  var flAssignUserFrom = [];
  var flAssignUserTo = [];
  var flDepartment = [];
  var flModuleList = [];

  var flSelectedPriority = "";
  var flSelectedIssue = "";
  var flSelectedModule = "";
  var flCreateDate = "";
  var flDocno = "";

  var txtSearch = TextEditingController();
  var txtController = TextEditingController();

  ScrollController scrollController = ScrollController();

  var groupBy = [
    {
      "TITLE": "USER",
      "KEY": "USER_CODE",
      "PARA": "A.USER_CODE",
    },
    {
      "TITLE": "PRIORITY",
      "KEY": "PRIORITY_DESCP",
      "PARA": "B.PRIORITY",
    }
  ];

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
                  // wLeftSideBar(),
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
                              decoration: boxBaseDecoration(Colors.black, 15),
                              padding: const EdgeInsets.all(0),
                              // child: tc('TM', Colors.white, 15),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          gapWC(10),
                          tc('Report', black, 18),
                        ],
                      ),
                      const Expanded(
                        child: SizedBox(),
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
                          if (mounted) {
                            setState(() {
                              blColorWise = !blColorWise;
                            });
                          }
                        },
                        duration: const Duration(milliseconds: 110),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          decoration: boxGradientDecorationBase(7, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                blColorWise
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_off,
                                color: Colors.white,
                                size: 12,
                              ),
                              gapWC(5),
                              tcn1('Color', Colors.white, 12),
                            ],
                          ),
                        ),
                      ),
                      gapWC(10),
                      Bounce(
                        onPressed: () {
                          fnFilterClear();
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
                              : Icons.arrow_circle_right_rounded,
                          color: Colors.deepOrange,
                          size: 20,
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
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.all(5),
              decoration: boxDecoration(Colors.white, 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var e in defaultHeadList)
                        wRowHead(e.title, e.key, e.width, e.sort, e.isActive),
                      /*wRowHead("Task", "DOCNO", 3, "Y"),
                      wRowHead("Issue", "ISSUE_TYPE", 1, "Y"),
                      wRowHead("Company", "COMPANY_NAME", 2, "Y"),
                      wRowHead("Module", "MODULE", 1, "Y"),
                      wRowHead("Department", "DEPARTMENT", 1, "Y"),
                      wRowHead("Status", "STATUS", 1, "Y"),
                      wRowHead("Create Date", "CREATE_DATE", 1, "Y"),
                      //wRowHead("Deadline","DEADLINE",1,"Y"),
                      wRowHead("Active User", "ACTIVE", 1, "Y"),
                      //wRowHead("Assigned By","ASSIGNED_USER",1,"Y"),
                      wRowHead("Created By", "CREATE_USER", 1, "Y"),*/
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: PopupMenuButton(
                          position: PopupMenuPosition.under,
                          offset: const Offset(5, 10),
                          child: const Icon(
                            Icons.checklist,
                            color: Colors.deepOrange,
                            size: 20,
                          ),
                          itemBuilder: (context) {
                            return [
                              for (var e in defaultHeadList)
                                PopupMenuItem(
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        void Function(void Function())
                                            updateState) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            updateState(() {
                                              e.isActive = !e.isActive;
                                            });
                                          });
                                        },
                                        child: Container(
                                          decoration: boxOutlineCustom(
                                              Colors.white,
                                              0,
                                              Colors.grey.shade200),
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
                                                      e.isActive
                                                          ? color2
                                                          : Colors.white,
                                                      5,
                                                      e.isActive
                                                          ? color2
                                                          : Colors
                                                              .grey.shade300),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 12,
                                                    ),
                                                  ),
                                                ),
                                                gapWC(5),
                                                tc(e.title, Colors.black, 14),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ];
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            /*FilterHead(
              headList: defaultHeadList,
              dataMap: {
                'grouped': _groupingData,
              },
            ),*/
            gapHC(10),
            Expanded(
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: lResultList.where((e) => e["GROUP"] == 1).length,
                itemBuilder: (context, index) {
                  var data =
                      lResultList.where((e) => e["GROUP"] == 1).toList()[index];
                  return wGroupHead(data);
                },
              ),
            ),
            gapHC(20),
          ],
        ),
      ),
    );
  }

  Widget wRightFilterSection() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(5),
      decoration: boxDecoration(Colors.white, 0),
      child: Column(
        children: [
          Expanded(
            child: Container(
              //decoration: boxOutlineCustom1(Colors.white, 10, Colors.grey.withOpacity(0.5), 0.5),
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
                  gapHC(10),
                  Row(
                    children: [
                      const Icon(
                        Icons.mode_standby_outlined,
                        color: Colors.teal,
                        size: 16,
                      ),
                      gapWC(10),
                      Text(
                        'Status',
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
                  Wrap(
                    children: [
                      for (var item in _statusData) _status(item),
                    ],
                  ),
                ],
                filterFunction: (from, to) => setDateRange(from, to),
                onClear: () {},
                onApply: () async {
                  _apiDataFetch();
                },
                onDateChange: () {
                  _apiDataFetch();
                },
              ),
            ),
          ),
          gapHC(10),
        ],
      ),
    );
  }

  Widget wGroupHead(data) {
    var subList = (data["PARENT_DATA"] ?? []);
    var title = (data["DATA"] ?? "");
    var parentKey = (data["M_KEY"] ?? "");
    var orderNo = data["GROUP"];
    var hour = fnConvertHoursToHMS(g.mfnDbl(data["TIME_HR"])).toString();
    var count = (data["COUNT"] ?? "").toString();
    var key = "$title$orderNo$parentKey";

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              if (lVisibleList.contains(key)) {
                lVisibleList.remove(key);
              } else {
                lVisibleList.add(key);
              }
            });
          },
          child: MouseRegion(
            onHover: (sts) {
              if (mounted) {
                setState(() {
                  lstrViewKey = key;
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: EdgeInsets.only(left: orderNo * 15.0, bottom: 2),
              //_colorList[orderNo].withOpacity(0.1)
              decoration: orderNo == 1
                  ? boxDecoration(
                      lstrViewKey == key
                          ? yellowLight.withOpacity(0.5)
                          : Colors.white,
                      5)
                  : boxBaseDecoration(
                      lstrViewKey == key
                          ? yellowLight.withOpacity(0.5)
                          : orderNo > 1
                              ? blColorWise
                                  ? _colorList[orderNo].withOpacity(0.1)
                                  : blueLight
                              : Colors.white,
                      5),
              child: Row(
                children: [
                  Flexible(
                    flex: 8,
                    child: Row(
                      children: [
                        lVisibleList.contains(key)
                            ? const Icon(
                                Icons.arrow_drop_down_sharp,
                                size: 18,
                              )
                            : const Icon(
                                Icons.arrow_right_rounded,
                                size: 18,
                              ),
                        gapWC(5),
                        orderNo == 1
                            ? tc(title, Colors.black, 13)
                            : tcn(title, Colors.black, 13),
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          orderNo == 1
                              ? tc(count, Colors.black, 13)
                              : tcn(count, Colors.black, 13),
                        ],
                      )),
                  Flexible(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          orderNo == 1
                              ? tc(hour, Colors.black, 13)
                              : tcn(hour, Colors.black, 13),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
        // Padding(padding: EdgeInsets.only(left: orderNo * 15.0)
        // ,child:   Divider(color: Colors.grey.shade500,height: 0.2,),),
        lVisibleList.contains(key)
            ? Column(children: wSubList(title, data, orderNo))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: wTaskList(),
              ),
      ],
    );
  }

  List<Widget> wSubList(title, data, orderNo) {
    List<Widget> rtnList = [];

    var mainParent = data["M_KEY"];

    rtnList.add(Container());
    var subData = lResultList
        .where(
            (e) => e["GROUP"] == orderNo + 1 && e["PARENT_M_KEY"] == mainParent)
        .toList();
    for (var e in subData) {
      rtnList.add(wGroupHead(e));
    }
    return rtnList;
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

  Widget wRowHead(title, column, flex, sortYn, active) {
    if (active) {
      return Flexible(
          flex: flex,
          child: MouseRegion(
              onHover: (hvr) {
                if (mounted) {
                  setState(() {
                    if (sortYn == "Y") {
                      flSortColumn = column;
                    }
                  });
                }
              },
              child: GestureDetector(
                onTap: () {
                  if (flSortColumnDir == "ASC") {
                    fnSort(column, "DESC");
                  } else {
                    fnSort(column, "ASC");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: flSortColumn == column
                      ? boxBaseDecoration(yellowLight.withOpacity(0.5), 2)
                      : boxBaseDecoration(Colors.transparent, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: tc(title, color3, 12),
                                ),
                                gapWC(5),
                                (column == "PRIORITY" &&
                                            flPriorityList.isNotEmpty) ||
                                        (column == "ISSUE_TYPE" &&
                                            flIssueTypeList.isNotEmpty) ||
                                        (column == "DEPARTMENT" &&
                                            flDepartment.isNotEmpty) ||
                                        (column == "DOCNO" &&
                                            flDocno.isNotEmpty) ||
                                        (column == "COMPANY_NAME" &&
                                            flCompanyList.isNotEmpty) ||
                                        (column == "MODULE" &&
                                            flModuleList.isNotEmpty) ||
                                        (column == "CREATE_USER" &&
                                            flUserList.isNotEmpty) ||
                                        (column == "CREATE_DATE" &&
                                            flCreateDate.isNotEmpty)
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 1, horizontal: 5),
                                        decoration:
                                            boxBaseDecoration(color2, 5),
                                        child: tcn(
                                            (column == "PRIORITY"
                                                    ? flPriorityList.length
                                                    : column == "ISSUE_TYPE"
                                                        ? flIssueTypeList.length
                                                        : column ==
                                                                "COMPANY_NAME"
                                                            ? flCompanyList
                                                                .length
                                                            : column ==
                                                                    "CREATE_USER"
                                                                ? flUserList
                                                                    .length
                                                                : column ==
                                                                        "MODULE"
                                                                    ? flModuleList
                                                                        .length
                                                                    : column ==
                                                                            "DEPARTMENT"
                                                                        ? flDepartment
                                                                            .length
                                                                        : '1')
                                                .toString(),
                                            Colors.white,
                                            10),
                                      )
                                    : gapWC(0),
                              ],
                            ),
                          ),
                          gapWC(5),
                          flSortColumn == column
                              ? Row(
                                  children: [
                                    flSortColumnDir == "DESC"
                                        ? const Icon(
                                            Icons.arrow_downward_rounded,
                                            size: 10)
                                        : const Icon(Icons.arrow_upward_sharp,
                                            size: 10),
                                    gapWC(2),

                                    PopupMenuButton<home.Menu>(
                                      position: PopupMenuPosition.under,
                                      tooltip: "",
                                      onSelected: (home.Menu item) {
                                        setState(() {});
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<home.Menu>>[
                                        PopupMenuItem<home.Menu>(
                                          value: home.Menu.itemOne,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 0),
                                          child: wFilterPopup(column),
                                        ),
                                      ],
                                      child: const Icon(Icons.filter_list_alt,
                                          size: 12),
                                    ),
                                    // GestureDetector(
                                    //     onTap: (){
                                    //       fnSort(column,"ASC");
                                    //     },
                                    //     child: const Icon(Icons.arrow_upward_sharp,size:10))
                                  ],
                                )
                              : gapHC(0),
                        ],
                      ),
                    ],
                  ),
                ),
              )));
    } else {
      return gapWC(0);
    }
  }

  List<Widget> wTaskList() {
    List<Widget> rtnList = [];
    for (var e in lstrTaskList) {
      var srno = e["SRNO"] ?? "";
      var docno = e["DOCNO"] ?? "";
      var doctype = e["DOCTYPE"] ?? "";
      var docDate = e["DOCDATE"] ?? "";
      var mainClientId = e["MAIN_CLIENT_ID"] ?? "";
      var clientId = e["CLIENT_ID"] ?? "";
      var clientCompany = e["CLIENT_COMPANY"] ?? "";
      var clientCompanyName = e["COMPANY_NAME"] ?? "";
      var contactPerson = e["CONTACT_PERSON"] ?? "";
      var contactPersonMob = e["CONTACT_MOB"] ?? "";
      var contactPersonEmail = e["CONTACT_EMAIL"] ?? "";
      var taskHead = e["TASK_HEADER"] ?? "";
      var taskDetails = e["TASK_DETAIL"] ?? "";

      var createUser = e["CREATE_USER"] ?? "";
      var activeUser = e["ACTIVE_USER"] ?? "";
      var assignUser = e["ASSIGNED_USER"] ?? "";

      var createDate = e["CREATE_DATE"] ?? "";
      var closedTime = e["END_TIME"] ?? "";
      var completedUser = e["COMPLETED_USER"] ?? "";
      var deadlineDate = e["DEADLINE"] ?? "";
      var priorityCode = e["PRIORITY"] ?? "";
      var priority = e["PRIORITY_DESCP"] ?? "";
      var status = e["CURR_STATUS"] ?? "";
      var taskStatus = e["STATUS"] ?? "";
      var lastStatus = e["LAST_ACTION"] ?? "";
      var module = e["MODULE"] ?? "";
      var taskType = e["TASK_TYPE"] ?? "";
      var clientType = e["CLIENT_TYPE"] ?? "";
      var issueTypeCode = e["ISSUE_TYPE"] ?? "";
      var issueType = e["ISSUE_TYPE_DESCP"] ?? "";
      var completionNote = e["COMPLETION_NOTE"] ?? "";
      var departmentList = e["DEP_LIST"] ?? [];
      var department = "";

      for (var dep in departmentList) {
        department += (dep["DESCP"] ?? "") + ",";
      }

      var taskDate =
          createDate != "" ? setDate(7, DateTime.parse(createDate)) : "";
      var deadline =
          deadlineDate != "" ? setDate(7, DateTime.parse(deadlineDate)) : "";
      var closeDate =
          closedTime != "" ? setDate(7, DateTime.parse(closedTime)) : "";
      var deadlineSts = false;

      // if(lstrMenuHoverMode == "H" && g.wstrUserRole != "DEPHEAD"){
      //   status = taskStatus;
      // }

      try {
        var dDate = DateTime.parse(deadlineDate);
        var now = DateTime.now();

        if (dDate.isBefore(now)) {
          deadlineSts = true;
        }
      } catch (e) {
        deadlineSts = false;
      }

      if (activeUser.toString().isEmpty) {
        activeUser = createUser;
      }

      rtnList.add(GestureDetector(
        //duration:const Duration(milliseconds: 110),
        onDoubleTap: () {
          // apiGetTaskDet(mainClientId, docno, doctype);
        },
        child: MouseRegion(
          onHover: (sts) {
            if (mounted) {
              setState(() {
                flSortColumn = "";
                lstrViewDocno = docno;
              });
            }
          },
          child: Container(
            decoration: boxBaseDecoration(
                lstrViewDocno == docno ? color2.withOpacity(0.1) : Colors.white,
                0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    wRowDet(
                        stcn("${srno.toString()} .  $docno", color3, 10), 1),
                    wRowDet(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            status == "C" || status == "D"
                                ? tcs(
                                    taskHead.toString().toUpperCase(),
                                    priority == "CRITICAL" && status == "P"
                                        ? Colors.red
                                        : Colors.black,
                                    10)
                                : stc(
                                    taskHead.toString().toUpperCase(),
                                    priority == "CRITICAL" && status == "P"
                                        ? Colors.red
                                        : Colors.black,
                                    10),
                            lstrViewDocno == docno
                                ? stcn(taskDetails, Colors.black, 10)
                                : gapHC(0),
                          ],
                        ),
                        2),
                    wRowDet(stcn(issueType, color3, 10), 1),
                    wRowDet(
                        stc(clientCompany + " | " + clientCompanyName, color3,
                            10),
                        2),
                    wRowDet(stcn(module, color3, 10), 1),
                    wRowDet(stcn(department, color3, 10), 1),
                    wRowDet(
                        status != ""
                            ? PopupMenuButton<home.Menu>(
                                enabled: false,
                                position: PopupMenuPosition.under,
                                tooltip: "",
                                onSelected: (home.Menu item) {},
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<home.Menu>>[
                                  PopupMenuItem<home.Menu>(
                                    value: home.Menu.itemOne,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0),
                                    child: SearchPopup(
                                      searchYn: "N",
                                      lstrColumnList: const [
                                        {"COLUMN": "DESCP", "CAPTION": "Status"}
                                      ],
                                      lstrData: lstrStatusList,
                                      callback: (val) {
                                        if (mounted) {
                                          var changeSts = val["CODE"];
                                          // apiUpdateTask(
                                          //     docno,
                                          //     doctype,
                                          //     changeSts,
                                          //     issueTypeCode,
                                          //     priorityCode);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                                child: Container(
                                  decoration: boxBaseDecoration(
                                      status == "P"
                                          ? Colors.green
                                          : status == "C"
                                              ? Colors.red
                                              : status == "D"
                                                  ? Colors.purple
                                                  : status == "A"
                                                      ? color2
                                                      : status == "H"
                                                          ? Colors.orange
                                                          : color2,
                                      30),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: stcn(
                                      status == "P"
                                          ? "Open"
                                          : status == "C"
                                              ? "Closed"
                                              : status == "D"
                                                  ? "Dropped"
                                                  : status == "A"
                                                      ? "Started"
                                                      : status == "H"
                                                          ? "Hold"
                                                          : "",
                                      Colors.white,
                                      10),
                                ),
                              )
                            : gapHC(0),
                        1),
                    wRowDet(stcn(taskDate, color3, 10), 1),
                    // deadlineSts && status == "P"?
                    // wRowDet(tc(deadline, Colors.red, 10),1):
                    wRowDet(tcn(activeUser, color3, 10), 1),
                    // wRowDet(PopupMenuButton<Menu>(
                    //       enabled: status == "C" || status == "D"?false:true,
                    //       position: PopupMenuPosition.under,
                    //       tooltip: "",
                    //       onSelected: (Menu item) {
                    //         setState(() {
                    //         });
                    //       },
                    //       shape:  RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10)),
                    //       itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                    //         PopupMenuItem<Menu>(
                    //           enabled: status == "C" || status == "D"?false:true,
                    //           value: Menu.itemOne,
                    //           padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                    //           child: SearchPopup(
                    //             searchYn: "N",
                    //             lstrColumnList: const [{"COLUMN":"DESCP","CAPTION":"Priority"}],
                    //             lstrData: lstrPriorityList,
                    //             callback: (val){
                    //               if(mounted){
                    //                 apiUpdateTask(docno, doctype, status, issueTypeCode, val["CODE"]);
                    //               }
                    //             },),
                    //         ),
                    //       ],
                    //       child:  Row(
                    //         children: [
                    //           Icon(
                    //             priority == "EMERGENCY"?Icons.warning:priority == "CRITICAL"?Icons.local_fire_department_outlined:priority == "NORMAL"?Icons.cloud_queue_outlined:priority == "MEDIUM"?Icons.adjust_rounded:Icons.warning
                    //             ,
                    //             color: priority == "EMERGENCY"?Colors.deepOrange:priority == "CRITICAL"?Colors.red:priority == "NORMAL"?Colors.blue:priority == "MEDIUM"?Colors.amber:Colors.black
                    //           ,size: 12,),
                    //           gapWC(5),
                    //           tcn(priority.toString(), Colors.black, 12),
                    //         ],
                    //       ),
                    //     ),1),
                    //wRowDet(tcn(assignUser.toString().toUpperCase(), color3, 10),1),
                    wRowDet(
                        stcn(createUser.toString().toUpperCase(), color3, 10),
                        1),
                  ],
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                //   decoration: boxBaseDecoration(greyLight, 5),
                //   child: Row(
                //
                //     children: [
                //       Row(
                //         children: [
                //           const Icon(Icons.calendar_month,color: Colors.black,size: 12,),
                //           gapWC(5),
                //           tcn('Action Date', Colors.black, 10),
                //           gapWC(5),
                //           tcn('12-05-2023', Colors.black, 10),
                //         ],
                //       ),
                //       gapWC(10),
                //       Row(
                //         children: [
                //           const Icon(Icons.verified_user,color: Colors.black,size: 12,),
                //           gapWC(5),
                //           tcn('Moved From', Colors.black, 10),
                //           gapWC(5),
                //           tcn(assignUser, Colors.black, 10),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                (taskStatus == "C" || taskStatus == "D") &&
                        lstrViewDocno == docno
                    ? Container(
                        margin: const EdgeInsets.only(top: 5),
                        decoration:
                            boxBaseDecoration(greyLight.withOpacity(0.4), 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                tc("COMPLETION NOTE ", Colors.black, 8),
                                gapWC(10),
                                Expanded(
                                  child: tcn(completionNote.toString(),
                                      Colors.black, 10),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  color: Colors.black,
                                  size: 12,
                                ),
                                gapWC(10),
                                Expanded(
                                  child: tcn(
                                      closeDate.toString(), Colors.black, 10),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 12,
                                ),
                                gapWC(10),
                                Expanded(
                                  child: tcn(completedUser.toString(),
                                      Colors.black, 10),
                                )
                              ],
                            ),
                            gapHC(10),
                          ],
                        ))
                    : gapHC(0),
                gapHC(5),
                (status == "C" || status == "D") && lstrViewDocno == docno
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: boxOutlineCustom1(
                                Colors.transparent, 5, Colors.black, 0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.album_rounded,
                                      color: Colors.green,
                                      size: 10,
                                    ),
                                    gapWC(10),
                                    tc('Last Status', Colors.black, 10),
                                  ],
                                ),
                                tcn(lastStatus.toString().toUpperCase(), color3,
                                    10),
                                tcn('ACTIVE USER :  ${activeUser.toString().toUpperCase()}',
                                    color3, 10),
                              ],
                            ),
                          ),
                          /*Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: () {
                              //apiMoveTask(docno, doctype);
                              if (mounted) {
                                setState(() {
                                  sideNavigation = "TL";
                                });
                              }
                              */ /*apiGetTaskDetTimeline(
                            mainClientId, docno, doctype);*/ /*
                            },
                            child: wSettingsCard(Icons.access_time),
                          ),*/
                        ],
                      )
                    : gapHC(0),
                (status != "C" && status != "D") && lstrViewDocno == docno
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            decoration: boxOutlineCustom1(
                                Colors.transparent, 5, Colors.black, 0.5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.album_rounded,
                                      color: Colors.green,
                                      size: 10,
                                    ),
                                    gapWC(10),
                                    tc('Last Status', Colors.black, 10),
                                  ],
                                ),
                                tcn(lastStatus.toString().toUpperCase(), color3,
                                    10),
                                tcn('ACTIVE USER :  ${activeUser.toString().toUpperCase()}',
                                    color3, 10),
                              ],
                            ),
                          ),
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              status == "P" && lstrMenuHoverMode == "PROFILE"
                                  ? Bounce(
                                      duration:
                                          const Duration(milliseconds: 110),
                                      onPressed: () {
                                        apiStartTask(docno, doctype);
                                      },
                                      child: Container(
                                          decoration: boxDecoration(color2, 30),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons
                                                    .play_circle_filled_rounded,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                              gapWC(5),
                                              tcn1('START', Colors.white, 12)
                                            ],
                                          )),
                                    )
                                  : gapHC(0),
                              status == "H" && lstrMenuHoverMode == "PROFILE"
                                  ? Bounce(
                                      duration:
                                          const Duration(milliseconds: 110),
                                      onPressed: () {
                                        apiResumeTask(docno, doctype);
                                      },
                                      child: Container(
                                          decoration: boxDecoration(color2, 30),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 20),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons
                                                    .play_circle_filled_rounded,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                              gapWC(5),
                                              tcn1('RESUME', Colors.white, 12)
                                            ],
                                          )),
                                    )
                                  : gapHC(0),
                              status == "P" && lstrMenuHoverMode != "PROFILE"
                                  ? Row(
                                      children: [
                                        Bounce(
                                            duration: const Duration(
                                                milliseconds: 110),
                                            onPressed: () {
                                              //apiMoveTask(docno, doctype);
                                              if (mounted) {
                                                setState(() {
                                                  sideNavigation = "M";
                                                  lstrAssignDocno = docno;
                                                  lstrAssignDoctype = doctype;
                                                });
                                              }
                                              scaffoldKey.currentState
                                                  ?.openEndDrawer();
                                            },
                                            child: wSettingsCard(
                                                Icons.screen_share_outlined)),
                                        gapWC(5),
                                        Bounce(
                                          duration:
                                              const Duration(milliseconds: 110),
                                          onPressed: () {
                                            //apiMoveTask(docno, doctype);
                                            if (mounted) {
                                              setState(() {
                                                sideNavigation = "TL";
                                              });
                                            }
                                            apiGetTaskDetTimeline(
                                                mainClientId, docno, doctype);
                                          },
                                          child:
                                              wSettingsCard(Icons.access_time),
                                        ),
                                      ],
                                    )
                                  : gapHC(0),
                              gapWC(5),
                              status == "A" || status == "H"
                                  ? Row(
                                      children: [
                                        lstrMenuHoverMode == "PROFILE" &&
                                                status == "A"
                                            ? PopupMenuButton<Menu>(
                                                position:
                                                    PopupMenuPosition.under,
                                                tooltip: "",
                                                onSelected: (Menu item) {},
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuEntry<Menu>>[
                                                  PopupMenuItem<Menu>(
                                                    value: Menu.itemOne,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 0,
                                                        horizontal: 0),
                                                    child: wHoldPopup(
                                                        docno, doctype),
                                                  ),
                                                ],
                                                child:
                                                    wSettingsCard(Icons.pause),
                                              )
                                            : gapWC(0),
                                        gapWC(5),
                                        Bounce(
                                            duration: const Duration(
                                                milliseconds: 110),
                                            onPressed: () {
                                              //apiMoveTask(docno, doctype);
                                              if (mounted) {
                                                setState(() {
                                                  sideNavigation = "M";
                                                  lstrAssignDocno = docno;
                                                  lstrAssignDoctype = doctype;
                                                });
                                              }
                                              scaffoldKey.currentState
                                                  ?.openEndDrawer();
                                            },
                                            child: wSettingsCard(
                                                Icons.screen_share_outlined)),
                                        gapWC(5),
                                        lstrMenuHoverMode == "PROFILE"
                                            ? PopupMenuButton<Menu>(
                                                position:
                                                    PopupMenuPosition.under,
                                                tooltip: "",
                                                onSelected: (Menu item) {},
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                itemBuilder:
                                                    (BuildContext context) =>
                                                        <PopupMenuEntry<Menu>>[
                                                  PopupMenuItem<Menu>(
                                                    value: Menu.itemOne,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 0,
                                                        horizontal: 0),
                                                    child: wFinishPopup(
                                                        docno, doctype),
                                                  ),
                                                ],
                                                child: wSettingsCard(
                                                    Icons.task_alt_rounded),
                                              )
                                            : gapWC(0),
                                        gapWC(5),
                                        Bounce(
                                          duration:
                                              const Duration(milliseconds: 110),
                                          onPressed: () {
                                            //apiMoveTask(docno, doctype);
                                            if (mounted) {
                                              setState(() {
                                                sideNavigation = "TL";
                                              });
                                            }
                                            apiGetTaskDetTimeline(
                                                mainClientId, docno, doctype);
                                          },
                                          child:
                                              wSettingsCard(Icons.access_time),
                                        ),
                                        gapWC(5),
                                        Bounce(
                                            duration: const Duration(
                                                milliseconds: 110),
                                            onPressed: () {
                                              if (mounted) {
                                                setState(() {
                                                  sideNavigation = "T";
                                                  lstrTSubTaskOf = docno;
                                                  lstrTMainCompanyCode =
                                                      mainClientId;
                                                  lstrTTaskDoctype = doctype;
                                                });
                                              }
                                              // fnNewTask();
                                              // scaffoldKey.currentState
                                              //     ?.openEndDrawer();
                                            },
                                            child: wSettingsCard(
                                                Icons.add_task_outlined)),
                                        gapWC(5),
                                        wSettingsCard(Icons.comment),
                                        gapWC(5),
                                        wSettingsCard(
                                            Icons.admin_panel_settings_rounded)
                                      ],
                                    )
                                  : gapWC(0)
                            ],
                          ),*/
                        ],
                      )
                    : gapHC(0),
                gapHC(5),
                lineC(1.0, greyLight),
              ],
            ),
          ),
        ),
      ));
    }
    return rtnList;
  }

  /*Widget wSettingsCard(icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: boxDecoration(Colors.white, 5),
      child: Icon(
        icon,
        color: color2,
        size: 18,
      ),
    );
  }*/

  Widget wRowDet(child, flex) {
    return Flexible(
        flex: flex,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Row(), child],
        ));
  }

  Widget wFilterPopup(mode) {
    if (mounted) {
      setState(() {
        flSelectedIssue = "";
        flSelectedPriority = "";
        flSelectedModule = "";
      });
    }
    if (mode == "PRIORITY") {
      return FilterPopup(
        lstrColumnList: [],
        lstrData: lstrPriorityList,
        callback: (data) {
          if (mounted) {
            setState(() {
              flPriorityList = data;
            });
            // apiGetTask("");
            _apiDataFetch();
          }
        },
        mainKey: "CODE",
        showKey: "DESCP",
        lstrOldData: flPriorityList,
      );
    } else if (mode == "ISSUE_TYPE") {
      return FilterPopup(
        lstrColumnList: [],
        lstrData: lstrIssueTypeList,
        callback: (data) {
          if (mounted) {
            setState(() {
              flIssueTypeList = data;
            });
            // apiGetTask("");
            _apiDataFetch();
          }
        },
        mainKey: "CODE",
        showKey: "DESCP",
        lstrOldData: flIssueTypeList,
      );
    } else if (mode == "DOCNO") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'DOCNO', 'Display': '#'},
        {'Column': 'TASK_HEADER', 'Display': 'Task Name'},
        {'Column': 'TASK_DETAIL', 'Display': 'Task Details'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [];
      var lstrFilter = [
        {
          'Column': "DOCNO",
          'Operator': '<>',
          'Value': lstrTTaskDocno,
          'JoinType': 'AND'
        },
      ];
      return Lookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'TASK',
        title: 'Task List',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'DOCNO',
        mode: "S",
        layoutName: "B",
        callback: (data) {
          if (mounted) {
            setState(() {
              if (g.fnValCheck(data)) {
                flDocno = data["DOCNO"];
              }
            });
            // apiGetTask("");
            _apiDataFetch();
          }
        },
        searchYn: 'Y',
      );
    } else if (mode == "COMPANY_NAME") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CLIENT_ID', 'Display': '#'},
        {'Column': 'NAME', 'Display': 'Company'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [];
      var lstrFilter = [];

      return FilterLookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'CLIENT_DETAIL',
        title: 'Company',
        lstrOldData: flCompanyList,
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'CLIENT_ID',
        mode: "S",
        layoutName: "B",
        callback: (data) {
          if (mounted) {
            setState(() {
              flCompanyList = data;
            });
            // apiGetTask("");
            _apiDataFetch();
          }
        },
        searchYn: 'Y',
      );
    } else if (mode == "CREATE_USER") {
      // if(g.wstrUserRole != "ADMIN"){
      //   return Container();
      // }
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'USER_CD', 'Display': 'User'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [];
      var lstrFilter = [];

      return FilterLookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'USER_MASTER',
        title: 'Create User',
        lstrOldData: flUserList,
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'USER_CD',
        mode: "S",
        layoutName: "B",
        callback: (data) {
          if (mounted) {
            setState(() {
              flUserList = data;
            });
            // apiGetTask("");
            _apiDataFetch();
          }
        },
        searchYn: 'Y',
      );
    } else if (mode == "MODULE") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'User'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [];
      var lstrFilter = [];

      return FilterLookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'MODULE_MAST',
        title: 'Module',
        lstrOldData: flModuleList,
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'CODE',
        mode: "S",
        layoutName: "B",
        callback: (data) {
          if (mounted) {
            setState(() {
              flModuleList = data;
            });
            // apiGetTask("");
            _apiDataFetch();
          }
        },
        searchYn: 'Y',
      );
    } else if (mode == "ASSIGN_USER") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'USER_CD', 'Display': 'User'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [];
      var lstrFilter = [];

      return FilterLookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'USER_MASTER',
        title: 'Assign Users',
        lstrOldData: flAssignUserFrom,
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'USER_CD',
        mode: "S",
        layoutName: "B",
        callback: (data) {
          if (mounted) {
            if (mounted) {
              setState(() {
                flAssignUserFrom = data;
              });
              Navigator.pop(context);
              // apiGetTask("");
              _apiDataFetch();
            }
          }
        },
        searchYn: 'Y',
      );
    } else if (mode == "ASSIGN_TO") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'USER_CD', 'Display': 'User'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [];
      var lstrFilter = [];

      return FilterLookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'USER_MASTER',
        title: 'Assign Users',
        lstrOldData: flAssignUserTo,
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'USER_CD',
        mode: "S",
        layoutName: "B",
        callback: (data) {
          if (mounted) {
            if (mounted) {
              setState(() {
                flAssignUserTo = data;
              });
              Navigator.pop(context);
              // apiGetTask("");
              _apiDataFetch();
            }
          }
        },
        searchYn: 'Y',
      );
    } else if (mode == "DEPARTMENT") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'User'},
        {'Column': 'DESCP', 'Display': 'Descp'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [];
      var lstrFilter = [];

      return FilterLookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'DEPARTMENT_MAST',
        title: 'Department',
        lstrOldData: flDepartment,
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'CODE',
        mode: "S",
        layoutName: "B",
        callback: (data) {
          if (mounted) {
            if (mounted) {
              setState(() {
                flDepartment = data;
              });
              // apiGetTask("");
              _apiDataFetch();
            }
          }
        },
        searchYn: 'Y',
      );
    } else if (mode == "CREATE_DATE") {
      return Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  _selectFilterDate(context);
                },
                child: tcn(flCreateDate.isEmpty ? "Choose Date" : flCreateDate,
                    bgColorDark, 12)),
            gapHC(20),
            GestureDetector(
              onTap: () {
                if (mounted) {
                  setState(() {
                    flCreateDate = "";
                  });
                  Navigator.pop(context);
                  // apiGetTask("");
                  _apiDataFetch();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
                decoration:
                    boxOutlineCustom1(Colors.white, 30, Colors.black, 0.5),
                child: tcn1('Clear', Colors.black, 10),
              ),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  setDateRange(DateTime from, DateTime to) async {
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      fromDate = from;
      toDate = to;
    });
    _apiDataFetch();
  }

  fnPageLoad() {
    _selectedGroupByItems = [];
    apiGetTaskMasters();
  }

  fnSort(column, arrow) {
    if (mounted) {
      setState(() {
        flSortColumnName = column;
        flSortColumnDir = arrow;
      });
    }
    // apiGetTask("");
    _apiDataFetch();
  }

  _manageGrouping() {
    setState(() {
      _groupingData = {
        'data': _groupByData,
        'selectedGroupBy': _selectedGroupByItems,
      };
    });
    _apiDataFetch();
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

  _status(item) {
    return Bounce(
      onPressed: () {
        setState(() {
          if (_selectedStatus.contains(item)) {
            _selectedStatus.remove(item);
          } else {
            _selectedStatus.add(item);
          }
          _apiDataFetch();
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
            if (_selectedStatus.contains(item))
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
            if (_selectedStatus.contains(item)) gapWC(10),
            Text(
              item["TITLE"] ?? '',
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

  _apiDataFetch() async {
    var col = [];
    var fil = [];

    //TODO FILTER

    for (var e in _selectedStatus) {
      if ((e["KEY"] ?? "") == "P") {
        fil.add({
          "COL_KEY": "STATUS",
          "COL_VAL": "A",
        });
        fil.add({
          "COL_KEY": "STATUS",
          "COL_VAL": "H",
        });
      }
      fil.add({
        "COL_KEY": "STATUS",
        "COL_VAL": (e["KEY"] ?? ""),
      });
    }

    //user

    for (var e in flUserList) {
      fil.add({
        "COL_KEY": "USER_CODE",
        "COL_VAL": (e ?? ""),
      });
    }

    //task

    if (flDocno.trim().isNotEmpty) {
      fil.add({
        "COL_KEY": "DOCNO",
        "COL_VAL": flDocno,
      });
    }

    for (var e in flCompanyList) {
      fil.add({
        "COL_KEY": "CLIENT_ID",
        "COL_VAL": (e ?? ""),
      });
    }

    for (var e in flModuleList) {
      fil.add({
        "COL_KEY": "MODULE",
        "COL_VAL": (e ?? ""),
      });
    }

    for (var e in flDepartment) {
      fil.add({
        "COL_KEY": "DEPARTMENT_CODE",
        "COL_VAL": (e ?? ""),
      });
    }

    for (var e in flPriorityList) {
      fil.add({
        "COL_KEY": "PRIORITY",
        "COL_VAL": (e ?? ""),
      });
    }

    for (var se in _selectedGroupByItems) {
      for (var seKey in se['REQUEST_KEY']) {
        col.add(seKey);
      }
    }
    dynamic response = await apiCall.apiTaskReport(
        col, setDate(2, fromDate), setDate(2, toDate), fil, g.wstrUserCd, 'N');
    if (mounted) {
      setState(() {
        try {
          _groupByData = response["HEAD"] ?? [];
        } catch (e) {
          _groupByData = [];
          dprint(e);
        }
      });
    }
    dprint('RESPONSE^^^^ $response');

    var data = _groupByData;
    lResultList = [];

    //1. selected group list
    var orderNo = 1;
    var parentKey = "";
    var parentMKey = "";
    var mainParent = "";
    var parentData = [];
    for (var e in _selectedGroupByItems) {
      var responseKey = (e["RETURN_KEY"] ?? "").toString();
      for (var de in data) {
        mainParent = "";
        parentMKey = "";
        parentMKey = "";
        var mainNo = 0;
        for (var main in _selectedGroupByItems) {
          if ((orderNo - 1) >= mainNo) {
            mainParent = mainParent + (de[main["RETURN_KEY"]] ?? "").toString();
          }
          if ((orderNo - 1) > mainNo) {
            parentMKey = parentMKey + (de[main["RETURN_KEY"]] ?? "").toString();
          }
          mainNo = mainNo + 1;
        }

        if (lResultList
            // .where((re) => re["DATA"] == de[responseKey])
            .where((re) =>
                re['DATA'] == de[responseKey] &&
                (re['M_KEY'] ?? "") == mainParent)
            .toList()
            .isEmpty) {
          //2.ADD TO RESULT DATA
          var count = 0;
          var hour = 0.0;
          var dataSorList = [];
          if (orderNo == 1) {
            dataSorList =
                data.where((re) => re[responseKey] == de[responseKey]).toList();

            for (var f in dataSorList) {
              count += int.parse(f["COUNTS"].toString());
              hour += double.parse(f["TIME_HR"].toString());
            }

            setState(() {
              lResultList.add({
                "GROUP": orderNo,
                "PARENT_M_KEY": parentMKey,
                "M_KEY": mainParent,
                "KEY": responseKey,
                "DATA": (de[responseKey] ?? "").toString(),
                "PARENT": (parentKey).toString(),
                "PARENT_KEY": (de[parentKey] ?? "").toString(),
                "PARENT_DATA": dataSorList,
                "TIME_HR": hour,
                "COUNT": count,
              });
            });
          } else {
            var lst = lResultList
                .where((re) =>
                    (re['DATA'] ?? "") == (de[parentKey] ?? "") &&
                    (re['M_KEY'] ?? "") == parentMKey)
                .toList();
            if (lst.isNotEmpty) {
              parentData = lst[0]["PARENT_DATA"];
              dataSorList = parentData
                  .where((re) => re[responseKey] == de[responseKey])
                  .toList();
            }

            for (var f in dataSorList) {
              count += int.parse(f["COUNTS"].toString());
              hour += double.parse(f["TIME_HR"].toString());
            }

            if (parentData.where((pe) => pe == de).toList().isNotEmpty) {
              setState(() {
                lResultList.add({
                  "GROUP": orderNo,
                  "PARENT_M_KEY": parentMKey,
                  "M_KEY": mainParent,
                  "KEY": responseKey,
                  "DATA": (de[responseKey] ?? "").toString(),
                  "PARENT": (parentKey).toString(),
                  "PARENT_KEY": (de[parentKey] ?? "").toString(),
                  "PARENT_DATA": dataSorList,
                  "TIME_HR": hour,
                  "COUNT": count,
                });
              });
            }
          }
        }
      }
      parentKey = responseKey;
      orderNo += 1;
    }

    dprint("=========================## RESULTLIST");
    dprint(lResultList);
  }

  apiDataDet(data) async {
    var fixedFil = [];
    var fil = [];

    //TODO FILTER

    for (var e in _selectedStatus) {
      if ((e["KEY"] ?? "") == "P") {
        fil.add({
          "COL_KEY": "STATUS",
          "COL_VAL": "A",
        });
        fil.add({
          "COL_KEY": "STATUS",
          "COL_VAL": "H",
        });
      }
      fil.add({
        "COL_KEY": "STATUS",
        "COL_VAL": (e["KEY"] ?? ""),
      });
    }

    //user

    for (var e in flUserList) {
      fil.add({
        "COL_KEY": "USER_CODE",
        "COL_VAL": (e ?? ""),
      });
    }

    //task

    if (flDocno.trim().isNotEmpty) {
      fil.add({
        "COL_KEY": "DOCNO",
        "COL_VAL": flDocno,
      });
    }

    for (var e in flCompanyList) {
      fil.add({
        "COL_KEY": "CLIENT_ID",
        "COL_VAL": (e ?? ""),
      });
    }

    for (var e in flModuleList) {
      fil.add({
        "COL_KEY": "MODULE",
        "COL_VAL": (e ?? ""),
      });
    }

    for (var e in flDepartment) {
      fil.add({
        "COL_KEY": "DEPARTMENT_CODE",
        "COL_VAL": (e ?? ""),
      });
    }

    for (var e in flPriorityList) {
      fil.add({
        "COL_KEY": "PRIORITY",
        "COL_VAL": (e ?? ""),
      });
    }

    //fixed filter

    for (var e in _groupByItems) {}

    fixedFil.add({
      "COL_KEY": "",
      "COL_VAL": "",
    });

    dynamic response = await apiCall.apiTaskReport(fixedFil,
        setDate(2, fromDate), setDate(2, toDate), fil, g.wstrUserCd, 'N');
    if (mounted) {
      setState(() {
        try {
          _groupByData = response["HEAD"] ?? [];
        } catch (e) {
          _groupByData = [];
          dprint(e);
        }
      });
    }
    dprint('RESPONSE^^^^ $response');
  }

  fnConvertHoursToHMS(double hours) {
    // Find the number of hours
    int fullHours = hours.toInt();
    // Find the remaining minutes
    double remainingHours = hours - fullHours;
    int minutes = (remainingHours * 60).toInt();
    // Find the remaining seconds
    double remainingMinutes = (remainingHours * 60) - minutes;
    int seconds = (remainingMinutes * 60).toInt();
    // Print the result in HH:MM:SS format
    // print('$fullHours:$minutes:$seconds');

    return '$fullHours:$minutes:$seconds';
  }

  fnClearFilters() {
    if (mounted) {
      setState(() {
        flStatus = "";
        flOverDueYn = "N";
        flSortColumn = "";
        flSortColumnName = "";
        flSortColumnDir = "";
        flPriorityList = [];
        flIssueTypeList = [];
        flCompanyList = [];
        flUserList = [];
        flAssignUserFrom = [];
        flAssignUserTo = [];
        flDepartment = [];
        flModuleList = [];
        flSelectedPriority = "";
        flSelectedIssue = "";
        flSelectedModule = "";
        flCreateDate = "";
        flDocno = "";
      });
    }
  }

  fnFilterClear() {
    fnClearFilters();
    if (mounted) {
      setState(() {
        _selectedStatus = [];
        _selectedGroupByItems = [];
      });
      _apiDataFetch();
    }
  }

  Future<void> _selectFilterDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2100));
    if (pickedDate != null) {
      var filDate = setDate(2, pickedDate);
      if (mounted) {
        setState(() {
          flCreateDate = filDate;
        });
        // apiGetTask("F");
      }
    }
  }

  apiGetTaskMasters() {
    futureForm = apiCall.apiGetTaskMasters();
    futureForm.then((value) => apiGetTaskMastersRes(value));
  }

  apiGetTaskMastersRes(value) {
    if (mounted) {
      setState(() {
        if (g.fnValCheck(value)) {
          lstrPriorityList = value["PRIORITY"] ?? [];
          lstrIssueTypeList = value["ISSUE_TYPE"] ?? [];
        }
      });
    }
  }

  apiGetTask(mode) {
    if (mounted) {
      setState(() {
        lstrViewDocno = "";
        if (mode != "P") {
          lstrTaskList = [];
          lstrTaskListPageNo = 0;
        }
        // lstrTaskList =[];
      });
    }

    var sortCol = flSortColumn == "" ? "" : flSortColumnName,
        sortDir = flSortColumn == "" ? "" : flSortColumnDir,
        search = "";
    var client = [],
        task = [],
        issue = [],
        clientType = [],
        status = [],
        userList = [],
        priorityList = [],
        moduleList = [],
        assignFrom = [],
        assignTo = [],
        department = [];
    //userList.add({'COL_VAL':g.wstrUserCd});

    userList = [];
    if (flUserList.isNotEmpty) {
      for (var e in flUserList) {
        userList.add({'COL_VAL': e});
      }
    }
    if (flStatus.isNotEmpty) {
      if (flStatus == "P") {
        status.add({'COL_VAL': flStatus});
        status.add({'COL_VAL': "A"});
        status.add({'COL_VAL': "H"});
      } else {
        status.add({'COL_VAL': flStatus});
      }
    }
    if (flSelectedPriority.isEmpty) {
      if (flPriorityList.isNotEmpty) {
        for (var e in flPriorityList) {
          priorityList.add({'COL_VAL': e});
        }
      }
    } else {
      priorityList.add({'COL_VAL': flSelectedPriority});
    }
    if (flSelectedIssue.isEmpty) {
      if (flIssueTypeList.isNotEmpty) {
        for (var e in flIssueTypeList) {
          issue.add({'COL_VAL': e});
        }
      }
    } else {
      issue.add({'COL_VAL': flSelectedIssue});
    }

    if (flCompanyList.isNotEmpty) {
      for (var e in flCompanyList) {
        client.add({'COL_VAL': e});
      }
    }
    if (flAssignUserFrom.isNotEmpty) {
      for (var e in flAssignUserFrom) {
        assignFrom.add({'COL_VAL': e});
      }
    }

    if (flAssignUserTo.isNotEmpty) {
      for (var e in flAssignUserTo) {
        assignTo.add({'COL_VAL': e});
      }
    }

    if (flDepartment.isNotEmpty) {
      for (var e in flDepartment) {
        department.add({'COL_VAL': e});
      }
    }

    if (flSelectedModule.isEmpty) {
      if (flModuleList.isNotEmpty) {
        for (var e in flModuleList) {
          moduleList.add({'COL_VAL': e});
        }
      }
    } else {
      moduleList.add({'COL_VAL': flSelectedModule});
    }

    var profileYn = "N";
    if (lstrMenuHoverMode == "PROFILE") {
      profileYn = "Y";
    }

    var from = "";
    var to = "";

    from = flCreateDate;
    to = flCreateDate;

    futureForm = apiCall.apiGetTask(
        flDocno.isEmpty ? null : flDocno,
        flDocno.isEmpty ? null : "TASK",
        from.isEmpty ? null : from,
        to.isEmpty ? null : to,
        g.wstrMainClientId,
        "",
        lstrTaskListPageNo,
        sortCol,
        sortDir,
        txtSearch.text,
        client,
        task,
        issue,
        clientType,
        status,
        userList,
        priorityList,
        flOverDueYn,
        moduleList,
        profileYn,
        assignFrom,
        assignTo,
        department);
    futureForm.then((value) => apiGetTaskRes(value, mode));
  }

  apiGetTaskRes(value, mode) {
    if (mounted) {
      setState(() {
        //lstrTaskList =[];
        openTicket = 0;
        closedTicket = 0;
        droppedTicket = 0;
        overdueTicket = 0;
        holdTickets = 0;
        activeTickets = 0;

        fOpenTicket = 0;
        fClosedTicket = 0;
        fDroppedTicket = 0;
        fOverdueTicket = 0;
        fActiveTickets = 0;
        fHoldTickets = 0;

        moduleCount = [];
        priorityCount = [];
        issueCount = [];

        if (g.fnValCheck(value)) {
          if (mode == "P") {
            lstrTaskList += value["TASKS"] ?? [];
          } else {
            lstrTaskList = value["TASKS"] ?? [];
          }

          var taskCount = [];
          var taskCountFilter = [];
          taskCount = value["TASK_COUNT"] ?? [];
          taskCountFilter = value["TASK_COUNT_FILTER"] ?? [];
          if (g.fnValCheck(taskCount)) {
            var active = 0;
            var hold = 0;
            for (var e in taskCount) {
              if (e["STATUS"] == "P") {
                openTicket = e["COUNT"] ?? 0;
              } else if (e["STATUS"] == "C") {
                closedTicket = e["COUNT"] ?? 0;
              } else if (e["STATUS"] == "D") {
                droppedTicket = e["COUNT"] ?? 0;
              } else if (e["STATUS"] == "A") {
                activeTickets = (e["COUNT"] ?? 0);
              } else if (e["STATUS"] == "H") {
                holdTickets = (e["COUNT"] ?? 0);
              }
            }
          }
          if (g.fnValCheck(taskCountFilter)) {
            var active = 0;
            var hold = 0;
            for (var e in taskCountFilter) {
              if (e["STATUS"] == "P") {
                fOpenTicket = e["COUNT"] ?? 0;
              } else if (e["STATUS"] == "C") {
                fClosedTicket = e["COUNT"] ?? 0;
              } else if (e["STATUS"] == "D") {
                fDroppedTicket = e["COUNT"] ?? 0;
              } else if (e["STATUS"] == "A") {
                fActiveTickets = (e["COUNT"] ?? 0);
              } else if (e["STATUS"] == "H") {
                fHoldTickets = (e["COUNT"] ?? 0);
              }
            }
          }
          //OverDue
          var overDueCount = [];
          overDueCount = value["OVERDUE_COUNT"] ?? [];
          if (g.fnValCheck(overDueCount)) {
            overdueTicket = overDueCount[0]["COUNT"] ?? 0;
          }
          //MOduleCount
          moduleCount = value["MODULE_COUNT"] ?? [];
          if (g.fnValCheck(moduleCount)) {
            moduleCount = moduleCount
              ..sort((a, b) => b['COUNT'].compareTo(a['COUNT']));
          }
          priorityCount = value["PRIORITY_COUNT"] ?? [];
          if (g.fnValCheck(priorityCount)) {
            priorityCount = priorityCount
              ..sort((a, b) => b['COUNT'].compareTo(a['COUNT']));
          }
          issueCount = value["ISSUE_COUNT"] ?? [];
          if (g.fnValCheck(issueCount)) {
            issueCount = issueCount
              ..sort((a, b) => b['COUNT'].compareTo(a['COUNT']));
          }
        }
      });
    }
    apiNotification();
  }

  apiNotification() {
    futureForm = apiCall.apiAllNotification(1);
    futureForm.then((value) => apiNotificationRes(value));
  }

  apiNotificationRes(value) {
    if (mounted) {
      setState(() {
        notificationList = [];
        if (g.fnValCheck(value)) {
          notificationList = value;
        }
      });
    }
  }
}

List _colorList = [
  Colors.white,
  Colors.red,
  Colors.red,
  Colors.green,
  Colors.deepOrangeAccent,
  Colors.pink,
  Colors.cyan,
  Colors.blue,
  Colors.indigo,
  Colors.blueGrey,
  Colors.purple,
  Colors.amber,
  Colors.white,
];

Map _groupingData = {};

List _groupByItems = [
  {
    'TITLE': 'TASKNO',
    'RETURN_KEY': 'TASKNO',
    'FILTER_KEY': 'DOCNO',
    'REQUEST_KEY': [
      {
        "COL_KEY": "B.DOCNO",
        "COL_VAL": "TASKNO",
      },
    ],
  },
  {
    'TITLE': 'USER',
    'RETURN_KEY': 'USER_DESP',
    'REQUEST_KEY': [
      {
        "COL_KEY": "A.USER_CODE",
        "COL_VAL": "USER_CODE",
      },
      {
        "COL_KEY": "A.USER_DESP",
        "COL_VAL": "USER_DESP",
      },
    ],
  },
  {
    'TITLE': 'DEPARTMENT',
    'RETURN_KEY': 'DEPARTMENT_DESCP',
    'REQUEST_KEY': [
      {
        "COL_KEY": "D.DEPARTMENT_CODE",
        "COL_VAL": "DEPARTMENT_CODE",
      },
      {
        "COL_KEY": "D.DEPARTMENT_DESCP",
        "COL_VAL": "DEPARTMENT_DESCP",
      },
    ],
  },
  {
    'TITLE': 'DATE',
    'RETURN_KEY': 'DATE',
    'REQUEST_KEY': [
      {
        "COL_KEY": "CAST(A.START_TIME AS DATE)",
        "COL_VAL": "DATE",
      },
    ],
  },
  {
    'TITLE': 'MAIN CLIENT ID',
    'RETURN_KEY': 'MAIN_COMPANY_NAME',
    'REQUEST_KEY': [
      {
        "COL_KEY": "B.MAIN_CLIENT_ID",
        "COL_VAL": "MAIN_CLIENT_ID",
      },
      {
        "COL_KEY": "C.MAIN_COMPANY_NAME",
        "COL_VAL": "MAIN_COMPANY_NAME",
      },
    ],
  },
  {
    'TITLE': 'CLIENT ID',
    'RETURN_KEY': 'CLIENT_NAME',
    'REQUEST_KEY': [
      {
        "COL_KEY": "B.CLIENT_ID",
        "COL_VAL": "CLIENT_ID",
      },
      {
        "COL_KEY": "C.NAME",
        "COL_VAL": "CLIENT_NAME",
      },
    ],
  },
  {
    'TITLE': 'MODULE',
    'RETURN_KEY': 'MODULE',
    'REQUEST_KEY': [
      {
        "COL_KEY": "B.MODULE",
        "COL_VAL": "MODULE",
      },
    ],
  },
  {
    'TITLE': 'ISSUE TYPE',
    'RETURN_KEY': 'ISSUE_DESCP',
    'REQUEST_KEY': [
      {
        "COL_KEY": "B.ISSUE_TYPE",
        "COL_VAL": "ISSUE_TYPE",
      },
      {
        "COL_KEY": "E.DESCP",
        "COL_VAL": "ISSUE_DESCP",
      },
    ],
  },
  {
    'TITLE': 'PRIORITY',
    'RETURN_KEY': 'PRIORITY_DESCP',
    'REQUEST_KEY': [
      {
        "COL_KEY": "B.PRIORITY",
        "COL_VAL": "ISSUE_TYPE",
      },
      {
        "COL_KEY": "F.DESCP",
        "COL_VAL": "PRIORITY_DESCP",
      },
    ],
  },
  {
    'TITLE': 'STATUS',
    'RETURN_KEY': 'STATUS_DESCP',
    'REQUEST_KEY': [
      {
        "COL_KEY": "STATUS",
        "COL_VAL": "CURR_STATUS",
      },
      {
        "COL_KEY": "G.DESCP",
        "COL_VAL": "STATUS_DESCP",
      },
    ],
  },
];

List _selectedGroupByItems = [];
List _selectedStatus = [];

List _groupByData = [];

List _statusData = [
  {"TITLE": "OPEN", "KEY": "P"},
  {"TITLE": "STARTED", "KEY": "S"},
  {"TITLE": "HOLD", "KEY": "H"},
  {"TITLE": "CLOSED", "KEY": "C"},
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
