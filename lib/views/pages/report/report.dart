import 'package:bams_tms/views/components/date_filter/date_filter.dart';
import 'package:bams_tms/views/pages/users/usershome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

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

  var blSideScreen = true;

  String title = 'User Report';

  int reportsTypeCount = 0;

  String lstrSelectedMode = '';

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();

  DateTime now = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    now = now.subtract(const Duration(days: DateTime.daysPerWeek));
    dprint('This Week : ${now.subtract(Duration(days: now.weekday - 1))}');
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
                  /*Container(
                    width: 180,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(
                        left: 10, right: 5, top: 5, bottom: 10),
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
                                wMenuCard(Icons.sticky_note_2_outlined,
                                    "User Report", "U"),
                                wMenuCard(Icons.sticky_note_2_outlined,
                                    "Client Report", "C"),
                                */ /*moduleCount.isNotEmpty
                                  ? Container(
                                      decoration:
                                          boxDecoration(Colors.white, 5),
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: wModuleCount(),
                                      ),
                                    )
                                  : gapHC(0),*/ /*
                                */ /*wMenuCard(
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
                                      : gapHC(0)*/ /*
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
                        */ /*Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: () {
                              dprint('REPORTS');
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ));
                            },
                            child: Container(
                              decoration: boxOutlineCustom1(Colors.redAccent, 30,
                                  redLight.withOpacity(0.5), 1.0),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  tcn1('Reports', Colors.white, 12),
                                  gapWC(5),
                                  const Icon(
                                    Icons.sticky_note_2_outlined,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                ],
                              ),
                            ),
                          ),
                          gapHC(10),*/ /*
                        */ /*Bounce(
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
                          gapHC(10),*/ /*
                      ],
                    ),
                  ),*/
                  wLeftSideBar(),
                  wCenterSection(),
                  blSideScreen
                      ? gapWC(
                          0) /*Container(
                          decoration: boxDecoration(Colors.white, 10),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              */ /*Bounce(
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
                            ),*/ /*
                            ],
                          ),
                        )*/
                      : wRightFilterSection(),
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
                  /*moduleCount.isNotEmpty
                                  ? Container(
                                      decoration:
                                          boxDecoration(Colors.white, 5),
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: wModuleCount(),
                                      ),
                                    )
                                  : gapHC(0),*/
                  /*wMenuCard(
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
                                      : gapHC(0)*/
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
          /*Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: () {
                              dprint('REPORTS');
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ));
                            },
                            child: Container(
                              decoration: boxOutlineCustom1(Colors.redAccent, 30,
                                  redLight.withOpacity(0.5), 1.0),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  tcn1('Reports', Colors.white, 12),
                                  gapWC(5),
                                  const Icon(
                                    Icons.sticky_note_2_outlined,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                ],
                              ),
                            ),
                          ),
                          gapHC(10),*/
          /*Bounce(
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
                          gapHC(10),*/
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
          children: [
            Row(),
            Container(
              decoration: boxDecoration(
                  /*g.wstrDarkMode ? Colors.black :*/ Colors.white, 10),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      tcn(title, Colors.black, 20),
                      /*Bounce(
                                            duration:
                                            const Duration(milliseconds: 110),
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
                                            )),
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
                                                boxGradientDecorationBase(
                                                    24, 30),
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
                                                          greyLight
                                                              .withOpacity(0.7),
                                                          10),
                                                    ),
                                                    gapWC(10),
                                                    tcn1('New Task    ',
                                                        Colors.white, 14)
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
                                                      Icons.light_mode_outlined,
                                                      "A"),
                                                  gapWC(5),
                                                  wDayMode(Icons.dark_mode_outlined,
                                                      "D"),
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
                                                  Colors.grey
                                                      .withOpacity(0.5),
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
                                                    const EdgeInsets.all(
                                                        5),
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
                                                      blSideScreen = blSideScreen
                                                          ? false
                                                          : true;
                                                    });
                                                  }
                                                },
                                                child: Icon(
                                                  blSideScreen
                                                      ? Icons.navigate_before
                                                      : Icons.navigate_next_rounded,
                                                  color: Colors.blueGrey,
                                                  size: 20,
                                                )),
                                          ],
                                        )*/
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
                          color: Colors.blueGrey,
                          size: 20,
                        ),
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
                  child: SizedBox(),
                  /*child: Bounce(
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
                                                    12)
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),*/
                ),
                gapWC(5),
                Flexible(
                  child: SizedBox(),
                  /*child: Bounce(
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
                                    ),*/
                ),
                gapWC(5),
                Flexible(
                  child: SizedBox(),
                  /*child: Bounce(

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
                                    ),*/
                ),
                gapWC(5),
                Flexible(
                  child: SizedBox(),
                  /*child: Bounce(
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
                                    ),*/
                ),
                gapWC(5),
                Flexible(
                  child: SizedBox(),
                  /*child: Bounce(
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
                                    ),*/
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
                  child: SizedBox(),
                  /*child: Bounce(
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
                                ),*/
                ),
              ],
            ),
            gapHC(10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 1),
                padding: const EdgeInsets.all(5),
                decoration: boxDecoration(Colors.white, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        /*!blSearch
                                          ? tc('Task Details', Colors.deepOrange,
                                              15)
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
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                  decoration:
                                                      const InputDecoration(
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
                                                wTaskListViewIcon(
                                                    Icons.list, "L"),
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
                                              duration: const Duration(
                                                  milliseconds: 110),
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
                                              duration: const Duration(
                                                  milliseconds: 110),
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
                                                  boxGradientDecorationBase(
                                                      7, 30),
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
                                                  boxGradientDecorationBase(
                                                      6, 30),
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
                                                  tcn1(
                                                      'Export', Colors.white, 12),
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
                                      )*/
                      ],
                    )
                  ],
                ),
              ),
            ),
            /*Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.all(5),
                decoration: boxDecoration(Colors.white, 5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        */ /*wRowHead("Task", "DOCNO", 3, "Y"),
                                    wRowHead("Issue", "ISSUE_TYPE", 1, "Y"),
                                    wRowHead("Company", "COMPANY_NAME", 2, "Y"),
                                    wRowHead("Module", "MODULE", 1, "Y"),
                                    wRowHead(
                                        "Department", "DEPARTMENT", 1, "Y"),
                                    wRowHead("Status", "STATUS", 1, "Y"),
                                    wRowHead(
                                        "Create Date", "CREATE_DATE", 1, "Y"),
                                    //wRowHead("Deadline","DEADLINE",1,"Y"),
                                    wRowHead("Active User", "ACTIVE", 1, "Y"),
                                    //wRowHead("Assigned By","ASSIGNED_USER",1,"Y"),
                                    wRowHead(
                                        "Created By", "CREATE_USER", 1, "Y"),*/ /*
                      ],
                    )
                  ],
                ),
              ),*/
            /*Expanded(
                child: SingleChildScrollView(
                  // controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // children: wTaskList(),
                  ),
                ),
              ),*/
            gapHC(5),
          ],
        ),
      ),
    );
  }

  Widget wRightFilterSection() {
    return Flexible(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: boxBaseDecoration(Colors.white, 0),
        child: Column(
          children: [
            Expanded(
                child: Column(
              children: [
                Row(),
                /*Bounce(
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
                                  ),*/
                gapHC(5),
                /*tc(g.wstrUserName.toString().toUpperCase(),
                                      Colors.black, 14),
                                  tcn(g.wstrUserCd.toString(),
                                      Colors.black.withOpacity(0.6), 10),
                                  tcn(g.wstrUserDepartmentDescp.toString(),
                                      Colors.black, 10),*/
                gapHC(10),
                Expanded(
                  child: Container(
                    decoration: boxOutlineCustom1(Colors.white, 10, black, 0.5),
                    padding: const EdgeInsets.all(10),
                    child: Column(
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
                                tc('Filters', color3, 12),
                                gapWC(5),
                                /*notificationList
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
                                                      : gapHC(0)*/
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
                        lineC(0.5, Colors.black),
                        gapHC(5),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                /*GridView(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 4,
                                  ),
                                  children: [
                                    wSelectModeButton('TODAY', 'T'),
                                    wSelectModeButton('YESTERDAY', 'Y'),
                                    wSelectModeButton('THIS MONTH', 'M'),
                                    wSelectModeButton('FROM-TO', 'FT'),
                                  ],
                                ),*/
                                DateFilter(
                                    filterFunction: (from, to) =>
                                        setDateRange(from, to)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                /*gapHC(5),
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
                                  ))*/
              ],
            )),
            gapHC(10),
            SizedBox(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Container(
                      decoration: boxBaseDecoration(Colors.blueGrey, 20),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                          gapWC(10),
                          tcn1('Clear', Colors.white, 14),
                          gapWC(5),
                        ],
                      ),
                    ),
                  ),
                  gapHC(10),
                  Flexible(
                    child: Container(
                      decoration: boxBaseDecoration(Colors.green, 20),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          ),
                          gapWC(10),
                          tcn1('Apply', Colors.white, 14),
                          gapWC(5),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            gapHC(10),
            /*Bounce(
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
                              )*/
          ],
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

  setDateRange(DateTime from, DateTime to) {
    setState(() {
      fromDate = from;
      toDate = to;
    });
  }

  /*fnLoadReport() {
    fnStartLoading();
    Map<String, dynamic> params = {
      "COMPANY": g.wstrCompanyCode,
      "SITECODE": g.wstrSiteCode,
      "DATEFROM": setDate(2, fromDate),
      "DATETO": setDate(2, toDate),
    };

    apiLoadReport(params);
  }*/

  /*fnStartLoading() {
    setState(() {
      loading = true;
    });
  }

  fnStopLoading() {
    setState(() {
      loading = false;
    });
  }*/
}
