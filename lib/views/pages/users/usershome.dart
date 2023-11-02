import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart' as badges;
import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/MQTTClientManager.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/controller/services/apiManager.dart';
import 'package:bams_tms/views/components/PopupLookup/filterPopup.dart';
import 'package:bams_tms/views/components/PopupLookup/searchpopup.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/components/lookup/filterLookup.dart';
import 'package:bams_tms/views/components/lookup/lookup.dart';
import 'package:bams_tms/views/pages/login/login.dart';
import 'package:bams_tms/views/pages/report/report.dart';
import 'package:bams_tms/views/pages/task/createtask.dart';
import 'package:bams_tms/views/pages/task/taskassign.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:local_notifier/local_notifier.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:url_launcher/url_launcher.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class _UserHomeState extends State<UserHome> {
  ScrollController scrollController = ScrollController();
  //final QuillController _controller = QuillController.basic();

  //Global Variables
  Global g = Global();
  var apiCall = ApiCall();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final record = Record();
  late Future<dynamic> futureForm;
  var wstrPageForm = [];
  var sideNavigation = "";
  late Timer timer;
  var notificationList = [];

  //Page Variables
  var blSearch = false;
  var blSideScreen = true;
  var lstrMenuHoverMode = "PROFILE";
  var lstrToday = DateTime.now();
  var lstrTaskList = [];
  var lstrTaskListPageNo = 0;
  var lstrTaskListViewMode = "L";
  var lstrCompanyList = [];
  var lstrModuleList = [];
  var lstrPriorityList = [];
  var lstrStatusList = [];
  var lstrIssueTypeList = [];

  //TaskCount
  var openTicket = 0;
  var closedTicket = 0;
  var droppedTicket = 0;
  var overdueTicket = 0;
  var activeTickets = 0;
  var holdTickets = 0;

  var fOpenTicket = 0;
  var fClosedTicket = 0;
  var fDroppedTicket = 0;
  var fOverdueTicket = 0;
  var fActiveTickets = 0;
  var fHoldTickets = 0;

  var moduleCount = [];
  var priorityCount = [];
  var issueCount = [];

  //TaskData
  var lstrTTaskMode = "ADD";
  var lstrTSubTaskOf = "";
  var lstrTTaskDocno = "";
  var lstrTTaskDoctype = "";
  var lstrTMainCompanyCode = "";
  var lstrTMainCompany = "";
  var lstrTCompany = "";
  var lstrTCompanyCode = "";
  var lstrTCompanyId = "";
  var lstrTModule = "";
  var lstrTPlatForms = [];
  var lstrDocument = [];
  var lstrTCreatedBY = "";
  var lstrTPriority = "";
  var lstrTPriorityCode = "";
  var lstrTIssueType = "";
  var lstrTIssueTypeCode = "";
  var lstrTStatus = "";
  var lstrTLastStatus = "";
  var blSaveTask = false;
  var lstrDeadlineDate = DateTime.now();
  var lstrTPrvDocno = "";
  var lstrViewDocno = "";
  var lstrBDeadLine = false;
  var completionUser = "";
  var closedDate = DateTime.now();
  var taskOptions = "A";
  var lstrTaskComments = [];
  var lstrTaskTimeLine = [];

  //Task Assign
  var lstrAssignDocno = "";
  var lstrAssignDoctype = "";

  //Task Filter
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

  var txtTaskHead = TextEditingController();
  var txtTaskDescp = TextEditingController();
  var txtTaskCompletionNote = TextEditingController();
  var txtContactPeron = TextEditingController();
  var txtMobile = TextEditingController();
  var txtEmail = TextEditingController();
  var txtComment = TextEditingController();
  var txtHoldNote = TextEditingController();
  var txtAssignNote = TextEditingController();

  //Controller
  var txtController = TextEditingController();
  var txtSearch = TextEditingController();

  //File Upload
  List<File> lstrFiles = [];
  var lstrRemoveAttachment;

  //MQTT
  MQTTClientManager mqttClientManager = MQTTClientManager();
  final String pubTopic = "BEAMS_NOTY/";

  @override
  void initState() {
    // TODO: implement initState

    setupMqttClient();
    setupUpdatesListener();

    fnGetPageData();
    timer =
        Timer.periodic(const Duration(seconds: 300), (Timer t) => fnRefresh);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    mqttClientManager.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      endDrawer: sideNavigation == "T"
          ? Container(
              width: size.width * 0.9,
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      //apiGetTask();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 30),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      decoration: boxGradientDecorationBaseC(24, 30, 0, 30, 0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 15,
                          ),
                          gapWC(10),
                          tcn('Ticket', Colors.white, 15),
                        ],
                      ),
                    ),
                  ),
                  //Expanded(child: wTaskCard()),
                  Expanded(
                      child: NewTask(
                    pageMode: lstrTTaskMode,
                    wMainClienId: lstrTMainCompanyCode,
                    wDoco: lstrTTaskDocno,
                    wDoctype: lstrTTaskDoctype,
                    fnGetTask: apiGetTask,
                    wSubOfDocno: lstrTSubTaskOf,
                    fnSubTaskCall: fnSubTaskCall,
                  )),
                ],
              ),
            )
          : sideNavigation == "M"
              ? Container(
                  width: 400,
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: TaskAssign(
                        fnCallBack: fnTaskCallBack,
                      ))
                    ],
                  ),
                )
              : sideNavigation == "TL"
                  ? Container(
                      width: 500,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Expanded(child: wTaskTimeLine())],
                      ),
                    )
                  : Container(
                      width: 350,
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Expanded(child: wFilterCard())],
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
                Container(
                  width: 180,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(
                      left: 10, right: 5, top: 5, bottom: 10),
                  decoration: boxBaseDecoration(Colors.black, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: boxGradientDecoration(22, 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: tc('TM', Colors.white, 15),
                      ),
                      gapHC(20),
                      g.wstrUserRole == "ADMIN" ||
                              g.wstrUserRole == "DEPHEAD" ||
                              g.wstrUserRole == "SUPER"
                          ? wMenuCard(
                              Icons.home_outlined,
                              g.wstrUserRole == "DEPHEAD"
                                  ? g.wstrUserDepartmentDescp.toString()
                                  : "Home",
                              "H")
                          : gapHC(0),
                      wMenuCard(Icons.account_circle, "My Profile", "PROFILE"),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              wMenuCard(
                                  Icons.view_module_outlined, "Module", "M"),
                              moduleCount.isNotEmpty
                                  ? Container(
                                      decoration:
                                          boxDecoration(Colors.white, 5),
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: wModuleCount(),
                                      ),
                                    )
                                  : gapHC(0),
                              gapHC(10),
                              wMenuCard(Icons.local_fire_department_rounded,
                                  "Priority", "P"),
                              priorityCount.isNotEmpty
                                  ? Container(
                                      decoration:
                                          boxDecoration(Colors.white, 5),
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: wPriorityCount(),
                                      ),
                                    )
                                  : gapHC(0),
                              gapHC(10),
                              wMenuCard(Icons.error, "Issue", "I"),
                              issueCount.isNotEmpty
                                  ? Container(
                                      decoration:
                                          boxDecoration(Colors.white, 5),
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: wIssueCount(),
                                      ),
                                    )
                                  : gapHC(0)
                            ],
                          ),
                        ),
                      ),
                      // gapHC(10),
                      // Bounce(
                      //   duration: const Duration(milliseconds: 110),
                      //   onPressed: (){
                      //     Get.to(const Activation());
                      //   },
                      //   child: Container(
                      //     decoration: boxOutlineCustom1(Colors.black, 30, greyLight.withOpacity(0.5), 1.0),
                      //     padding: const EdgeInsets.all(10),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         tcn('Activation', Colors.white, 12),
                      //         gapWC(5),
                      //         const Icon(Icons.notifications_active_outlined ,color: Colors.white,size: 14,)
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      gapHC(10),
                      // TODO REPORTS BUTTON
                      Bounce(
                        duration: const Duration(milliseconds: 110),
                        onPressed: () {
                          dprint('REPORTS');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ReportScreen()));
                        },
                        child: Container(
                          decoration: boxGradientDecorationBase(7, 30),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              tcn1('Reports', Colors.white, 12),
                              gapWC(5),
                              const Icon(
                                Icons.bubble_chart_outlined,
                                color: Colors.white,
                                size: 14,
                              )
                            ],
                          ),
                        ),
                      ),
                      gapHC(10),
                      Bounce(
                        duration: const Duration(milliseconds: 110),
                        onPressed: () {
                          fnLogOut1();
                        },
                        child: Container(
                          decoration: boxOutlineCustom1(Colors.black, 30,
                              greyLight.withOpacity(0.5), 1.0),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              tcn1('Sign Out', Colors.white, 12),
                              gapWC(5),
                              const Icon(
                                Icons.power_settings_new,
                                color: Colors.white,
                                size: 14,
                              )
                            ],
                          ),
                        ),
                      ),
                      gapHC(10),
                    ],
                  ),
                ),
                Flexible(
                  flex: 8,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(),
                        Container(
                          decoration: boxDecoration(
                              g.wstrDarkMode ? Colors.black : Colors.white, 10),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Bounce(
                                    duration: const Duration(milliseconds: 110),
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          lstrTaskListPageNo = 0;
                                        });
                                      }
                                      apiGetTask("");
                                    },
                                    child: Image.asset(
                                      g.wstrDarkMode
                                          ? "assets/images/namewhite.png"
                                          : "assets/images/nameblack.png",
                                      width: 150,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Bounce(
                                        duration:
                                            const Duration(milliseconds: 110),
                                        onPressed: () {
                                          if (mounted) {
                                            setState(() {
                                              sideNavigation = "T";
                                              lstrTSubTaskOf = "";
                                            });
                                          }
                                          fnNewTask();
                                          scaffoldKey.currentState
                                              ?.openEndDrawer();
                                        },
                                        child: Container(
                                          decoration:
                                              boxGradientDecorationBase(24, 30),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              gapWC(10),
                                              Container(
                                                height: 15,
                                                width: 1,
                                                decoration: boxBaseDecoration(
                                                    greyLight.withOpacity(0.7),
                                                    10),
                                              ),
                                              gapWC(10),
                                              tcn1('New Task    ', Colors.white,
                                                  14)
                                            ],
                                          ),
                                        ),
                                      ),
                                      gapWC(10),
                                      Container(
                                        decoration:
                                            boxBaseDecoration(greyLight, 5),
                                        padding: const EdgeInsets.all(3),
                                        child: Row(
                                          children: [
                                            wDayMode(
                                                Icons.light_mode_outlined, "A"),
                                            gapWC(5),
                                            wDayMode(
                                                Icons.dark_mode_outlined, "D"),
                                          ],
                                        ),
                                      ),
                                      gapWC(15),

                                      gapWC(15),
                                      // GestureDetector(
                                      //   onTap: (){
                                      //     fnLogOut1();
                                      //   },
                                      //   child: const Icon(Icons.logout,color: Colors.blueGrey,size: 20,)),
                                      // gapWC(10),
                                      blSideScreen
                                          ? Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                              decoration: boxOutlineCustom1(
                                                  Colors.white,
                                                  5,
                                                  Colors.grey.withOpacity(0.5),
                                                  0.5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      tcn(
                                                          g.wstrUserCd
                                                              .toString(),
                                                          Colors.black,
                                                          10),
                                                      tc(
                                                          g.wstrUserName
                                                              .toString(),
                                                          Colors.black,
                                                          12)
                                                    ],
                                                  ),
                                                  gapWC(30),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration:
                                                        boxBaseDecoration(
                                                            color2, 30),
                                                    child: const Icon(
                                                      Icons.person,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : gapHC(0),
                                      gapWC(10),
                                      GestureDetector(
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              blSideScreen =
                                                  blSideScreen ? false : true;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          blSideScreen
                                              ? Icons.navigate_before
                                              : Icons.navigate_next_rounded,
                                          color: Colors.blueGrey,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        gapHC(10),
                        Row(
                          children: [
                            Flexible(
                              child: Bounce(
                                duration: const Duration(milliseconds: 110),
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      lstrTaskListPageNo = 0;
                                      flStatus = "";
                                      flOverDueYn = "N";
                                    });
                                  }
                                  apiGetTask("");
                                },
                                child: Container(
                                  decoration: boxDecoration(Colors.white, 5),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.list,
                                        color: color2,
                                        size: 30,
                                      ),
                                      gapWC(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          tc(
                                              (openTicket +
                                                      closedTicket +
                                                      droppedTicket +
                                                      holdTickets +
                                                      activeTickets)
                                                  .toString(),
                                              color2,
                                              25),
                                          tcn1('Total Task  ', color3, 12),
                                          tcn1(
                                              'Filter ${(fOpenTicket + fClosedTicket + fDroppedTicket + fHoldTickets + fActiveTickets).toString()}  ',
                                              Colors.blueAccent,
                                              12),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            gapWC(5),
                            Flexible(
                              child: Bounce(
                                duration: const Duration(milliseconds: 110),
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      lstrTaskListPageNo = 0;
                                      flStatus = "P";
                                      flOverDueYn = "N";
                                    });
                                  }
                                  apiGetTask("");
                                },
                                child: Container(
                                  decoration: boxDecoration(Colors.white, 5),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.task_alt,
                                        color: Colors.green,
                                        size: 30,
                                      ),
                                      gapWC(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          tc(
                                              (openTicket +
                                                      activeTickets +
                                                      holdTickets)
                                                  .toString(),
                                              Colors.green,
                                              25),
                                          tcn1('Open Task  ', color3, 12),
                                          tcn1(
                                              'Filter ${(fActiveTickets + fHoldTickets + fOpenTicket).toString()}  ',
                                              Colors.blueAccent,
                                              12)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            gapWC(5),
                            Flexible(
                              child: Bounce(
                                duration: const Duration(milliseconds: 110),
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      lstrTaskListPageNo = 0;
                                      flStatus = "A";
                                      flOverDueYn = "N";
                                    });
                                  }
                                  apiGetTask("");
                                },
                                child: Container(
                                  decoration: boxDecoration(Colors.white, 5),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.play_circle_outline_sharp,
                                        color: color2,
                                        size: 30,
                                      ),
                                      gapWC(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          tc(activeTickets.toString(), color2,
                                              25),
                                          tcn1('Started  ', color3, 12),
                                          tcn1(
                                              'Filter ${fActiveTickets.toString()}  ',
                                              Colors.blueAccent,
                                              12)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            gapWC(5),
                            Flexible(
                              child: Bounce(
                                duration: const Duration(milliseconds: 110),
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      lstrTaskListPageNo = 0;
                                      flStatus = "H";
                                      flOverDueYn = "N";
                                    });
                                  }
                                  apiGetTask("");
                                },
                                child: Container(
                                  decoration: boxDecoration(Colors.white, 5),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.pause,
                                        color: Colors.orange,
                                        size: 30,
                                      ),
                                      gapWC(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          tc(holdTickets.toString(),
                                              Colors.orange, 25),
                                          tcn1('Hold  ', color3, 12),
                                          tcn1(
                                              'Filter ${fHoldTickets.toString()}  ',
                                              Colors.blueAccent,
                                              12)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            gapWC(5),
                            Flexible(
                              child: Bounce(
                                duration: const Duration(milliseconds: 110),
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      lstrTaskListPageNo = 0;
                                      flStatus = "C";
                                      flOverDueYn = "N";
                                    });
                                  }
                                  apiGetTask("");
                                },
                                child: Container(
                                  decoration: boxDecoration(Colors.white, 5),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.thumb_up_alt_outlined,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                      gapWC(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          tc(closedTicket.toString(),
                                              Colors.red, 25),
                                          tcn1('Closed Task  ', color3, 12),
                                          tcn1(
                                              'Filter ${fClosedTicket.toString()}  ',
                                              Colors.blueAccent,
                                              12)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // gapWC(5),
                            // Flexible(
                            //   child: Bounce(
                            //     duration: const Duration(milliseconds: 110),
                            //     onPressed: (){
                            //       if(mounted){
                            //         setState(() {
                            //           lstrTaskListPageNo = 0;
                            //           flStatus = "D";
                            //           flOverDueYn = "N";
                            //         });
                            //       }
                            //       apiGetTask("");
                            //     },
                            //     child: Container(
                            //       decoration: boxDecoration(Colors.white, 5),
                            //       padding: const EdgeInsets.all(10),
                            //       child: Row(
                            //         children: [
                            //           const Icon(Icons.cancel_outlined,color: Colors.purple,size: 30,),
                            //           gapWC(10),
                            //           Column(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               tc(droppedTicket.toString(), Colors.purple , 25),
                            //               ts('Dropped Task ', color3 , 12)
                            //             ],
                            //           )
                            //
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            gapWC(5),
                            Flexible(
                              child: Bounce(
                                duration: const Duration(milliseconds: 110),
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      lstrTaskListPageNo = 0;
                                      flStatus = "";
                                      flOverDueYn = "Y";
                                    });
                                  }
                                  apiGetTask("");
                                },
                                child: Container(
                                  decoration: boxDecoration(Colors.white, 5),
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.upcoming,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                      gapWC(10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          tc(overdueTicket.toString(),
                                              Colors.red, 25),
                                          tcn1('Overdue ', Colors.red, 12),
                                          tcn1(
                                              'Filter ${fOverdueTicket.toString()}  ',
                                              Colors.blueAccent,
                                              12)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        gapHC(10),
                        Container(
                          margin: const EdgeInsets.only(bottom: 1),
                          padding: const EdgeInsets.all(5),
                          decoration: boxDecoration(Colors.white, 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  !blSearch
                                      ? tc(
                                          'Task Details', Colors.deepOrange, 15)
                                      : gapHC(0),
                                  gapWC(10),
                                  !blSearch && flStatus.isNotEmpty
                                      ? tc(
                                          flOverDueYn == "Y"
                                              ? "Overdue Task"
                                              : flStatus == "P"
                                                  ? "Open Task"
                                                  : flStatus == "C"
                                                      ? "Closed Task"
                                                      : flStatus == "D"
                                                          ? "Dropped Task"
                                                          : "",
                                          Colors.black,
                                          15)
                                      : gapHC(0),
                                  blSearch
                                      ? Expanded(
                                          child: Container(
                                            height: 30,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: TextFormField(
                                              controller: txtSearch,
                                              onChanged: (val) {
                                                if (mounted) {
                                                  setState(() {
                                                    lstrTaskListPageNo = 0;
                                                  });
                                                }
                                                apiGetTask("");
                                              },
                                              decoration: const InputDecoration(
                                                hintText: 'Search....',
                                                border: InputBorder.none,
                                              ),
                                            ),
                                          ),
                                        )
                                      : gapHC(0),
                                  Row(
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                txtSearch.clear();
                                                blSearch =
                                                    blSearch ? false : true;
                                                lstrTaskListPageNo = 0;
                                              });

                                              apiGetTask("");
                                            }
                                          },
                                          child: Icon(
                                            blSearch
                                                ? Icons.close
                                                : Icons.search,
                                            color: Colors.blueGrey,
                                            size: 20,
                                          )),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 10),
                                        child: Row(
                                          children: [
                                            wTaskListViewIcon(
                                                Icons.view_kanban_outlined,
                                                "K"),
                                            gapWC(5),
                                            wTaskListViewIcon(Icons.list, "L"),
                                            gapWC(5),
                                            wTaskListViewIcon(
                                                Icons.grid_view_rounded, "G"),
                                          ],
                                        ),
                                      ),

                                      gapWC(20),
                                      Bounce(
                                          onPressed: () {
                                            if (mounted) {
                                              setState(() {
                                                sideNavigation = "T";
                                                lstrTSubTaskOf = "";
                                              });
                                            }
                                            fnNewTask();
                                            scaffoldKey.currentState
                                                ?.openEndDrawer();
                                          },
                                          duration:
                                              const Duration(milliseconds: 110),
                                          child: const Icon(
                                            Icons.add_circle_outlined,
                                            color: Colors.deepOrange,
                                            size: 20,
                                          )),
                                      gapWC(10),
                                      Bounce(
                                          onPressed: () {
                                            if (mounted) {
                                              setState(() {
                                                sideNavigation = "F";
                                              });
                                            }
                                            scaffoldKey.currentState
                                                ?.openEndDrawer();
                                          },
                                          duration:
                                              const Duration(milliseconds: 110),
                                          child: const Icon(
                                            Icons.filter_list_alt,
                                            color: Colors.deepOrange,
                                            size: 20,
                                          )),
                                      gapWC(20),

                                      Bounce(
                                        onPressed: () {
                                          if (mounted) {
                                            var filDate =
                                                setDate(2, DateTime.now());
                                            setState(() {
                                              flCreateDate = filDate;
                                            });
                                          }
                                          apiGetTask("F");
                                        },
                                        duration:
                                            const Duration(milliseconds: 110),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          decoration:
                                              boxGradientDecorationBase(7, 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                color: Colors.white,
                                                size: 12,
                                              ),
                                              gapWC(5),
                                              tcn1('Today', Colors.white, 12),
                                            ],
                                          ),
                                        ),
                                      ),
                                      gapWC(10),
                                      Bounce(
                                        onPressed: () {
                                          //fnExport();
                                          apiGetTaskExport();
                                          //fnShowNotification("msg");
                                        },
                                        duration:
                                            const Duration(milliseconds: 110),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          decoration:
                                              boxGradientDecorationBase(6, 30),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                          fnFilterClear();
                                          apiGetTask("");
                                        },
                                        duration:
                                            const Duration(milliseconds: 110),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 4),
                                          decoration: boxOutlineCustom1(
                                              Colors.white,
                                              30,
                                              Colors.black,
                                              0.5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: [
                                      //     GestureDetector(
                                      //         onTap: (){
                                      //           // if(lstrTaskListPageNo == 0){
                                      //           //   return;
                                      //           // }
                                      //           // if(mounted){
                                      //           //   setState(() {
                                      //           //     lstrTaskListPageNo =lstrTaskListPageNo-1;
                                      //           //   });
                                      //           //   apiGetTask("");
                                      //           // }
                                      //         },
                                      //         child: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,size: 15,)),
                                      //     gapWC(10),
                                      //     lstrTaskList.isNotEmpty?
                                      //     GestureDetector(
                                      //         onTap: (){
                                      //           // if(mounted){
                                      //           //   setState(() {
                                      //           //     if(lstrTaskList.isNotEmpty){
                                      //           //       lstrTaskListPageNo =lstrTaskListPageNo+1;
                                      //           //     }
                                      //           //
                                      //           //   });
                                      //           //   apiGetTask("");
                                      //           // }
                                      //         },
                                      //         child: const Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,size: 15,)):gapHC(0),
                                      //   ],
                                      // )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          padding: const EdgeInsets.all(5),
                          decoration: boxDecoration(Colors.white, 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  wRowHead("Task", "DOCNO", 3, "Y"),
                                  wRowHead("Issue", "ISSUE_TYPE", 1, "Y"),
                                  wRowHead("Company", "COMPANY_NAME", 2, "Y"),
                                  wRowHead("Module", "MODULE", 1, "Y"),
                                  wRowHead("Department", "DEPARTMENT", 1, "Y"),
                                  wRowHead("Status", "STATUS", 1, "Y"),
                                  wRowHead(
                                      "Create Date", "CREATE_DATE", 1, "Y"),
                                  //wRowHead("Deadline","DEADLINE",1,"Y"),
                                  wRowHead("Active User", "ACTIVE", 1, "Y"),
                                  //wRowHead("Assigned By","ASSIGNED_USER",1,"Y"),
                                  wRowHead("Created By", "CREATE_USER", 1, "Y"),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: wTaskList(),
                            ),
                          ),
                        ),
                        gapHC(20)
                      ],
                    ),
                  ),
                ),
                blSideScreen
                    ? Container(
                        decoration: boxDecoration(Colors.white, 10),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Bounce(
                              duration: const Duration(milliseconds: 110),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    blSideScreen = false;
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                decoration: boxGradientDecorationBase(11, 100),
                                child: const Icon(
                                  Icons.account_circle,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            gapHC(10),
                            notificationList
                                    .where((e) => e["READ_YN"] != "Y")
                                    .isNotEmpty
                                ? badges.Badge(
                                    position: badges.BadgePosition.topEnd(
                                        end: -3, top: -9),
                                    badgeColor: Colors.redAccent,
                                    padding: const EdgeInsets.all(6),
                                    badgeContent: tcn1(
                                        ((notificationList.where(
                                                    (e) => e["READ_YN"] != "Y"))
                                                .length)
                                            .toString(),
                                        Colors.white,
                                        12),
                                    child: Bounce(
                                      duration:
                                          const Duration(milliseconds: 110),
                                      onPressed: () {
                                        if (mounted) {
                                          setState(() {
                                            blSideScreen = false;
                                          });
                                        }
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: boxOutlineCustom1(
                                            Colors.white, 5, color2, 1.0),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: const Icon(
                                          Icons.notifications_none,
                                          color: color2,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                : Bounce(
                                    duration: const Duration(milliseconds: 110),
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          blSideScreen = false;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: boxOutlineCustom1(
                                          Colors.white, 5, color2, 1.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: const Icon(
                                        Icons.notifications_none,
                                        color: color2,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                            gapHC(10),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: boxOutlineCustom1(
                                  Colors.white, 5, color2, 1.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: const Icon(
                                Icons.access_time_outlined,
                                color: color2,
                                size: 18,
                              ),
                            ),
                            Expanded(
                                child: Column(
                              children: [],
                            )),
                            Container(
                              width: 40,
                              height: 40,
                              decoration:
                                  boxBaseDecoration(Colors.blueGrey, 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: const Icon(
                                Icons.support_agent,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            gapHC(5),
                            Container(
                              width: 40,
                              height: 40,
                              decoration:
                                  boxBaseDecoration(Colors.blueGrey, 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: const Icon(
                                Icons.help_outline,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            gapHC(10),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: boxOutlineCustom1(
                                  Colors.white, 5, color2, 1.0),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: const Icon(
                                Icons.search,
                                color: color2,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Flexible(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: boxBaseDecoration(Colors.white, 0),
                          child: Column(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Row(),
                                  Bounce(
                                    duration: const Duration(milliseconds: 110),
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          blSideScreen =
                                              blSideScreen ? false : true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 70,
                                      width: 70,
                                      decoration:
                                          boxGradientDecorationBase(7, 100),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: tc(
                                          g.wstrUserName
                                              .toString()
                                              .substring(0, 2)
                                              .toUpperCase(),
                                          Colors.white,
                                          20),
                                    ),
                                  ),
                                  gapHC(5),
                                  tc(g.wstrUserName.toString().toUpperCase(),
                                      Colors.black, 14),
                                  tcn(g.wstrUserCd.toString(),
                                      Colors.black.withOpacity(0.6), 10),
                                  tcn(g.wstrUserDepartmentDescp.toString(),
                                      Colors.black, 10),
                                  gapHC(10),
                                  Container(
                                    decoration:
                                        boxBaseDecoration(Colors.orange, 20),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 2,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                        gapWC(5),
                                        tcn1('Profile', Colors.white, 14),
                                        // gapWC(5),
                                      ],
                                    ),
                                  ),
                                  gapHC(10),
                                  Expanded(
                                    child: Container(
                                      decoration: boxOutlineCustom1(
                                          Colors.white, 10, greyLight, 1.0),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .circle_notifications_outlined,
                                                    color: color3,
                                                    size: 20,
                                                  ),
                                                  gapWC(5),
                                                  tc('Notification', color3,
                                                      12),
                                                  gapWC(5),
                                                  notificationList
                                                          .where((e) =>
                                                              e["READ_YN"] !=
                                                              "Y")
                                                          .isNotEmpty
                                                      ? Container(
                                                          decoration:
                                                              boxDecoration(
                                                                  Colors.red,
                                                                  5),
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 2),
                                                          child: tcn(
                                                              ((notificationList
                                                                      .where((e) =>
                                                                          e["READ_YN"] !=
                                                                          "Y")).length)
                                                                  .toString(),
                                                              Colors.white,
                                                              8),
                                                        )
                                                      : gapHC(0)
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
                                          lineC(1.0, greyLight),
                                          gapHC(5),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: wNotification(),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  gapHC(5),
                                  Expanded(
                                      child: Container(
                                    decoration: boxOutlineCustom1(
                                        Colors.white, 10, greyLight, 1.0),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.task_alt,
                                                  color: color3,
                                                  size: 20,
                                                ),
                                                gapWC(5),
                                                tc('Last Activity', color3, 12),
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
                                        lineC(1.0, greyLight)
                                      ],
                                    ),
                                  ))
                                ],
                              )),
                              gapHC(10),
                              Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      decoration:
                                          boxBaseDecoration(Colors.green, 5),
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.support_agent,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          gapWC(10),
                                          tcn1('Chat', Colors.white, 14),
                                          gapWC(5),
                                        ],
                                      ),
                                    ),
                                  ),
                                  gapWC(5),
                                  Flexible(
                                    child: Container(
                                      decoration:
                                          boxBaseDecoration(Colors.blueGrey, 5),
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.help_outline_rounded,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                          gapWC(10),
                                          tcn1('Help', Colors.white, 14),
                                          gapWC(5),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              gapHC(10),
                              Bounce(
                                duration: const Duration(milliseconds: 110),
                                onPressed: () {},
                                child: Container(
                                    decoration: boxOutlineCustom1(
                                        Colors.white, 5, color2, 1.0),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.search,
                                          color: color2,
                                          size: 15,
                                        ),
                                        gapWC(10),
                                        tcn1('Enquiry', color2, 14)
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  //======================================WIDGET

  //TaskList
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
          apiGetTaskDet(mainClientId, docno, doctype);
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
                            ? PopupMenuButton<Menu>(
                                enabled: false,
                                position: PopupMenuPosition.under,
                                tooltip: "",
                                onSelected: (Menu item) {},
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<Menu>>[
                                  PopupMenuItem<Menu>(
                                    value: Menu.itemOne,
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
                                          apiUpdateTask(
                                              docno,
                                              doctype,
                                              changeSts,
                                              issueTypeCode,
                                              priorityCode);
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
                          Bounce(
                            duration: const Duration(milliseconds: 110),
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
                            child: wSettingsCard(Icons.access_time),
                          ),
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
                          Row(
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
                                              fnNewTask();
                                              scaffoldKey.currentState
                                                  ?.openEndDrawer();
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
                          ),
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

  Widget wTaskListViewIcon(icon, mode) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: () {
        if (mounted) {
          setState(() {
            lstrTaskListViewMode = mode;
          });
        }
      },
      child: Container(
        decoration: lstrTaskListViewMode == mode
            ? boxDecoration(Colors.white, 5)
            : boxBaseDecoration(Colors.transparent, 2),
        padding: const EdgeInsets.all(3),
        child: Icon(icon,
            size: 20,
            color: lstrTaskListViewMode == mode
                ? Colors.deepOrange
                : Colors.black),
      ),
    );
  }

  Widget wRowHead(title, column, flex, sortYn) {
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
                                      decoration: boxBaseDecoration(color2, 5),
                                      child: tcn(
                                          (column == "PRIORITY"
                                                  ? flPriorityList.length
                                                  : column == "ISSUE_TYPE"
                                                      ? flIssueTypeList.length
                                                      : column == "COMPANY_NAME"
                                                          ? flCompanyList.length
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
                                      ? const Icon(Icons.arrow_downward_rounded,
                                          size: 10)
                                      : const Icon(Icons.arrow_upward_sharp,
                                          size: 10),
                                  gapWC(2),

                                  PopupMenuButton<Menu>(
                                    position: PopupMenuPosition.under,
                                    tooltip: "",
                                    onSelected: (Menu item) {
                                      setState(() {});
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry<Menu>>[
                                      PopupMenuItem<Menu>(
                                        value: Menu.itemOne,
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
  }

  Widget wRowDet(child, flex) {
    return Flexible(
        flex: flex,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Row(), child],
        ));
  }

  Widget wDayMode(icon, mode) {
    var pageMode = g.wstrDarkMode ? "D" : "A";
    return Bounce(
      onPressed: () {
        setState(() {
          g.wstrDarkMode = (mode == "D" ? true : false);
        });
      },
      duration: const Duration(milliseconds: 110),
      child: Container(
        decoration: pageMode == mode
            ? boxDecoration(Colors.white, 5)
            : boxBaseDecoration(greyLight.withOpacity(0.1), 5),
        padding: const EdgeInsets.all(5),
        child: Icon(
          icon,
          color: pageMode == mode ? Colors.orange : Colors.black,
          size: 15,
        ),
      ),
    );
  }

  Widget wMenuCard(icon, text, mode) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: () {
        if (mounted) {
          setState(() {
            lstrMenuHoverMode = mode;
            flCompanyList = [];
            flPriorityList = [];
            flIssueTypeList = [];
            flModuleList = [];
            flAssignUserFrom = [];
            flAssignUserTo = [];
            flDepartment = [];
            flCreateDate = "";
            flDocno = "";

            flSelectedPriority = "";
            flSelectedIssue = "";
            flSelectedModule = "";
          });

          apiGetTask("");
        }
      },
      child: InkWell(
        onHover: (v) {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: lstrMenuHoverMode == mode
                  ? boxBaseDecoration(greyLight.withOpacity(0.3), 10)
                  : boxBaseDecoration(Colors.transparent, 0),
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
            apiGetTask("");
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
            apiGetTask("");
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
            apiGetTask("");
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
            apiGetTask("");
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
            apiGetTask("");
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
            apiGetTask("");
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
              apiGetTask("");
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
              apiGetTask("");
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
              apiGetTask("");
            }
          }
        },
        searchYn: 'Y',
      );
    } else if (mode == "CREATE_DATE") {
      return Container(
        width: 300,
        padding: EdgeInsets.all(10),
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
                  apiGetTask("");
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

  Widget wSettingsCard(icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: boxDecoration(Colors.white, 5),
      child: Icon(
        icon,
        color: color2,
        size: 18,
      ),
    );
  }

  //Task Hold Popup
  Widget wHoldPopup(docno, doctype) {
    txtHoldNote.clear();
    return Container(
      decoration: boxBaseDecoration(Colors.white, 0),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tcn('* please fill hold note', Colors.black, 10),
          gapHC(5),
          Container(
            width: 500,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: boxOutlineCustom1(Colors.white, 5, Colors.grey, 0.5),
            child: TextFormField(
              controller: txtHoldNote,
              autofocus: true,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.visiblePassword,
              minLines: 5,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Hold Note',
                hintStyle: GoogleFonts.poppins(fontSize: 12),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
          gapHC(10),
          Bounce(
            onPressed: () {
              if (txtHoldNote.text.isEmpty) {
                return;
              } else {
                apiHoldTask(docno, doctype, txtHoldNote.text);
              }
            },
            duration: const Duration(milliseconds: 110),
            child: Container(
              decoration: boxBaseDecoration(Colors.deepOrange, 30),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 12,
                  ),
                  gapWC(5),
                  tcn('HOLD', Colors.white, 10)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //Finish Popup
  Widget wFinishPopup(docno, doctype) {
    txtHoldNote.clear();
    return Container(
      decoration: boxBaseDecoration(Colors.white, 0),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tcn('* please fill finish note', Colors.black, 10),
          gapHC(5),
          Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: boxOutlineCustom1(Colors.white, 5, Colors.grey, 0.5),
            child: TextFormField(
              controller: txtHoldNote,
              autofocus: true,
              style: GoogleFonts.poppins(
                  fontSize: 12, fontWeight: FontWeight.w500),
              keyboardType: TextInputType.visiblePassword,
              minLines: 5,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Finish Note',
                hintStyle: GoogleFonts.poppins(fontSize: 12),
                border: InputBorder.none,
              ),
              onChanged: (val) {
                if (mounted) {
                  setState(() {});
                }
              },
            ),
          ),
          gapHC(10),
          Bounce(
            onPressed: () {
              if (txtHoldNote.text.isEmpty) {
                return;
              } else {
                apiFinishTask(docno, doctype, txtHoldNote.text);
              }
            },
            duration: const Duration(milliseconds: 110),
            child: Container(
              decoration: boxBaseDecoration(Colors.green, 30),
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.task_alt,
                    color: Colors.white,
                    size: 12,
                  ),
                  gapWC(5),
                  tcn('FINISH', Colors.white, 10)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //Task TimeLine
  List<Widget> wTaskTimeLineList() {
    List<Widget> rtnList = [];
    var srno = 1;
    for (var e in lstrTaskTimeLine) {
      var action = e["NOTE"] ?? "";
      var actionUser = e["USER_CODE"] ?? "";
      var actionDate = e["ACTION_DATE"] ?? "";
      var actionCheckDate =
          actionDate == "" ? "" : setDate(6, DateTime.parse(actionDate));
      var actionViewDate =
          actionDate == "" ? "" : setDate(7, DateTime.parse(actionDate));
      var now = setDate(6, DateTime.now());
      if (now == actionCheckDate) {
        actionViewDate =
            actionDate == "" ? "" : setDate(11, DateTime.parse(actionDate));
      }
      rtnList.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.access_time_sharp,
            color: actionUser.toString().toLowerCase() !=
                    g.wstrUserCd.toString().toLowerCase()
                ? Colors.blueGrey
                : Colors.blueGrey,
            size: 15,
          ),
          gapWC(5),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.all(5),
              decoration: actionUser.toString().toLowerCase() !=
                      g.wstrUserCd.toString().toLowerCase()
                  ? boxBaseDecorationC(Colors.white, 0, 10, 10, 10)
                  : boxBaseDecorationC(
                      blueLight.withOpacity(0.5), 0, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [Expanded(child: tcn(action, Colors.black, 12))],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.blueGrey,
                        size: 10,
                      ),
                      gapWC(5),
                      tcn(actionViewDate.toString(), Colors.blueGrey, 10),
                    ],
                  ),
                  gapHC(5),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        color: Colors.blueGrey,
                        size: 10,
                      ),
                      gapWC(5),
                      tcn(actionUser.toString(), Colors.blueGrey, 10),
                    ],
                  ),
                  gapHC(5),
                  lineC(1.0, greyLight)
                ],
              ),
            ),
          ),
        ],
      ));
      srno = srno + 1;
    }
    return rtnList;
  }

  //Filter
  Widget wFilterCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.filter_list_alt,
                color: color2,
                size: 15,
              ),
              gapWC(10),
              tcn('Filters', color2, 15),
            ],
          ),
          gapHC(5),
          lineC(1.0, greyLight),
          gapHC(10),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapHC(2),
              PopupMenuButton<Menu>(
                position: PopupMenuPosition.under,
                tooltip: "",
                onSelected: (Menu item) {
                  setState(() {});
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                  PopupMenuItem<Menu>(
                    value: Menu.itemOne,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: wFilterPopup("ASSIGN_USER"),
                  ),
                ],
                child: Container(
                  decoration: boxBaseDecoration(Colors.white, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          tcn1('Assigned From', Colors.black, 12),
                          gapWC(5),
                          tc1(flAssignUserFrom.length.toString(), Colors.black,
                              12),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                flAssignUserFrom = [];
                              });
                              Navigator.pop(context);
                              apiGetTask("");
                            }
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            size: 12,
                          ))
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 0.5,
              ),
              gapHC(2),
              PopupMenuButton<Menu>(
                position: PopupMenuPosition.under,
                tooltip: "",
                onSelected: (Menu item) {
                  setState(() {});
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                  PopupMenuItem<Menu>(
                    value: Menu.itemOne,
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: wFilterPopup("ASSIGN_TO"),
                  ),
                ],
                child: Container(
                  decoration: boxBaseDecoration(Colors.white, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          tcn1('Assigned To', Colors.black, 12),
                          gapWC(5),
                          tc1(flAssignUserTo.length.toString(), Colors.black,
                              12),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                flAssignUserTo = [];
                              });
                              Navigator.pop(context);
                              apiGetTask("");
                            }
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            size: 12,
                          ))
                    ],
                  ),
                ),
              )
            ],
          )),
          // Container(
          //   decoration: boxBaseDecoration(color2, 30),
          //   padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 6),
          //   child: Column(
          //     children: [
          //       Row(),
          //       tcn('Apply', Colors.white, 12)
          //     ],
          //   ),
          // ),
          // gapHC(10),
          // Container(
          //   decoration: boxOutlineCustom1(Colors.white, 30, Colors.black.withOpacity(0.5  ), 1.0),
          //   padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 4),
          //   child: Column(
          //     children: [
          //       Row(),
          //       tcn('Clear', Colors.black, 12)
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  //Task Move
  Widget wTaskTimeLine() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.access_time_outlined,
                color: color2,
                size: 15,
              ),
              gapWC(10),
              tcn('Task Timeline', color2, 15),
            ],
          ),
          gapHC(5),
          lineC(1.0, greyLight),
          gapHC(10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: wTaskTimeLineList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  //Side Menu List
  List<Widget> wModuleCount() {
    List<Widget> rtnList = [];
    var srno = 1;
    rtnList.add(Row());
    for (var e in moduleCount) {
      var module = e["MODULE"] ?? "";
      var count = e["COUNT"] ?? "";
      rtnList.add(Bounce(
        onPressed: () {
          if (mounted) {
            setState(() {
              flSelectedPriority = "";
              flSelectedIssue = "";
              flSelectedModule = module;
              flPriorityList = [];
              flModuleList = [];
              flAssignUserFrom = [];
              flAssignUserTo = [];
              flDepartment = [];
              flIssueTypeList = [];
              flCompanyList = [];
              flCreateDate = "";
              flDocno = "";
            });
            apiGetTask("");
          }
        },
        duration: const Duration(milliseconds: 110),
        child: Container(
          decoration: flSelectedModule == module
              ? boxBaseDecoration(blueLight, 5)
              : boxBaseDecoration(bGreyLight, 5),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tc1(module.toString(), Colors.black, 10),
              tc1(count.toString(), color2, 12),
            ],
          ),
        ),
      ));
      srno = srno + 1;
    }
    return rtnList;
  }

  List<Widget> wPriorityCount() {
    List<Widget> rtnList = [];
    var srno = 1;
    rtnList.add(Row());
    for (var e in priorityCount) {
      var code = e["PRIORITY"] ?? "";
      var module = e["DESCP"] ?? "";
      var count = e["COUNT"] ?? "";
      rtnList.add(Bounce(
        onPressed: () {
          if (mounted) {
            setState(() {
              flSelectedPriority = code;
              flSelectedIssue = "";
              flSelectedModule = "";
              flPriorityList = [];
              flModuleList = [];
              flAssignUserFrom = [];
              flAssignUserTo = [];
              flDepartment = [];
              flIssueTypeList = [];
              flCompanyList = [];
              flCreateDate = "";
              flDocno = "";
            });
            apiGetTask("");
          }
        },
        duration: const Duration(milliseconds: 110),
        child: Container(
          decoration: module == "CRITICAL" && count > 0
              ? boxBaseDecoration(Colors.red, 5)
              : flSelectedPriority == code
                  ? boxBaseDecoration(blueLight, 5)
                  : boxBaseDecoration(bGreyLight, 5),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tc(
                  module.toString(),
                  module == "CRITICAL" && count > 0
                      ? Colors.white
                      : Colors.black,
                  10),
              tc(
                  count.toString(),
                  module == "CRITICAL" && count > 0
                      ? Colors.white
                      : Colors.deepOrange,
                  12),
            ],
          ),
        ),
      ));
      srno = srno + 1;
    }
    return rtnList;
  }

  List<Widget> wIssueCount() {
    List<Widget> rtnList = [];
    var srno = 1;
    rtnList.add(Row());
    for (var e in issueCount) {
      var code = e["ISSUE_TYPE"] ?? "";
      var module = e["DESCP"] ?? "";
      var count = e["COUNT"] ?? "";
      rtnList.add(Bounce(
        onPressed: () {
          if (mounted) {
            setState(() {
              flSelectedPriority = "";
              flSelectedIssue = code;
              flSelectedModule = "";
              flPriorityList = [];
              flModuleList = [];
              flAssignUserFrom = [];
              flAssignUserTo = [];
              flIssueTypeList = [];
              flCompanyList = [];
              flCreateDate = "";
              flDocno = "";
            });
            apiGetTask("");
          }
        },
        duration: const Duration(milliseconds: 110),
        child: Container(
          decoration: flSelectedIssue == code
              ? boxBaseDecoration(blueLight, 5)
              : boxBaseDecoration(bGreyLight, 5),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              tc(module.toString(), Colors.black, 10),
              tc(count.toString(), color2, 12),
            ],
          ),
        ),
      ));
      srno = srno + 1;
    }
    return rtnList;
  }

  //Notification
  List<Widget> wNotification() {
    List<Widget> rtnList = [];
    rtnList.add(Row());
    for (var e in notificationList) {
      var createDate = (e["CREATE_DATE"] ?? "").toString();
      var readYn = (e["READ_YN"] ?? "").toString();
      var id = (e["ID"] ?? "").toString();
      var docno = (e["PRV_DOCNO"] ?? "").toString();

      try {
        createDate = setDate(7, DateTime.parse(createDate));
      } catch (e) {
        dprint(e);
      }

      rtnList.add(Bounce(
        onPressed: () {
          if (readYn != "Y") {
            apiReadNofity(id);
          }

          if (mounted) {
            setState(() {
              flDocno = docno;
            });
          }
          apiGetTask("");
        },
        duration: Duration(milliseconds: 110),
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          decoration: boxBaseDecoration(greyLight.withOpacity(0.5), 10),
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    readYn == "Y" ? Colors.redAccent : Colors.green,
                radius: 13,
                child: Icon(
                  Icons.notifications_on_outlined,
                  color: Colors.white,
                  size: 13,
                ),
              ),
              gapWC(5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(),
                    tc("${e["SUBJECT"] ?? ""}  $docno", Colors.black, 10),
                    tcn1((e["BODY"] ?? "").toString(), Colors.black, 10),
                    tcn1(createDate.toString(), Colors.black, 10)
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    }
    return rtnList;
  }

  //======================================PAGE FN

  fnGetPageData() {
    if (mounted) {
      scrollController.addListener(pagination);

      setState(() {
        lstrStatusList = [];
        lstrStatusList.add({
          "CODE": "P",
          "DESCP": "OPEN",
        });
        lstrStatusList.add({
          "CODE": "C",
          "DESCP": "CLOSED",
        });
        lstrStatusList.add({
          "CODE": "D",
          "DESCP": "DROPED",
        });

        wstrPageForm = [];
        wstrPageForm.add({
          "C_TYPE": "W",
          "CONTROLLER": txtTaskHead,
          "TYPE": "S",
          "VALIDATE": true,
          "ERROR_MSG": "Please Fill Task Head",
          "FILL_CODE": "PRICE",
          "PAGE_NODE": ""
        });
        wstrPageForm.add({
          "C_TYPE": "W",
          "CONTROLLER": txtTaskDescp,
          "TYPE": "S",
          "VALIDATE": true,
          "ERROR_MSG": "Please fill task description",
          "FILL_CODE": "PRICE",
          "PAGE_NODE": ""
        });
        wstrPageForm.add({
          "C_TYPE": "W",
          "CONTROLLER": txtContactPeron,
          "TYPE": "S",
          "VALIDATE": false,
          "ERROR_MSG": "Please mention contact person",
          "FILL_CODE": "PRICE",
          "PAGE_NODE": ""
        });
        wstrPageForm.add({
          "C_TYPE": "W",
          "CONTROLLER": txtMobile,
          "TYPE": "S",
          "VALIDATE": false,
          "ERROR_MSG": "Please enter mobile no",
          "FILL_CODE": "PRICE",
          "PAGE_NODE": ""
        });
        wstrPageForm.add({
          "C_TYPE": "W",
          "CONTROLLER": txtEmail,
          "TYPE": "S",
          "VALIDATE": false,
          "ERROR_MSG": "Please enter email no",
          "FILL_CODE": "PRICE",
          "PAGE_NODE": ""
        });
      });
    }
    apiCompanyDetails();
    apiGetTaskMasters();
  }

  fnRefresh() {
    if (mounted) {
      apiGetTask("");
    }
  }

  fnStartRecord() async {
    bool isRecording = await record.isRecording();
    if (isRecording) {
      final path = await record.stop();
      dprint(path);
    } else {
      if (await record.hasPermission()) {
        // Start recording
        await record.start();
      }
    }
  }

  fnLogOut1() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: tcn1('Sign Out', color2, 20),
        content: tcn1('Do you want to sign out?', Colors.black, 14),
        actions: <Widget>[
          Container(
            width: 80,
            height: 35,
            decoration:
                boxOutlineCustom1(Colors.white, 30, Colors.blueGrey, 1.0),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: tc1('NO', Colors.blueGrey, 12),
            ),
          ),
          gapWC(3),
          Container(
            width: 80,
            height: 35,
            decoration: boxBaseDecoration(color2, 30),
            child: TextButton(
              onPressed: () async {
                final SharedPreferences prefs = await _prefs;
                if (mounted) {
                  setState(() {
                    g.wstrLKey = "";
                    g.wstrLoginYn = "N";
                    prefs.setString('wstrLoginYn', "N");
                  });
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              child: tc1('YES', Colors.white, 12),
            ),
          ),
        ],
      ),
    );
  }

  //TASK
  fnNewTask() {
    setState(() {
      taskOptions = "A";
      lstrTCreatedBY = g.wstrUserCd.toString();
      lstrTTaskMode = "ADD";
      lstrTStatus = "P";
    });
    apiGetTaskMasters();
  }

  fnNewTaskFillData() {
    fnClear();

    if (mounted) {
      //Company List
      //Module List
      //Priority
      //Platform
      //IssueType
      setState(() {
        taskOptions = "A";
        lstrTCreatedBY = g.wstrUserCd.toString();
        lstrTTaskMode = "ADD";
        lstrTStatus = "P";
      });
    }
  }

  fnEditTaskFillData(data) {
    fnClear();
    if (mounted) {
      setState(() {
        // var myJSON = jsonDecode(data["TASK_DETAIL"].toString());
        // _controller = QuillController(
        //     document: Document.fromJson(myJSON),
        //     selection: TextSelection.collapsed(offset: 0));

        txtTaskHead.text = data["TASK_HEADER"].toString();
        txtTaskDescp.text = data["TASK_DETAIL"].toString();
        txtContactPeron.text = data["CONTACT_PERSON"].toString();
        txtMobile.text = data["CONTACT_MOB"].toString();
        txtEmail.text = data["CONTACT_EMAIL"].toString();

        lstrTTaskMode = "EDIT";
        lstrTPrvDocno = data["PRV_DOCNO"] ?? "";
        lstrTTaskDocno = data["DOCNO"] ?? "";
        lstrTTaskDoctype = data["DOCTYPE"] ?? "";
        lstrTMainCompany = data["MAIN_COMPANY_NAME"] ?? "";
        lstrTMainCompanyCode = data["MAIN_CLIENT_ID"] ?? "";
        lstrTCompany = data["COMPANY_NAME"] ?? "";
        lstrTCompanyCode = data["CLIENT_COMPANY"] ?? "";
        lstrTCompanyId = data["CLIENT_ID"] ?? "";
        lstrTCreatedBY = data["CREATE_USER"] ?? "";
        lstrTPriorityCode = data["PRIORITY"] ?? "";
        lstrTPriority = data["PRIORITY_DESCP"] ?? "";
        lstrTIssueType = data["ISSUE_TYPE_DESCP"] ?? "";
        lstrTIssueTypeCode = data["ISSUE_TYPE"] ?? "";
        lstrTStatus = data["STATUS"] ?? "";
        lstrTLastStatus = data["STATUS"] ?? "";
        lstrDocument = data["ATTACHMENT_TXN"] ?? [];
        lstrTaskComments = data["TASK_COMMENTS"] ?? [];
        lstrTaskTimeLine = data["TASK_HISTORY"] ?? [];

        lstrTModule = data["MODULE"] ?? "";
        sideNavigation = "T";
        txtTaskCompletionNote.text = data["COMPLETION_NOTE"] ?? "";
        try {
          lstrDeadlineDate = DateTime.parse(data["DEADLINE"]);
          lstrBDeadLine = true;
        } catch (e) {
          lstrBDeadLine = false;
          lstrDeadlineDate = DateTime.now();
        }
      });
    }
    scaffoldKey.currentState?.openEndDrawer();
  }

  fnClear() {
    if (mounted) {
      setState(() {
        txtTaskHead.clear();
        txtTaskDescp.clear();
        txtContactPeron.clear();
        txtMobile.clear();
        txtEmail.clear();
        lstrTCompany = "";
        lstrTCompanyCode = "";
        lstrTCompanyId = "";
        lstrTModule = "";
        lstrTPlatForms = [];
        lstrTCreatedBY = "";
        lstrTPriority = "";
        lstrTPriorityCode = "";
        lstrTIssueType = "";
        lstrTIssueTypeCode = "";
        lstrTMainCompanyCode = "";
        lstrTMainCompany = "";
        lstrTTaskDocno = "";
        lstrTTaskDoctype = "";
        blSaveTask = false;
        lstrTStatus = "";
        lstrFiles = [];
        lstrDocument = [];
        lstrTPrvDocno = "";
        lstrDeadlineDate = DateTime.now();
        lstrViewDocno = "";
        lstrBDeadLine = false;
        txtTaskCompletionNote.clear();
        lstrTaskTimeLine = [];
        lstrTaskComments = [];
      });
    }
  }

  fnAddNewClear() {
    if (mounted) {
      setState(() {
        txtTaskHead.clear();
        txtTaskDescp.clear();
        lstrFiles = [];
        lstrTPrvDocno = "";
      });
    }
  }

  fnTaskCallBack(users, department, mode, note, deadLine, workMin) {
    apiMoveTask(lstrAssignDocno, lstrAssignDoctype, users, department, mode,
        note, deadLine, workMin);
  }

  //FileUpload
  fnAddFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files =
          result.paths.map((path) => File(path.toString())).toList();
      print(files[0].toString());
      List<Uint8List> bytsArray = [];
      for (var e in files) {
        Uint8List bytes = await e.readAsBytes();
        bytsArray.add(bytes);
      }
      //filesArray
      if (mounted) {
        setState(() {
          //lstrFiles = lstrFiles + files;
          if (lstrTTaskMode == "EDIT") {
            lstrFiles = [];
          }
          for (var e in files) {
            if (!lstrFiles.contains(e)) {
              lstrFiles.add(e);
            }
          }
        });
      }
      if (lstrTTaskMode == "EDIT") {
        fnUploadFile(lstrTTaskDocno, lstrTTaskDoctype);
      }
    } else {
      // User canceled the picker
    }
  }

  fnRemoveFile(file) {
    if (mounted) {
      setState(() {
        lstrFiles.remove(file);
      });
    }
  }

  fnUploadFile(docno, doctype) {
    if (lstrFiles.isEmpty) {
      return;
    }

    apiUploadFiles(docno, doctype);
  }

  Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  fnAttachmentRemove(dataList) {
    if (mounted) {
      setState(() {
        lstrRemoveAttachment = dataList;
      });
    }
    PageDialog().deleteDialog(context, apiDeleteAttachment);
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: lstrDeadlineDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != lstrDeadlineDate) {
      setState(() {
        lstrBDeadLine = true;
        lstrDeadlineDate = pickedDate;
      });
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
        apiGetTask("F");
      }
    }
  }

  //Filter
  fnSort(column, arrow) {
    if (mounted) {
      setState(() {
        flSortColumnName = column;
        flSortColumnDir = arrow;
      });
    }
    apiGetTask("");
  }

  void pagination() {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent)) {
      setState(() {
        print(
            '--------------------------------PAGE$lstrTaskListPageNo----------------------------');
        lstrTaskListPageNo += 1;
        apiGetTask("P");
        //add api for load the more data according to new page
      });
    }
  }

  fnFilterClear() {
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

  fnSubTaskCall(mainClientId, docno, doctype) {
    apiGetTaskDet(mainClientId, docno, doctype);
  }

  //======================================API CALL

  apiCompanyDetails() {
    futureForm = apiCall.apiGetCompanyModule();
    futureForm.then((value) => apiCompanyDetailsRes(value));
  }

  apiCompanyDetailsRes(value) {
    if (mounted) {
      setState(() {
        lstrCompanyList = [];
        lstrCompanyList = [];
        lstrModuleList = [];
        if (g.fnValCheck(value)) {
          lstrCompanyList = value["COMPANY"];
          lstrModuleList = value["CLIENT_MODULE"];
        }
      });
      apiGetTask("");
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

  apiGetTaskExport() {
    if (mounted) {}

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
        -1,
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
    futureForm.then((value) => apiGetTaskExportRes(value));
  }

  apiGetTaskExportRes(value) {
    if (mounted) {
      var taskList = value["TASKS"] ?? [];
      fnExport(taskList);
    }
  }

  apiGetTaskDet(mainClientId, docno, doctype) {
    futureForm = apiCall.apiGetTaskDet(mainClientId, docno, doctype);
    futureForm.then((value) => apiGetTaskDetRes(value));
  }

  apiGetTaskDetRes(value) {
    if (mounted) {
      setState(() {
        if (g.fnValCheck(value)) {
          fnEditTaskFillData(value);
        }
      });
    }
  }

  apiGetTaskDetTimeline(mainClientId, docno, doctype) {
    futureForm = apiCall.apiGetTaskDet(mainClientId, docno, doctype);
    futureForm.then((value) => apiGetTaskDetTimelineRes(value));
  }

  apiGetTaskDetTimelineRes(value) {
    if (mounted) {
      setState(() {
        if (g.fnValCheck(value)) {
          lstrTaskTimeLine = value["TASK_HISTORY"] ?? [];
        }
      });
      scaffoldKey.currentState?.openEndDrawer();
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
      fnNewTaskFillData();
    }
  }

  apiSaveTask(mode) {
    var saveSts = true;
    for (var e in wstrPageForm) {
      var validate = e["VALIDATE"];
      if (validate) {
        var value = e["C_TYPE"].toString() == "W"
            ? e["CONTROLLER"].text
            : e["CONTROLLER"].toString();
        if (value == null || value == "") {
          errorMsg(context, e["ERROR_MSG"].toString());
          saveSts = false;
          return;
        }
      }
    }

    if (lstrTMainCompanyCode.isEmpty) {
      errorMsg(context, "Please select Main Company");
      saveSts = false;
      return;
    }
    if (lstrTCompanyCode.isEmpty) {
      errorMsg(context, "Please select company");
      saveSts = false;
      return;
    }
    if (lstrTModule.isEmpty) {
      errorMsg(context, "Please select module");
      saveSts = false;
      return;
    }
    if (lstrTPriority.isEmpty) {
      errorMsg(context, "Please choose priority");
      saveSts = false;
      return;
    }
    if (lstrTIssueType.isEmpty) {
      errorMsg(context, "Please select Issue Type");
      saveSts = false;
      return;
    }

    if (!saveSts) {
      return;
    }

    var TASK = [
      {
        //"COMPANY": "",
        // "DOCNO": "",
        // "DOCTYPE": "",
        // "DOCDATE": "",
        "MAIN_CLIENT_ID": lstrTMainCompanyCode,
        "CLIENT_ID": lstrTCompanyId,
        "CLIENT_COMPANY": lstrTCompanyCode,
        "CONTACT_PERSON": txtContactPeron.text.toString(),
        "CONTACT_MOB": txtMobile.text.toString(),
        "CONTACT_EMAIL": txtEmail.text.toString(),
        "TASK_HEADER": txtTaskHead.text.toString(),
        "TASK_DETAIL": txtTaskDescp.text.toString(),
        "DEADLINE": lstrBDeadLine ? setDate(2, lstrDeadlineDate) : null,
        //"START_TIME": "",
        // "END_TIME": "",
        //"DURATION": "",
        //"DURATION_TYPE": "",
        //"CREATE_USER": "",
        //"CREATE_DATE": "",
        "PRV_DOCNO": lstrTPrvDocno,
        "MAIN_DOCNO": "",
        "MODULE": lstrTModule,
        "TASK_TYPE": "",
        "ISSUE_TYPE": lstrTIssueTypeCode,
        "CLIENT_TYPE": "",
        "PRIORITY": lstrTPriorityCode,
        "STATUS": "P",
        "COMPLETED_USER": "",
        "COMPLETION_NOTE": "",
        "REMASRKS": ""
      }
    ];
    var TASK_CHECKLIST = [
      {
        //"COMPANY": "",
        // "DOCNO": "",
        // "DOCTYPE": "",
        // "SRNO": "",
        "HEADER": "CHECKLIST1",
        "DETAIL": "REPORT FILE OPEN",
        "PRIORITY": "1",
        //"STATUS": "0",
        //"COMPLETED_USER": ""
      }
    ];
    var TASK_PLATFORM = [
      {
        //"COMPANY": "",
        //"DOCNO": "",
        //"DOCTYPE": "",
        //"SRNO": "",
        "MODULE": lstrTModule,
        "PLATFORM": "WINDOWS"
      }
    ];
    var MODE = "ADD";
    if (mounted) {
      setState(() {
        blSaveTask = true;
      });
    }
    futureForm =
        apiCall.apiSaveTask(TASK, TASK_CHECKLIST, TASK_PLATFORM, MODE, []);
    futureForm.then((value) => apiSaveTaskRes(value, mode));
  }

  apiSaveTaskRes(value, mode) {
    if (mounted) {
      setState(() {
        blSaveTask = false;
      });

      if (g.fnValCheck(value)) {
        var sts = value[0]["STATUS"].toString();
        var msg = value[0]["MSG"].toString();
        if (sts == "1") {
          //Success
          var code = value[0]["CODE"].toString();
          var doctype = value[0]["DOCTYPE"].toString();

          if (mode == "NEW") {
            fnAddNewClear();
          } else {
            Navigator.pop(context);
          }
          //successMsg(context, "$code \n New Task Added !!!");
          PageDialog().showTaskDone(context, code, "HEAD");
          fnUploadFile(code, doctype);

          apiGetTask("");
        } else {
          //Failed
          errorMsg(context, msg.toString());
        }
      }
    }
    // [{STATUS: 1, MSG: SAVED, CODE: 0000000007, DOCTYPE: TASK}]
  }

  apiEditTask() {
    var saveSts = true;
    for (var e in wstrPageForm) {
      var validate = e["VALIDATE"];
      if (validate) {
        var value = e["C_TYPE"].toString() == "W"
            ? e["CONTROLLER"].text
            : e["CONTROLLER"].toString();
        if (value == null || value == "") {
          errorMsg(context, e["ERROR_MSG"].toString());
          saveSts = false;
          return;
        }
      }
    }

    if (lstrTMainCompanyCode.isEmpty) {
      errorMsg(context, "Please select Main Company");
      saveSts = false;
      return;
    }
    if (lstrTCompanyCode.isEmpty) {
      errorMsg(context, "Please select company");
      saveSts = false;
      return;
    }
    if (lstrTModule.isEmpty) {
      errorMsg(context, "Please select module");
      saveSts = false;
      return;
    }
    if (lstrTPriority.isEmpty) {
      errorMsg(context, "Please choose priority");
      saveSts = false;
      return;
    }
    if (lstrTIssueType.isEmpty) {
      errorMsg(context, "Please select Issue Type");
      saveSts = false;
      return;
    }

    if (!saveSts) {
      return;
    }

    if (lstrTStatus != "P" && txtTaskCompletionNote.text.isEmpty) {
      errorMsg(context, "Please fill completion note");
      saveSts = false;
      return;
    }

    // var json = jsonEncode(_controller.document.toDelta().toJson());
    // var txt = _controller.document.toPlainText();

    var TASK = [
      {
        "COMPANY": g.wstrCompany,
        "DOCNO": lstrTTaskDocno,
        "DOCTYPE": lstrTTaskDoctype,
        //"DOCDATE": "",
        "MAIN_CLIENT_ID": lstrTMainCompanyCode,
        "CLIENT_ID": lstrTCompanyId,
        "CLIENT_COMPANY": lstrTCompanyCode,
        "CONTACT_PERSON": txtContactPeron.text.toString(),
        "CONTACT_MOB": txtMobile.text.toString(),
        "CONTACT_EMAIL": txtEmail.text.toString(),
        "TASK_HEADER": txtTaskHead.text.toString(),
        "TASK_DETAIL": txtTaskDescp.text.toString(),

        "DEADLINE": lstrBDeadLine ? setDate(2, lstrDeadlineDate) : null,
        //"START_TIME": "",
        //"END_TIME": "",
        //"DURATION": "",
        //"DURATION_TYPE": "",
        //"CREATE_USER": "",
        //"CREATE_DATE": "",
        "PRV_DOCNO": lstrTPrvDocno,
        "MAIN_DOCNO": "",
        "MODULE": lstrTModule,
        "TASK_TYPE": "",
        "ISSUE_TYPE": lstrTIssueTypeCode,
        "CLIENT_TYPE": "",
        "PRIORITY": lstrTPriorityCode,
        "STATUS": lstrTStatus,
        "COMPLETED_USER": "",
        "COMPLETION_NOTE": txtTaskCompletionNote.text,
        "REMASRKS": ""
      }
    ];
    var TASK_CHECKLIST = [
      {
        //"COMPANY": "",
        // "DOCNO": "",
        // "DOCTYPE": "",
        // "SRNO": "",
        "HEADER": "CHECKLIST1",
        "DETAIL": "REPORT FILE OPEN",
        "PRIORITY": "1",
        //"STATUS": "0",
        //"COMPLETED_USER": ""
      }
    ];
    var TASK_PLATFORM = [
      {
        //"COMPANY": "",
        //"DOCNO": "",
        //"DOCTYPE": "",
        //"SRNO": "",
        "MODULE": lstrTModule,
        "PLATFORM": "WINDOWS"
      }
    ];
    var MODE = "EDIT";
    if (mounted) {
      setState(() {
        blSaveTask = true;
      });
    }
    futureForm =
        apiCall.apiSaveTask(TASK, TASK_CHECKLIST, TASK_PLATFORM, MODE, []);
    futureForm.then((value) => apiEditTaskRes(value));
  }

  apiEditTaskRes(value) {
    if (mounted) {
      setState(() {
        blSaveTask = false;
      });

      if (g.fnValCheck(value)) {
        var sts = value[0]["STATUS"].toString();
        var msg = value[0]["MSG"].toString();
        if (sts == "1") {
          //Success
          var code = value[0]["CODE"].toString();
          Navigator.pop(context);
          //successMsg(context, "$code \n New Task Added !!!");
          PageDialog().showTaskUpdated(context, code, "HEAD");
          apiGetTask("");
        } else {
          //Failed
          errorMsg(context, msg.toString());
        }
      }
    }

    // [{STATUS: 1, MSG: SAVED, CODE: 0000000007, DOCTYPE: TASK}]
  }

  apiUpdateTask(docno, doctype, status, issue, priority) {
    futureForm = apiCall.apiUpdateTask(docno, doctype, status, issue, priority);
    futureForm.then((value) => apiUpdateTaskRes(value));
  }

  apiUpdateTaskRes(value) {
    fnGetPageData();
  }

  apiUploadFiles(docno, doctype) {
    futureForm = ApiManager().mfnAttachment(lstrFiles, docno, doctype);
    futureForm.then((value) => apiUploadFilesRes(value));
  }

  apiUploadFilesRes(value) {
    apiGetTaskDocumentDet(
        lstrTMainCompanyCode, lstrTTaskDocno, lstrTTaskDoctype);
  }

  apiGetTaskDocumentDet(mainClientId, docno, doctype) {
    futureForm = apiCall.apiGetTaskDet(mainClientId, docno, doctype);
    futureForm.then((value) => apiGetTaskDocumentDetRes(value));
  }

  apiGetTaskDocumentDetRes(value) {
    if (mounted) {
      setState(() {
        if (g.fnValCheck(value)) {
          lstrDocument = value["ATTACHMENT_TXN"] ?? [];
        }
      });
    }
  }

  apiDeleteAttachment() {
    //print(dataList);
    Navigator.pop(context);
    var dataList = lstrRemoveAttachment;
    futureForm = apiCall.apiDeleteAttachment(dataList["DOCNO"],
        dataList["DOCTYPE"], dataList["SRNO"], dataList["RELATIVE_PATH"]);
    futureForm.then((value) => apiDeleteAttachmentRes(value));
  }

  apiDeleteAttachmentRes(value) {
    print(value);
    if (g.fnValCheck(value)) {
      if (value == "DELETED") {
        //call fill api with code;
        infoMsg(context, "Removed");
        apiGetTaskDocumentDet(
            lstrTMainCompanyCode, lstrTTaskDocno, lstrTTaskDoctype);
      } else {
        errorMsg(context, "Sorry, Try Again !!!");
      }
    } else {
      errorMsg(context, "Please try again!");
    }
  }

  apiDeleteTask() {
    futureForm = apiCall.apiDeleteTask(lstrTTaskDocno, lstrTTaskDoctype);
    futureForm.then((value) => apiDeleteTaskRes(value));
  }

  apiDeleteTaskRes(value) {
    if (mounted) {
      setState(() {
        if (g.fnValCheck(value)) {
          var sts = value[0]["STATUS"].toString();
          var msg = value[0]["MSG"].toString();
          if (sts == "1") {
            //Success

            Navigator.pop(context);
            Navigator.pop(context);
            var code = value[0]["CODE"].toString();
            successMsg(context, "Task Deleted!!");
            apiGetTask("");
          } else {
            //Failed
            errorMsg(context, "Sorry, Try Again !!!");
          }
        }
      });
    }
  }

  apiAddComment(docno, doctype, comment) {
    futureForm = apiCall.apiAddTaskComment(docno, doctype, comment);
    futureForm.then((value) => apiAddCommentRes(value));
  }

  apiAddCommentRes(value) {
    if (mounted) {
      setState(() {
        txtComment.clear();
      });
      apiGetTaskDet(lstrTMainCompanyCode, lstrTTaskDocno, lstrTTaskDoctype);
    }
  }

  //Task Actions

  apiStartTask(docno, doctype) {
    futureForm = apiCall.apiStartTask(docno, doctype);
    futureForm.then((value) => apiStartTaskRes(value));
  }

  apiStartTaskRes(value) {
    if (mounted) {
      setState(() {
        lstrTaskListPageNo = 0;
        flStatus = "A";
        flOverDueYn = "N";
      });
    }
    apiGetTask("");
  }

  apiResumeTask(docno, doctype) {
    futureForm = apiCall.apiResumeTask(docno, doctype);
    futureForm.then((value) => apiResumeTaskRes(value));
  }

  apiResumeTaskRes(value) {
    if (mounted) {
      setState(() {});
      apiGetTask("");
    }
  }

  apiMoveTask(
      docno, doctype, users, department, mode, note, deadLine, workMin) {
    var userList = [];
    if (mode == "U") {
      if (users.isNotEmpty) {
        for (var e in users) {
          userList.add({'COL_VAL': e});
        }
      }
    }

    futureForm = apiCall.apiMoveTask(
        docno, doctype, userList, department, note, deadLine, workMin);
    futureForm.then((value) => apiMoveTaskRes(value));
  }

  apiMoveTaskRes(value) {
    if (mounted) {
      setState(() {});
      apiGetTask("");
    }
  }

  apiHoldTask(docno, doctype, note) {
    futureForm = apiCall.apiHoldTask(docno, doctype, note);
    futureForm.then((value) => apiHoldTaskRes(value));
  }

  apiHoldTaskRes(value) {
    if (mounted) {
      Navigator.pop(context);
      apiGetTask("");
    }
  }

  apiFinishTask(docno, doctype, note) {
    futureForm = apiCall.apiFinishTask(docno, doctype, note);
    futureForm.then((value) => apiFinishTaskRes(value));
  }

  apiFinishTaskRes(value) {
    if (mounted) {
      Navigator.pop(context);
      if (g.fnValCheck(value)) {
        var sts = value[0]["STATUS"].toString();
        var msg = value[0]["MSG"].toString();
        if (sts == "1") {
          successMsg(context, "Completed!!");
          apiGetTask("");
        } else {
          //Failed
          errorMsg(context, msg);
        }
      }
      apiGetTask("");
    }
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

  apiReadNofity(id) {
    futureForm = apiCall.apiReadNotify(id);
    futureForm.then((value) => apiReadNofityRes(value));
  }

  apiReadNofityRes(value) {
    apiNotification();
  }

  //=================================================== MQTT
  Future<void> setupMqttClient() async {
    await mqttClientManager.connect();
    mqttClientManager
        .subscribe("BEAMS_NOTY/${g.wstrUserCd.toString().toLowerCase()}");
  }

  void setupUpdatesListener() {
    mqttClientManager
        .getMessagesStream()!
        .listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('MQTTClient::Message received on topic: <${c[0].topic}> is $pt\n');
      apiNotification();
      fnShowNotification(pt);
    });
  }

  fnShowNotification(data) async {
    var notiData = jsonDecode(data.toString());
    var createDate = "";
    var readYn = "";
    var id = "";
    var docno = "";
    var doctype = "";
    var subject = "";
    var body = "";
    var mainClientId = "";
    if (g.fnValCheck(notiData)) {
      var e = notiData;
      createDate = (e["CREATE_DATE"] ?? "").toString();
      readYn = (e["READ_YN"] ?? "").toString();
      id = (e["ID"] ?? "").toString();
      docno = (e["PRV_DOCNO"] ?? "").toString();
      doctype = (e["PRV_DOCTYPE"] ?? "").toString();
      subject = (e["SUBJECT"] ?? "").toString();
      body = (e["BODY"] ?? "").toString();
      mainClientId = (e["MAIN_CLIENT_ID"] ?? "").toString();

      try {
        createDate = setDate(7, DateTime.parse(createDate));
      } catch (e) {
        dprint(e);
      }
    }

    var message = "";

    // Add in main method.
    await localNotifier.setup(
      appName: 'BEAMS TMS',
      // The parameter shortcutPolicy only works on Windows
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );

    LocalNotification notification = LocalNotification(
      title: "BEAMS TMS",
      body: body,
    );
    notification.onShow = () {
      print('onShow ${notification.identifier}');
    };
    notification.onClose = (closeReason) {
      // Only supported on windows, other platforms closeReason is always unknown.
      switch (closeReason) {
        case LocalNotificationCloseReason.userCanceled:
          // do something
          break;
        case LocalNotificationCloseReason.timedOut:
          // do something
          break;
        default:
      }
      print('onClose  $closeReason');
    };
    notification.onClick = () {
      print('onClick ${notification.identifier}');
      //PageDialog().show(context, Container(), subject);
      apiReadNofity(id);
      if (mounted) {
        setState(() {
          flDocno = docno;
        });
      }
      apiGetTask("");
    };
    notification?.onClickAction = (actionIndex) {
      print('onClickAction ${notification?.identifier} - $actionIndex');
    };

    notification.show();
  }

  fnSendMessage() {
    mqttClientManager.publishMessage(
        "BEAMS_NOTY/${g.wstrUserCd.toString().toLowerCase()}", "Hello");
  }

  //=================================================EXPORT
  Future<void> fnExport(taskList) async {
    //Create a new Excel Document.
    final excel.Workbook workbook = excel.Workbook(1);

    final excel.Worksheet sheet = workbook.worksheets[0];
    final excel.Style style = workbook.styles.add('Style1');
    style.wrapText = true;
    style.bold = true;
    sheet.getRangeByName('A1:L200').cellStyle = style;
    final excel.Style style1 = workbook.styles.add('Style2');
    style1.bold = true;
    style1.hAlign = excel.HAlignType.center;
    style1.fontSize = 20;
    style1.fontColor = "#1656A6FF";
    sheet.getRangeByName('A1').cellStyle = style1;

    sheet.getRangeByName('A1:L1').merge();
    sheet.getRangeByName('A1').setText('BEAMS TMS');
    sheet.getRangeByName('A2:L2').merge();
    var formatDate3 = DateFormat('dd-MM-yyyy hh:mm:ss a');
    var currentDate = formatDate3.format(DateTime.now());
    sheet.getRangeByName('A2').setText('Date/Time Generated  $currentDate');

    var srno = 3;

    var tableStart = srno;

    sheet.getRangeByName('A$srno').setText('Sr.No');
    sheet.getRangeByName('B$srno').setText('Task');
    sheet.getRangeByName('B$srno').columnWidth = 30.0;
    sheet.getRangeByName('C$srno').setText('Head');
    sheet.getRangeByName('C$srno').columnWidth = 60.0;
    sheet.getRangeByName('D$srno').setText('Details');
    sheet.getRangeByName('D$srno').columnWidth = 100.0;
    sheet.getRangeByName('E$srno').setText('Issue');
    sheet.getRangeByName('E$srno').columnWidth = 20.0;
    sheet.getRangeByName('F$srno').setText('Department');
    sheet.getRangeByName('F$srno').columnWidth = 20.0;
    sheet.getRangeByName('G$srno').setText('Company');
    sheet.getRangeByName('G$srno').columnWidth = 30.0;
    sheet.getRangeByName('H$srno').setText('Module');
    sheet.getRangeByName('H$srno').columnWidth = 20.0;
    sheet.getRangeByName('I$srno').setText('Status');
    sheet.getRangeByName('I$srno').columnWidth = 20.0;
    sheet.getRangeByName('J$srno').setText('Create Date');
    sheet.getRangeByName('J$srno').columnWidth = 20.0;
    sheet.getRangeByName('K$srno').setText('Deadline');
    sheet.getRangeByName('K$srno').columnWidth = 20.0;
    sheet.getRangeByName('L$srno').setText('Created By');
    sheet.getRangeByName('L$srno').columnWidth = 20.0;
    // final Range range1 = sheet.getRangeByName('A1:I5');
    // range1.merge();
    srno = srno + 1;
    var dataSrno = 1;
    for (var e in taskList) {
      var data = e;

      var createDate = e["CREATE_DATE"] ?? "";
      var deadlineDate = e["DEADLINE"] ?? "";
      var taskDate =
          createDate != "" ? setDate(6, DateTime.parse(createDate)) : "";
      var deadline =
          deadlineDate != "" ? setDate(6, DateTime.parse(deadlineDate)) : "";
      var departmentList = e["DEP_LIST"] ?? [];
      var department = "";
      for (var dep in departmentList) {
        department += (dep["DESCP"] ?? "") + ",";
      }

      sheet.getRangeByName('A$srno').setText(dataSrno.toString());
      sheet.getRangeByName('B$srno').setText(data["DOCNO"] ?? "");
      sheet.getRangeByName('C$srno').setText(data["TASK_HEADER"].toString());
      sheet.getRangeByName('D$srno').setText(data["TASK_DETAIL"].toString());
      sheet.getRangeByName('E$srno').setText(data["ISSUE_TYPE_DESCP"] ?? "");
      sheet.getRangeByName('F$srno').setText(department.toString());
      sheet.getRangeByName('G$srno').setText(data["COMPANY_NAME"] ?? "");
      sheet.getRangeByName('H$srno').setText("");
      sheet.getRangeByName('I$srno').setText(data["STATUS"] ?? "");
      sheet.getRangeByName('J$srno').setText(taskDate);
      sheet.getRangeByName('K$srno').setText(deadline);
      sheet.getRangeByName('L$srno').setText(data["CREATE_USER"] ?? "");

      srno = srno + 1;
      dataSrno = dataSrno + 1;
    }
    final excel.Range range1 = sheet.getRangeByName('J$tableStart:J$srno');
    range1.cellStyle.hAlign = excel.HAlignType.right;
    final excel.ExcelTable table1 = sheet.tableCollection
        .create('Table1', sheet.getRangeByName('A$tableStart:L$srno'));
    sheet.tableCollection.removeAt(1);

    final List<int> bytes = workbook.saveAsStream();
    File('RemoveTable.xlsx').writeAsBytes(bytes);
    workbook.dispose();
    var formatDate4 = DateFormat('ddMMyyyyhhmmss');
    var reportDate = formatDate4.format(DateTime.now());

    if (kIsWeb) {
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName = Platform.isWindows
          ? '$path\\BeamsTMS$reportDate.xlsx'
          : '$path/BeamsTMS$reportDate.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      OpenFile.open(fileName);
    }
  }
}
