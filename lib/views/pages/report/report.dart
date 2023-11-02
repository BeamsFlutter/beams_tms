import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
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
  ApiCall apiCall = ApiCall();
  final Global g = Global();

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

  var groupBy  = [
    {
    "TITLE":"USER",
    "KEY":"USER_CODE",
    "PARA":"A.USER_CODE",
    },
    {
      "TITLE":"PRIORITY",
      "KEY":"PRIORITY_DESCP",
      "PARA":"B.PRIORITY",
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
                          if(mounted){
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
                               Icon(blColorWise?
                                Icons.radio_button_checked:Icons.radio_button_off,
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
            FilterHead(
              headList: defaultHeadList,
              dataMap: {
                'grouped': _groupingData,
              },
            ),
            gapHC(10),
            Expanded(child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: lResultList.where((e) => e["GROUP"] == 1).length,
                itemBuilder: (context, index){
                  var data = lResultList.where((e) => e["GROUP"] == 1).toList()[index];
                  return wGroupHead(data);
                }
            ))
          ],
        ),
      ),
    );
  }


  Widget wGroupHead(data){
    var subList = (data["PARENT_DATA"]??[]);
    var title = (data["DATA"]??"");
    var parentKey = (data["PARENT_KEY"]??"");
    var orderNo = data["GROUP"];
    var hour = fnConvertHoursToHMS(g.mfnDbl(data["TIME_HR"])).toString();
    var count = (data["COUNT"]??"").toString();
    var key  = "$title$orderNo$parentKey";
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            setState(() {
              if(lVisibleList.contains(key)){
                lVisibleList.remove(key);
              }else{
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
              padding:  const EdgeInsets.all(10),
              margin: EdgeInsets.only(left: orderNo * 15.0,bottom: 2),
              //_colorList[orderNo].withOpacity(0.1)
              decoration:
              orderNo ==1?boxDecoration(lstrViewKey ==key?yellowLight.withOpacity(0.5):  Colors.white, 5):
              boxBaseDecoration(lstrViewKey ==key?yellowLight.withOpacity(0.5): orderNo >1?blColorWise?_colorList[orderNo].withOpacity(0.1): blueLight: Colors.white, 5),
              child: Row(
                children: [
                  Flexible(
                    flex: 8,
                    child: Row(
                      children: [
                        lVisibleList.contains(key)? const Icon(Icons.arrow_drop_down_sharp,size: 18,): const Icon(Icons.arrow_right_rounded,size: 18,),
                        gapWC(5),
                        orderNo ==1?tc(title, Colors.black, 13):
                        tcn(title, Colors.black, 13),
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        orderNo ==1?tc(count, Colors.black, 13):
                        tcn(count, Colors.black, 13),
                      ],
                    )
                  ),
                  Flexible(
                      flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        orderNo ==1? tc(hour, Colors.black, 13):
                        tcn(hour, Colors.black, 13),
                      ],
                    )
                  ),


                ],
              ),
            ),
          ),
        ),
        // Padding(padding: EdgeInsets.only(left: orderNo * 15.0)
        // ,child:   Divider(color: Colors.grey.shade500,height: 0.2,),),
        lVisibleList.contains(key)?
        Column(
            children: wSubList(title,data,orderNo)
        ):gapHC(0)
      ],
    );
  }

  List<Widget> wSubList(title,data,orderNo){
    List<Widget> rtnList = [];
    var subData = lResultList.where((e) => e["GROUP"] == orderNo+1 && e["PARENT_KEY"] == title).toList();
    for(var e in subData){
      rtnList.add(  wGroupHead(e));
    }
    return rtnList;
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
    _apiDataFetch();
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
              item["TITLE"]?? '',
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

    for(var e in _selectedStatus){
      if((e["KEY"]??"") == "P"){
        fil.add({
          "COL_KEY":"STATUS",
          "COL_VAL": "A",
        });
        fil.add({
          "COL_KEY":"STATUS",
          "COL_VAL": "H",
        });
      }
      fil.add({
        "COL_KEY":"STATUS",
        "COL_VAL": (e["KEY"]??""),
      });
    }


    for (var se in _selectedGroupByItems) {
      for (var seKey in se['REQUEST_KEY']) {
        col.add(seKey);
      }
    }
    dynamic response = await apiCall.apiTaskReport(
        col,
        setDate(2, fromDate),
        setDate(2, toDate),
        fil,
        g.wstrUserCd,
        'N');
    if(mounted){
      setState(() {
        try{
          _groupByData = response["HEAD"]??[];
        }catch (e){
          _groupByData =[];
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
    var parentData = [];
    for (var e in _selectedGroupByItems) {
      var responseKey = (e["RETURN_KEY"] ?? "").toString();
      for (var de in data) {
        if (lResultList
            // .where((re) => re["DATA"] == de[responseKey])
            .where((re) => re['DATA'] == de[responseKey] && (re['PARENT_KEY']??"") == (de[parentKey]??""))
            .toList()
            .isEmpty) {
          //2.ADD TO RESULT DATA
          var count = 0;
          var hour = 0.0;
          var dataSorList = [];
          if (orderNo == 1) {
            dataSorList = data.where((re) => re[responseKey] == de[responseKey]).toList();

            for(var f in dataSorList){
              count += int.parse(f["COUNTS"].toString());
              hour += double.parse(f["TIME_HR"].toString());
            }

            setState(() {
              lResultList.add({
                "GROUP": orderNo,
                "KEY": responseKey,
                "DATA": (de[responseKey] ?? "").toString(),
                "PARENT_KEY": (de[parentKey] ?? "").toString(),
                "PARENT_DATA": dataSorList,
                "TIME_HR": hour,
                "COUNT": count,
              });
            });
          }else{

            var lst = lResultList.where((re) => (re['DATA']??"") == (de[parentKey]??"")).toList();
            if(lst.isNotEmpty){
              parentData =lst[0]["PARENT_DATA"];
              dataSorList = parentData.where((re) => re[responseKey] == de[responseKey]).toList();
            }


            for(var f in dataSorList){
              count += int.parse(f["COUNTS"].toString());
              hour += double.parse(f["TIME_HR"].toString());
            }

            if(parentData.where((pe) => pe == de).toList().isNotEmpty){
              setState(() {
                lResultList.add({
                  "GROUP": orderNo,
                  "KEY": responseKey,
                  "DATA": (de[responseKey] ?? "").toString(),
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
    print('$fullHours:$minutes:$seconds');

    return  '$fullHours:$minutes:$seconds';
  }

  fnFilterClear(){
    if(mounted){
      setState(() {
        _selectedStatus = [];
        _selectedGroupByItems = [];
      });
      _apiDataFetch();
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
  {"TITLE":"OPEN","KEY":"P"},
  {"TITLE":"STARTED","KEY":"S"},
  {"TITLE":"HOLD","KEY":"H"},
  {"TITLE":"CLOSED","KEY":"C"},
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
