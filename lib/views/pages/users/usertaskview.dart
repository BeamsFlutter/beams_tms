
import 'dart:async';

import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/views/components/PopupLookup/filterPopup.dart';
import 'package:bams_tms/views/components/PopupLookup/searchpopup.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/components/lookup/filterLookup.dart';
import 'package:bams_tms/views/pages/login/login.dart';
import 'package:bams_tms/views/pages/task/createtask.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTaskView extends StatefulWidget {
  const UserTaskView({Key? key}) : super(key: key);

  @override
  State<UserTaskView> createState() => _UserTaskViewState();
}

class _UserTaskViewState extends State<UserTaskView> {
  ScrollController scrollController = ScrollController();

  //Global Variables
  Global g = Global();
  var apiCall  = ApiCall();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final record = Record();
  late Future<dynamic> futureForm ;
  var wstrPageForm = [];
  var sideNavigation  =  "";
  late Timer timer;
  var notificationList  =[];


  //Page Variables
  var blSearch = false;
  var blSideScreen  = true;
  var lstrMenuHoverMode = "";
  var lstrViewDocno = "";
  var lstrToday = DateTime.now();
  var lstrTaskList  = [];
  var lstrTaskListPageNo = 0;
  var lstrTaskListViewMode  = "L";
  var lstrCompanyList = [];
  var lstrModuleList = [];
  var lstrPriorityList = [];
  var lstrStatusList = [];
  var lstrIssueTypeList = [];


  //TaskCount
  var openTicket  = 0;
  var closedTicket  = 0;
  var droppedTicket  = 0;
  var overdueTicket  = 0;

  var moduleCount  = [];
  var priorityCount  = [];
  var issueCount  = [];



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
  var flModuleList = [];

  var flSelectedPriority = "";
  var flSelectedIssue = "";
  var flSelectedModule = "";


  var txtTaskHead = TextEditingController();
  var txtTaskDescp = TextEditingController();
  var txtTaskCompletionNote = TextEditingController();
  var txtContactPeron = TextEditingController();
  var txtMobile = TextEditingController();
  var txtEmail = TextEditingController();
  var txtComment = TextEditingController();


  //Controller
  var txtController  =  TextEditingController();
  var txtSearch = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState


    super.initState();
    fnGetPageData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      endDrawer:sideNavigation == "T"?
      Container(
        width:size.width*0.85,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
                //apiGetTask();
                Navigator.pop(context);
              },
              child: Container(
                height: 35,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top:30),
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                decoration: boxGradientDecorationBaseC(24, 30 , 0, 30, 0),
                child: Row(
                  children: [
                    const Icon(Icons.close,color: Colors.white,size: 15,),
                    gapWC(10),
                    tcn('Ticket', Colors.white , 15),
                  ],
                ),
              ),
            ),
            //Expanded(child: wTaskCard()),
            Expanded(child: NewTask(pageMode: "", wMainClienId: '', wDoco: '', wDoctype: '', fnGetTask: (){}, wSubOfDocno: '', fnSubTaskCall: (){},)),

          ],
        ),

      ):
      Container(
        width:350,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: wFilterCard())
          ],
        ),

      ),
      body: Container(
        // color: g.wstrDarkMode?Colors.black:Colors.white,
        child: Column(
          children: [
            Expanded(child: Row(
              children: [
                Container(
                  width: 180,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 10,right: 5,top: 5,bottom: 10),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: tc('TM', Colors.white, 15),
                      ),
                      gapHC(20),
                      wMenuCard(Icons.home_outlined,"Home","H"),
                      g.wstrUserRole == "ADMIN" || g.wstrUserRole == "DEPHEAD" || g.wstrUserRole == "SUPER"?
                      wMenuCard(Icons.home_outlined,"My Profile","PROFILE"):
                      gapHC(0),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              wMenuCard(Icons.view_module_outlined,"Module","M"),
                              Container(
                                decoration: boxDecoration(Colors.white, 5),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: wModuleCount(),
                                ),
                              ),
                              gapHC(10),
                              wMenuCard(Icons.local_fire_department_rounded,"Priority","P"),
                              Container(
                                decoration: boxDecoration(Colors.white, 5),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: wPriorityCount(),
                                ),
                              ),
                              gapHC(10),
                              wMenuCard(Icons.error,"Issue","I"),
                              Container(
                                decoration: boxDecoration(Colors.white, 5),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  children: wIssueCount(),
                                ),
                              )


                            ],
                          ),
                        ),
                      ),
                      gapHC(10),
                      Bounce(
                        duration: const Duration(milliseconds: 110),
                        onPressed: (){
                          fnLogOut1();
                        },
                        child: Container(
                          decoration: boxOutlineCustom1(Colors.black, 30, greyLight.withOpacity(0.5), 1.0),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              tcn('Sign Out', Colors.white, 12),
                              gapWC(5),
                              const Icon(Icons.power_settings_new,color: Colors.white,size: 14,)
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
                            decoration: boxDecoration(g.wstrDarkMode?Colors.black: Colors.white, 10),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Bounce(
                                        duration: const Duration(milliseconds: 110),
                                        onPressed: () {
                                          if(mounted){
                                            setState(() {
                                              lstrTaskListPageNo = 0;

                                            });
                                          }
                                          apiGetTask();
                                        },
                                        child: Image.asset(g.wstrDarkMode?"assets/images/namewhite.png":"assets/images/nameblack.png",width: 150,)),
                                    Row(
                                      children:  [
                                        Bounce(
                                          duration: const Duration(milliseconds: 110),
                                          onPressed: (){

                                            if(mounted){
                                              setState(() {
                                                sideNavigation= "T";
                                              });
                                            }
                                            scaffoldKey.currentState?.openEndDrawer();

                                          },
                                          child: Container(
                                            decoration: boxGradientDecorationBase(24, 30),
                                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.add,color: Colors.white,size: 14,),
                                                gapWC(10),
                                                Container(
                                                  height: 15,
                                                  width: 1,
                                                  decoration: boxBaseDecoration(greyLight.withOpacity(0.7), 10),
                                                ),
                                                gapWC(10),
                                                tcn('New Task    ', Colors.white, 14)
                                              ],
                                            ),
                                          ),
                                        ),
                                        gapWC(10),
                                        Container(
                                          decoration: boxBaseDecoration(greyLight, 5),
                                          padding: const EdgeInsets.all(3),
                                          child: Row(
                                            children: [
                                              wDayMode(Icons.light_mode_outlined,"A"),
                                              gapWC(5),
                                              wDayMode(Icons.dark_mode_outlined,"D"),
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
                                        blSideScreen?
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                          decoration: boxOutlineCustom1(Colors.white, 5, Colors.grey.withOpacity(0.5) , 0.5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  tcn(g.wstrUserCd.toString(),Colors.black,10),
                                                  tc(g.wstrUserName.toString(),Colors.black,12)
                                                ],
                                              ),
                                              gapWC(30),
                                              Container(
                                                padding: const EdgeInsets.all(5),
                                                decoration: boxBaseDecoration(color2, 30),
                                                child: const Icon(Icons.person,color: Colors.white ,size: 20,),
                                              )
                                            ],
                                          ),
                                        ):
                                        gapHC(0),
                                        gapWC(10),
                                        GestureDetector(
                                            onTap: (){
                                              if(mounted){
                                                setState(() {
                                                  blSideScreen = blSideScreen?false:true;
                                                });
                                              }
                                            },
                                            child:  Icon(blSideScreen?Icons.navigate_before:Icons.navigate_next_rounded,color: Colors.blueGrey,size: 20,)
                                        ),

                                      ],
                                    )
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
                                  onPressed: (){
                                    if(mounted){
                                      setState(() {
                                        lstrTaskListPageNo = 0;
                                        flStatus = "";
                                        flOverDueYn = "N";
                                      });
                                    }
                                    apiGetTask();
                                  },
                                  child: Container(
                                    decoration: boxDecoration(Colors.white, 5),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.list,color: color2,size: 30,),
                                        gapWC(10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            tc((openTicket+closedTicket+droppedTicket).toString(), color2 , 25),
                                            ts('Total Task  ', color3 , 12)
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
                                  onPressed: (){
                                    if(mounted){
                                      setState(() {
                                        lstrTaskListPageNo = 0;
                                        flStatus = "P";
                                        flOverDueYn = "N";
                                      });
                                    }
                                    apiGetTask();
                                  },
                                  child: Container(
                                    decoration: boxDecoration(Colors.white, 5),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.task_alt,color: Colors.green,size: 30,),
                                        gapWC(10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            tc(openTicket.toString(), Colors.green , 25),
                                            ts('Open Task  ', color3 , 12)
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
                                  onPressed: (){
                                    if(mounted){
                                      setState(() {
                                        lstrTaskListPageNo = 0;
                                        flStatus = "C";
                                        flOverDueYn = "N";
                                      });
                                    }
                                    apiGetTask();
                                  },
                                  child: Container(
                                    decoration: boxDecoration(Colors.white, 5),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.thumb_up_alt_outlined,color: Colors.red,size: 30,),
                                        gapWC(10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            tc(closedTicket.toString(), Colors.red , 25),
                                            ts('Closed Task  ', color3 , 12)
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
                                  onPressed: (){
                                    if(mounted){
                                      setState(() {
                                        lstrTaskListPageNo = 0;
                                        flStatus = "D";
                                        flOverDueYn = "N";
                                      });
                                    }
                                    apiGetTask();
                                  },
                                  child: Container(
                                    decoration: boxDecoration(Colors.white, 5),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.cancel_outlined,color: Colors.purple,size: 30,),
                                        gapWC(10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            tc(droppedTicket.toString(), Colors.purple , 25),
                                            ts('Dropped Task ', color3 , 12)
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
                                  onPressed: (){
                                    if(mounted){
                                      setState(() {
                                        lstrTaskListPageNo = 0;
                                        flStatus = "";
                                        flOverDueYn = "Y";
                                      });
                                    }
                                    apiGetTask();
                                  },
                                  child: Container(
                                    decoration: boxDecoration(Colors.white, 5),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.upcoming,color: Colors.red,size: 30,),
                                        gapWC(10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            tc(overdueTicket.toString(), Colors.red , 25),
                                            ts('Overdue ', Colors.red , 12)
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    !blSearch?
                                    tc('Task Details', Colors.deepOrange, 15):gapHC(0),
                                    gapWC(10),
                                    !blSearch && flStatus.isNotEmpty?
                                    tc(flOverDueYn == "Y"?"Overdue Task":flStatus == "P"?"Open Task":flStatus == "C"?"Closed Task":flStatus == "D"?"Dropped Task":"", Colors.black, 15):gapHC(0),
                                    blSearch?
                                    Expanded(
                                      child: Container(
                                        height: 30,
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: TextFormField(
                                          controller: txtSearch,
                                          onChanged: (val){
                                            if(mounted){
                                              setState(() {
                                                lstrTaskListPageNo = 0;
                                              });
                                            }
                                            apiGetTask();
                                          },
                                          decoration: const InputDecoration(
                                            hintText: 'Search....',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ):gapHC(0),
                                    Row(
                                      children: [
                                        InkWell(
                                            onTap: (){
                                              if(mounted){
                                                setState(() {
                                                  txtSearch.clear();
                                                  blSearch =blSearch?false: true;
                                                  lstrTaskListPageNo = 0;
                                                });

                                                apiGetTask();
                                              }
                                            },
                                            child:  Icon(blSearch?Icons.close: Icons.search,color: Colors.blueGrey,size: 20,)),
                                        Container(

                                          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 10),
                                          child: Row(
                                            children: [
                                              wTaskListViewIcon(Icons.view_kanban_outlined,"K"),
                                              gapWC(5),
                                              wTaskListViewIcon(Icons.list,"L"),
                                              gapWC(5),
                                              wTaskListViewIcon(Icons.grid_view_rounded,"G"),

                                            ],
                                          ),
                                        ),
                                        gapWC(20),
                                        Bounce(
                                            onPressed: (){
                                              if(mounted){
                                                setState(() {
                                                  sideNavigation= "T";
                                                });
                                              }
                                              scaffoldKey.currentState?.openEndDrawer();
                                            },
                                            duration: const Duration(milliseconds: 110),
                                            child: const Icon(Icons.add_circle_outlined,color: Colors.deepOrange,size: 20,)),
                                        gapWC(10),
                                        Bounce(
                                            onPressed: (){
                                              if(mounted){
                                                setState(() {
                                                  sideNavigation= "F";
                                                });
                                              }
                                              scaffoldKey.currentState?.openEndDrawer();
                                            },
                                            duration: const Duration(milliseconds: 110),
                                            child: const Icon(Icons.filter_list_alt,color: Colors.deepOrange,size: 20,)),
                                        gapWC(20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                                onTap: (){
                                                  if(lstrTaskListPageNo == 0){
                                                    return;
                                                  }
                                                  if(mounted){
                                                    setState(() {
                                                      lstrTaskListPageNo =lstrTaskListPageNo-1;
                                                    });
                                                    apiGetTask();
                                                  }
                                                },
                                                child: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,size: 15,)),
                                            gapWC(10),
                                            lstrTaskList.isNotEmpty?
                                            GestureDetector(
                                                onTap: (){
                                                  if(mounted){
                                                    setState(() {
                                                      if(lstrTaskList.isNotEmpty){
                                                        lstrTaskListPageNo =lstrTaskListPageNo+1;
                                                      }

                                                    });
                                                    apiGetTask();
                                                  }
                                                },
                                                child: const Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,size: 15,)):gapHC(0),
                                          ],
                                        )
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    wRowHead("Task","DOCNO",3,"Y"),
                                    wRowHead("Issue","ISSUE_TYPE",1,"Y"),
                                    wRowHead("Company","COMPANY_NAME",2,"Y"),
                                    wRowHead("Module","MODULE",1,"Y"),
                                    wRowHead("Status","STATUS",1,"Y"),
                                    wRowHead("Create Date","CREATE_DATE",1,"Y"),
                                    wRowHead("Deadline","DEADLINE",1,"Y"),
                                    wRowHead("Priority","PRIORITY",1,"Y"),
                                    wRowHead("Created By","CREATE_USER",1,"Y"),


                                  ],
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: wTaskList(),
                              ),
                            ),
                          ),
                          Container(

                            decoration: boxDecoration(Colors.white, 10),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row()
                              ],
                            ),
                          )


                        ],
                      ),
                    )),
                blSideScreen?
                Container(
                  decoration: boxDecoration(Colors.white, 10),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Bounce(
                        duration: const Duration(milliseconds: 110),
                        onPressed: (){

                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          decoration: boxGradientDecorationBase(11, 100),
                          child: Icon(Icons.account_circle,color: Colors.white,size: 20,),
                        ),
                      ),
                      gapHC(10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration:boxOutlineCustom1(Colors.white, 5, color2 ,1.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: const Icon(Icons.notifications_none,color: color2,size: 18,),
                      ),
                      gapHC(10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: boxOutlineCustom1(Colors.white, 5, color2 ,1.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: const Icon(Icons.access_time_outlined,color: color2,size: 18,),
                      ),
                      Expanded(child: Column(children: [],)),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: boxBaseDecoration(Colors.blueGrey,10),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: const Icon(Icons.support_agent,color: Colors.white,size: 18,),
                      ),
                      gapHC(5),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: boxBaseDecoration(Colors.blueGrey,10),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: const Icon(Icons.help_outline,color: Colors.white,size: 18,),
                      ),
                      gapHC(10),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: boxOutlineCustom1(Colors.white, 5, color2 ,1.0),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        child: const Icon(Icons.search,color: color2,size: 18,),
                      ),



                    ],
                  ),
                ):
                Flexible(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: boxBaseDecoration(Colors.white, 0),
                    child: Column(
                      children: [
                        Expanded(child: Column(
                          children: [
                            Row(),
                            Bounce(
                              duration: const Duration(milliseconds: 110),
                              onPressed: (){

                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 80,
                                width: 80,
                                decoration: boxGradientDecorationBase(11, 100),
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                child: Icon(Icons.account_circle,color: Colors.white,size: 50,),
                              ),
                            ),
                            gapHC(10),

                            tcn(g.wstrUserName.toString(), color2, 14),
                            tcn(g.wstrMainClientId.toString(),Colors.black,10),
                            tc(g.wstrMainClientName.toString(),Colors.black,12),
                            gapHC(20),
                            Expanded(
                              child: Container(
                                decoration: boxOutlineCustom1(Colors.white  , 10, greyLight, 1.0),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.circle_notifications_outlined,color: color3,size: 20,),
                                            gapWC(5),
                                            tc('Notification', color3, 12),
                                            gapWC(5),
                                            Container(
                                              decoration: boxDecoration(Colors.red, 5),
                                              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                                              child: tcn('10+', Colors.white  , 8),
                                            )
                                          ],
                                        ),
                                        const Icon(Icons.arrow_forward_ios_sharp,color: color3,size: 10,)
                                      ],
                                    ),
                                    gapHC(5),
                                    lineC(1.0, greyLight)
                                  ],
                                ),
                              ),
                            ),
                            gapHC(5),
                            Expanded(child: Container(
                              decoration: boxOutlineCustom1(Colors.white  , 10, greyLight, 1.0),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.task_alt,color: color3,size: 20,),
                                          gapWC(5),
                                          tc('Last Activity', color3, 12),
                                          gapWC(5),
                                        ],
                                      ),
                                      const Icon(Icons.arrow_forward_ios_sharp,color: color3,size: 10,)
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
                            Flexible(child: Container(
                              decoration: boxBaseDecoration(Colors.green, 5),
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.support_agent,color: Colors.white,size: 14,),
                                  gapWC(10),
                                  tcn('Chat', Colors.white, 14),
                                  gapWC(5),

                                ],
                              ),
                            ),),
                            gapWC(5),
                            Flexible(child: Container(
                              decoration: boxBaseDecoration(Colors.blueGrey, 5),
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.help_outline_rounded,color: Colors.white,size: 14,),
                                  gapWC(10),
                                  tcn('Help', Colors.white, 14),
                                  gapWC(5),

                                ],
                              ),
                            ),)
                          ],
                        ),
                        gapHC(10),
                        Bounce(
                          duration: const Duration(milliseconds: 110),
                          onPressed: (){

                          },
                          child: Container(
                              decoration: boxOutlineCustom1(Colors.white, 5, color2 ,1.0),
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search,color: color2,size: 15,),
                                  gapWC(10),
                                  tcn('Enquiry', color2, 14)
                                ],
                              )
                          ),
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
  List<Widget> wTaskList(){
    List<Widget> rtnList  = [];
    for(var e in lstrTaskList){
      var srno  = e["SRNO"]??"";
      var docno  = e["DOCNO"]??"";
      var doctype  = e["DOCTYPE"]??"";
      var docDate  = e["DOCDATE"]??"";
      var mainClientId  = e["MAIN_CLIENT_ID"]??"";
      var clientId  = e["CLIENT_ID"]??"";
      var clientCompany  = e["CLIENT_COMPANY"]??"";
      var clientCompanyName  = e["COMPANY_NAME"]??"";
      var contactPerson  = e["CONTACT_PERSON"]??"";
      var contactPersonMob  = e["CONTACT_MOB"]??"";
      var contactPersonEmail  = e["CONTACT_EMAIL"]??"";
      var taskHead  = e["TASK_HEADER"]??"";
      var taskDetails  = e["TASK_DETAIL"]??"";
      var createUser  = e["CREATE_USER"]??"";
      var createDate  = e["CREATE_DATE"]??"";
      var closedTime  = e["END_TIME"]??"";
      var completedUser  = e["COMPLETED_USER"]??"";
      var deadlineDate  = e["DEADLINE"]??"";
      var priorityCode  = e["PRIORITY"]??"";
      var priority  = e["PRIORITY_DESCP"]??"";
      var status  = e["STATUS"]??"";
      var module  = e["MODULE"]??"";
      var taskType  = e["TASK_TYPE"]??"";
      var clientType  = e["CLIENT_TYPE"]??"";
      var issueTypeCode  = e["ISSUE_TYPE"]??"";
      var issueType  = e["ISSUE_TYPE_DESCP"]??"";
      var completionNote  = e["COMPLETION_NOTE"]??"";
      var taskDate  =  createDate != ""? setDate(6, DateTime.parse(createDate)):"";
      var deadline  =  deadlineDate != ""? setDate(6, DateTime.parse(deadlineDate)):"";
      var closeDate  =  closedTime != ""? setDate(6, DateTime.parse(closedTime)):"";
      var deadlineSts  = false;
      try{
        var dDate  =DateTime.parse(deadlineDate);
        var now =  DateTime.now();

        if(dDate.isBefore(now)){
          deadlineSts =true;
        }


      }catch(e){
        deadlineSts  = false;
      }


      rtnList.add(GestureDetector(
        //duration:const Duration(milliseconds: 110),
        onDoubleTap: (){
          apiGetTaskDet(mainClientId,docno,doctype);
        },
        child: MouseRegion(
          onHover: (sts){
            if(mounted){
              setState(() {
                flSortColumn = "";
                lstrViewDocno = docno;
              });
            }
          },
          child: Container(
            decoration: boxBaseDecoration( lstrViewDocno == docno?color2.withOpacity(0.1): Colors.white, 0),
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    wRowDet(tcn("${srno.toString()} .  $docno", color3, 10),1),
                    wRowDet(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        status != "P"?
                        tcs(taskHead.toString().toUpperCase(), priority == "CRITICAL" && status == "P"?Colors.red: Colors.black, 10):
                        tc(taskHead.toString().toUpperCase(), priority == "CRITICAL" && status == "P"?Colors.red: Colors.black, 10),
                        lstrViewDocno == docno?
                        tcn(taskDetails, Colors.black, 10):
                        gapHC(0),
                      ],
                    ),2),
                    wRowDet(tcn(issueType, color3, 10),1),
                    wRowDet(tc(clientCompany + " | " +clientCompanyName, color3, 10),2),
                    wRowDet(tcn(module, color3, 10),1),
                    wRowDet( status != ""?
                    PopupMenuButton<Menu>(
                      position: PopupMenuPosition.under,
                      tooltip: "",
                      onSelected: (Menu item) {

                      },
                      shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                        PopupMenuItem<Menu>(
                          value: Menu.itemOne,
                          padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                          child: SearchPopup(
                            searchYn: "N",
                            lstrColumnList: [{"COLUMN":"DESCP","CAPTION":"Status"}],
                            lstrData: lstrStatusList,
                            callback: (val){
                              if(mounted){
                                var changeSts  =  val["CODE"];
                                apiUpdateTask(docno, doctype, changeSts, issueTypeCode, priorityCode);
                              }
                            },),
                        ),
                      ],
                      child:  Container(
                        decoration: boxBaseDecoration(status == "P"? Colors.green:status == "C"? Colors.red:status =="D"? Colors.purple:color2, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                        child: tcn(status == "P"?"Open":status == "C"?"Closed":status =="D"?"Dropped":"", Colors.white, 10),

                      ),
                    )
                        :gapHC(0),1),
                    wRowDet(tcn(taskDate, color3, 10),1),
                    deadlineSts && status == "P"?
                    wRowDet(tc(deadline, Colors.red, 10),1):
                    wRowDet(tcn(deadline, color3, 10),1),
                    wRowDet(PopupMenuButton<Menu>(
                      enabled: status != "P"?false:true,
                      position: PopupMenuPosition.under,
                      tooltip: "",
                      onSelected: (Menu item) {
                        setState(() {
                        });
                      },
                      shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                        PopupMenuItem<Menu>(
                          enabled: status != "P"?false:true,
                          value: Menu.itemOne,
                          padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                          child: SearchPopup(
                            searchYn: "N",
                            lstrColumnList: const [{"COLUMN":"DESCP","CAPTION":"Priority"}],
                            lstrData: lstrPriorityList,
                            callback: (val){
                              if(mounted){
                                apiUpdateTask(docno, doctype, status, issueTypeCode, val["CODE"]);
                              }
                            },),
                        ),
                      ],
                      child:  Row(
                        children: [
                          Icon(
                            priority == "EMERGENCY"?Icons.warning:priority == "CRITICAL"?Icons.local_fire_department_outlined:priority == "NORMAL"?Icons.cloud_queue_outlined:priority == "MEDIUM"?Icons.adjust_rounded:Icons.warning
                            ,
                            color: priority == "EMERGENCY"?Colors.deepOrange:priority == "CRITICAL"?Colors.red:priority == "NORMAL"?Colors.blue:priority == "MEDIUM"?Colors.amber:Colors.black
                            ,size: 12,),
                          gapWC(5),
                          tcn(priority.toString(), Colors.black, 12),
                        ],
                      ),
                    ),1),
                    wRowDet(tcn(createUser.toString().toUpperCase(), color3, 10),1),

                  ],
                ),
                status != "P" && lstrViewDocno == docno?
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: boxBaseDecoration(greyLight.withOpacity(0.4), 2),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            tc("COMPLETION NOTE ", Colors.black , 8),
                            gapWC(10),
                            Expanded(child: tcn(completionNote.toString(), Colors.black , 10),)
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_month,color: Colors.black,size: 12,),
                            gapWC(10),
                            Expanded(child: tcn(closeDate.toString(), Colors.black , 10),)
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.person,color: Colors.black,size: 12,),
                            gapWC(10),
                            Expanded(child: tcn(completedUser.toString(), Colors.black , 10),)
                          ],
                        ),
                      ],
                    )
                ):
                gapHC(0),
                status != "C" && lstrViewDocno == docno?
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Bounce(
                      duration:const Duration(milliseconds: 110),
                      onPressed: (){
                        apiStartTask(docno, doctype);
                      },
                      child: Container(
                          decoration: boxDecoration(color2, 30),
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                          child: Row(
                            children: [
                              const Icon(Icons.play_circle_filled_rounded,color: Colors.white,size: 12,),
                              gapWC(5),
                              tcn('START', Colors.white, 12)
                            ],
                          )
                      ),
                    ),
                    gapWC(5),

                    wSettingsCard(Icons.pause),
                    gapWC(5),
                    Bounce(
                        duration: Duration(milliseconds: 110),
                        onPressed: (){
                          apiMoveTask(docno, doctype);
                        },
                        child: wSettingsCard(Icons.screen_share_outlined)
                    ),
                    gapWC(5),
                    wSettingsCard(Icons.task_alt_rounded),
                    gapWC(5),
                    wSettingsCard(Icons.access_time),
                    gapWC(5),
                    wSettingsCard(Icons.add_task_outlined),
                    gapWC(5),
                    wSettingsCard(Icons.comment),
                    gapWC(5),
                    wSettingsCard(Icons.admin_panel_settings_rounded)

                  ],
                ) :
                gapHC(0),
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
  Widget wTaskListViewIcon(icon,mode){
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        if(mounted){
          setState(() {
            lstrTaskListViewMode = mode;
          });
        }
      },
      child: Container(
        decoration: lstrTaskListViewMode == mode? boxDecoration(Colors.white, 5):boxBaseDecoration(Colors.transparent, 2),
        padding: const EdgeInsets.all(3),
        child:  Icon(icon,size: 20,color:lstrTaskListViewMode == mode? Colors.deepOrange: Colors.black),
      ),
    );
  }
  Widget wRowHead(title,column,flex,sortYn){
    return Flexible(
        flex: flex,
        child: MouseRegion(
            onHover: (hvr){
              if(mounted){
                setState(() {
                  if(sortYn == "Y"){
                    flSortColumn = column;
                  }

                });
              }
            },
            child: GestureDetector(
              onTap: (){
                if(flSortColumnDir == "ASC"){
                  fnSort(column,"DESC");
                }else{
                  fnSort(column,"ASC");
                }
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: flSortColumn == column?boxBaseDecoration(yellowLight.withOpacity(0.5), 2):boxBaseDecoration(Colors.transparent, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Row(
                          children: [
                            Expanded(child: tc(title, color3, 12),),
                            gapWC(5),
                            (column == "PRIORITY" && flPriorityList.isNotEmpty) ||(column == "ISSUE_TYPE" && flIssueTypeList.isNotEmpty)
                                ||(column == "COMPANY_NAME" && flCompanyList.isNotEmpty)||(column == "MODULE" && flModuleList.isNotEmpty)||(column == "CREATE_USER" && flUserList.isNotEmpty)
                                ?
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 5),
                              decoration: boxBaseDecoration(color2, 5),
                              child: tcn((column == "PRIORITY"?flPriorityList.length:column == "ISSUE_TYPE"?flIssueTypeList.length:column == "COMPANY_NAME"?flCompanyList.length:column == "CREATE_USER"?flUserList.length:column == "MODULE"?flModuleList.length:'0').toString(), Colors.white, 10),
                            ):
                            gapWC(0),
                          ],
                        ),),
                        gapWC(5),
                        flSortColumn == column?
                        Row(
                          children: [
                            flSortColumnDir == "DESC"? const Icon(Icons.arrow_downward_rounded,size:10):const Icon(Icons.arrow_upward_sharp,size:10),
                            gapWC(2),
                            PopupMenuButton<Menu>(
                              position: PopupMenuPosition.under,
                              tooltip: "",
                              onSelected: (Menu item) {
                                setState(() {
                                });
                              },
                              shape:  RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                                PopupMenuItem<Menu>(
                                  value: Menu.itemOne,
                                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                                  child: wFilterPopup(column),
                                ),
                              ],
                              child:  const Icon(Icons.filter_list_alt,size:12),
                            )
                            ,
                            // GestureDetector(
                            //     onTap: (){
                            //       fnSort(column,"ASC");
                            //     },
                            //     child: const Icon(Icons.arrow_upward_sharp,size:10))

                          ],
                        ):gapHC(0),
                      ],
                    ),

                  ],
                ),
              ),
            )

        )
    );
  }
  Widget wRowDet(child,flex){
    return Flexible(
        flex: flex,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(),
            child
          ],
        )
    );
  }
  Widget wDayMode(icon,mode){
    var pageMode =  g.wstrDarkMode ?"D":"A";
    return  Bounce(
      onPressed: (){
        setState(() {
          g.wstrDarkMode = (mode == "D"? true:false);
        });
      },
      duration: const Duration(milliseconds: 110),
      child: Container(
        decoration: pageMode == mode? boxDecoration(Colors.white, 5):boxBaseDecoration(greyLight.withOpacity(0.1), 5),
        padding: const EdgeInsets.all(5),
        child:  Icon(icon,color:pageMode == mode?Colors.orange: Colors.black,size: 15,),
      ),
    );
  }

  Widget wMenuCard(icon,text,mode){
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        if(mounted){
          setState(() {
            lstrMenuHoverMode = mode;
            flCompanyList = [];
            flPriorityList = [];
            flIssueTypeList = [];
            flModuleList = [];

            flSelectedPriority = "";
            flSelectedIssue = "";
            flSelectedModule = "";
          });

          apiGetTask();
        }
      },
      child: InkWell(
        onHover: (v){

        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              padding: const EdgeInsets.all(5),
              decoration: lstrMenuHoverMode == mode?boxBaseDecoration(greyLight.withOpacity(0.3) , 10):boxBaseDecoration(Colors.transparent , 0),
              child: Row(
                children: [
                  gapWC(5),
                  Icon(icon,color: Colors.white,size: 14,),
                  gapWC(5),
                  tcn(text, Colors.white, 14)
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
  Widget wFilterPopup(mode){
    if(mounted){
      setState(() {
        flSelectedIssue = "";
        flSelectedPriority = "";
        flSelectedModule = "";
      });
    }
    if(mode == "PRIORITY"){
      return FilterPopup(
        lstrColumnList: [],
        lstrData: lstrPriorityList,
        callback: (data){
          if(mounted){
            setState(() {

              flPriorityList = data;
            });
            apiGetTask();
          }
        },
        mainKey: "CODE",
        showKey: "DESCP",
        lstrOldData: flPriorityList,
      );
    }
    else if(mode == "ISSUE_TYPE"){
      return FilterPopup(
        lstrColumnList: [],
        lstrData: lstrIssueTypeList,
        callback: (data){
          if(mounted){
            setState(() {
              flIssueTypeList = data;
            });
            apiGetTask();
          }
        },
        mainKey: "CODE",
        showKey: "DESCP",
        lstrOldData: flIssueTypeList,
      );
    }
    else if(mode == "COMPANY_NAME"){
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CLIENT_ID', 'Display': '#'},
        {'Column': 'NAME', 'Display': 'Company'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
      ];
      var lstrFilter =[

      ];

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
        callback: (data){
          if(mounted){
            setState(() {
              flCompanyList = data;
            });
            apiGetTask();
          }
        },
        searchYn: 'Y',
      );
    }
    else if(mode == "CREATE_USER"){
      if(g.wstrUserRole != "ADMIN"){
        return Container();
      }
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'USER_CD', 'Display': 'User'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
      ];
      var lstrFilter =[

      ];

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
        callback: (data){
          if(mounted){
            setState(() {
              flUserList = data;
            });
            apiGetTask();
          }
        },
        searchYn: 'Y',
      );
    }
    else if(mode == "MODULE"){

      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'User'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
      ];
      var lstrFilter =[

      ];

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
        callback: (data){
          if(mounted){
            setState(() {
              flModuleList = data;
            });
            apiGetTask();
          }
        },
        searchYn: 'Y',
      );
    }
    else{
      return Container();
    }
  }

  Widget wSettingsCard(icon){
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: boxDecoration(Colors.white, 5),
      child:  Icon(icon,color: color2,size: 18,),
    );
  }

  //Filter
  Widget wFilterCard(){
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list_alt,color: color2,size: 15,),
              gapWC(10),
              tcn('Filters', color2 , 15),
            ],
          ),
          gapHC(5),
          lineC(1.0, greyLight),
          gapHC(10),
          Expanded(child: Column(
            children: [

            ],
          )),
          Row(
            children: [
              Container(
                decoration: boxBaseDecoration(color2, 30),
                padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 5),
                child: Column(
                  children: [
                    Row(),
                    tcn('Apply', Colors.white, 12)
                  ],
                ),
              ),
              gapWC(10),
              Container(
                decoration: boxOutlineCustom1(Colors.white, 30, Colors.black.withOpacity(0.5  ), 1.0),
                padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
                child: Column(
                  children: [
                    Row(),
                    tcn('Clear', Colors.black, 12)
                  ],
                ),
              ),
            ],
          )

        ],
      ),
    );
  }

  //Side Menu List
  List<Widget> wModuleCount(){
    List<Widget> rtnList  = [];
    var srno  = 1;
    for(var e in moduleCount){
      var module  = e["MODULE"]??"";
      var count  = e["COUNT"]??"";
      rtnList.add(
          Bounce(
            onPressed: (){
              if(mounted){
                setState(() {
                  flSelectedPriority = "";
                  flSelectedIssue = "";
                  flSelectedModule = module;
                  flPriorityList = [];
                  flModuleList = [];
                  flIssueTypeList = [];
                  flCompanyList = [];
                });
                apiGetTask();
              }
            },
            duration: Duration(milliseconds: 110),
            child: Container(
              decoration:flSelectedModule ==module?  boxBaseDecoration(blueLight, 5) : boxBaseDecoration(bGreyLight, 5),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tc(module.toString(), Colors.black, 10),
                  tc(count.toString(), color2, 12),
                ],
              ),
            ),
          )
      );
      srno = srno+1;
    }
    return rtnList;
  }
  List<Widget> wPriorityCount(){
    List<Widget> rtnList  = [];
    var srno  = 1;
    for(var e in priorityCount){
      var code  = e["PRIORITY"]??"";
      var module  = e["DESCP"]??"";
      var count  = e["COUNT"]??"";
      rtnList.add(
          Bounce(
            onPressed: (){
              if(mounted){
                setState(() {
                  flSelectedPriority = code;
                  flSelectedIssue = "";
                  flSelectedModule = "";
                  flPriorityList = [];
                  flModuleList = [];
                  flIssueTypeList = [];
                  flCompanyList = [];
                });
                apiGetTask();
              }

            },
            duration: Duration(milliseconds: 110),
            child: Container(
              decoration: module == "CRITICAL" && count > 0? boxBaseDecoration(Colors.red, 5): flSelectedPriority ==code?  boxBaseDecoration(blueLight, 5) : boxBaseDecoration(bGreyLight, 5),
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tc(module.toString(),module == "CRITICAL" && count > 0?Colors.white: Colors.black, 10),
                  tc(count.toString(), module == "CRITICAL" && count > 0?Colors.white:Colors.deepOrange, 12),
                ],
              ),
            ),
          )
      );
      srno = srno+1;
    }
    return rtnList;
  }
  List<Widget> wIssueCount(){
    List<Widget> rtnList  = [];
    var srno  = 1;
    for(var e in issueCount){
      var code  = e["ISSUE_TYPE"]??"";
      var module  = e["DESCP"]??"";
      var count  = e["COUNT"]??"";
      rtnList.add(
          Bounce(
            onPressed: (){
              if(mounted){
                setState(() {
                  flSelectedPriority = "";
                  flSelectedIssue = code;
                  flSelectedModule = "";
                  flPriorityList = [];
                  flModuleList = [];
                  flIssueTypeList = [];
                  flCompanyList = [];
                });
                apiGetTask();
              }
            },
            duration: Duration(milliseconds: 110),
            child: Container(
              decoration:flSelectedIssue ==code?  boxBaseDecoration(blueLight, 5) : boxBaseDecoration(bGreyLight, 5),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tc(module.toString(), Colors.black, 10),
                  tc(count.toString(), color2, 12),
                ],
              ),
            ),
          )
      );
      srno = srno+1;
    }
    return rtnList;
  }

  //======================================PAGE FN

  fnGetPageData(){
    if(mounted){

      scrollController.addListener(pagination);

      setState(() {
        lstrStatusList = [];
        lstrStatusList.add({
          "CODE":"P",
          "DESCP":"OPEN",
        });
        lstrStatusList.add({
          "CODE":"C",
          "DESCP":"CLOSED",
        });
        lstrStatusList.add({
          "CODE":"D",
          "DESCP":"DROPED",
        });


        wstrPageForm = [];
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtTaskHead,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please Fill Task Head","FILL_CODE":"PRICE","PAGE_NODE":""});
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtTaskDescp,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please fill task description","FILL_CODE":"PRICE","PAGE_NODE":""});
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtContactPeron,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please mention contact person","FILL_CODE":"PRICE","PAGE_NODE":""});
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtMobile,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please enter mobile no","FILL_CODE":"PRICE","PAGE_NODE":""});
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtEmail,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please enter email no","FILL_CODE":"PRICE","PAGE_NODE":""});


        timer = Timer.periodic(const Duration(seconds: 1200), (Timer t) => apiGetTask());

      });
    }
    apiCompanyDetails();
    apiGetTaskMasters();

  }
  fnStartRecord() async{
    bool isRecording = await record.isRecording();
    if(isRecording){
      final path = await record.stop();
      dprint(path);
    }else{
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
        title: tcn('Sign Out',color2,20),
        content: tcn('Do you want to sign out?', Colors.black, 14),
        actions: <Widget>[
          Container(
            width : 80,
            height:35,
            decoration: boxOutlineCustom1(Colors.white, 30, Colors.blueGrey  , 1.0),
            child:  TextButton(
              onPressed: () => Navigator.pop(context),
              child: tc('NO', Colors.blueGrey, 12),
            ),
          ),
          gapWC(3),
          Container(
            width : 80,
            height: 35,
            decoration: boxBaseDecoration(color2, 30),
            child:TextButton(
              onPressed: () async {
                final SharedPreferences prefs = await _prefs;
                if(mounted){
                  setState(() {
                    g.wstrLKey = "";
                    g.wstrLoginYn= "N";
                    prefs.setString('wstrLoginYn', "N");
                  });
                }
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) =>  const LoginScreen()
                ));
              } ,
              child: tc('YES', Colors.white, 12),
            ) ,
          ),
        ],
      ),
    );



  }

  //Filter
  fnSort(column,arrow){
    if(mounted){
      setState(() {
        flSortColumnName = column;
        flSortColumnDir = arrow;
      });
    }
    apiGetTask();
  }
  void pagination() {
    if ((scrollController.position.pixels ==
        scrollController.position.maxScrollExtent)) {
      setState(() {
        print('--------------------------------PAGE$lstrTaskListPageNo----------------------------');
        lstrTaskListPageNo += 1;
        apiGetTask();
        //add api for load the more data according to new page
      });
    }
  }

  //======================================API CALL

  apiCompanyDetails(){
    futureForm = apiCall.apiGetCompanyModule();
    futureForm.then((value) => apiCompanyDetailsRes(value));
  }
  apiCompanyDetailsRes(value){
    if(mounted){
      setState(() {
        lstrCompanyList = [];
        lstrModuleList = [];
        if(g.fnValCheck(value)){
          lstrCompanyList =  value["COMPANY"];
          lstrModuleList =  value["CLIENT_MODULE"];
        }
      });
      apiGetTask();
    }

  }

  apiGetTask(){
    if(mounted){
      setState(() {
        lstrTaskList =[];
      });
    }

    var sortCol = flSortColumn == ""?"":flSortColumnName,sortDir = flSortColumn == ""?"":flSortColumnDir,search = "";
    var client = [],task= [],issue= [],clientType= [],status= [],userList= [],priorityList= [],moduleList = [];
    userList.add({'COL_VAL':g.wstrUserCd});

    if(g.wstrUserRole == "ADMIN"){
      userList = [];
      if(flUserList.isNotEmpty){
        for(var e in  flUserList){
          userList.add({'COL_VAL':e});
        }
      }
    }
    if(flStatus.isNotEmpty){
      status.add({'COL_VAL':flStatus});
    }
    if(flSelectedPriority.isEmpty){
      if(flPriorityList.isNotEmpty){
        for(var e in  flPriorityList){
          priorityList.add({'COL_VAL':e});
        }
      }
    }else{
      priorityList.add({'COL_VAL':flSelectedPriority});
    }
    if(flSelectedIssue.isEmpty){
      if(flIssueTypeList.isNotEmpty){
        for(var e in  flIssueTypeList){
          issue.add({'COL_VAL':e});
        }
      }
    }else{
      issue.add({'COL_VAL':flSelectedIssue});
    }

    if(flCompanyList.isNotEmpty){
      for(var e in  flCompanyList){
        client.add({'COL_VAL':e});
      }
    }

    if(flSelectedModule.isEmpty){
      if(flModuleList.isNotEmpty){
        for(var e in  flModuleList){
          moduleList.add({'COL_VAL':e});
        }
      }
    }else{
      moduleList.add({'COL_VAL':flSelectedModule});
    }
    var profileYn  = "Y";
    if(lstrMenuHoverMode == "H" && (g.wstrUserRole == "ADMIN" || g.wstrUserRole == "DEPHEAD" || g.wstrUserRole == "SUPER")){
      profileYn = "N";
    }


    futureForm = apiCall.apiGetTask(null,null,null,null,g.wstrMainClientId,"",lstrTaskListPageNo,sortCol,sortDir,txtSearch.text,client,task,issue,clientType,status,userList,priorityList,flOverDueYn,moduleList,profileYn,[],[],[]);
    futureForm.then((value) => apiGetTaskRes(value));
  }
  apiGetTaskRes(value){
    if(mounted){
      setState(() {
        lstrTaskList =[];
        openTicket  = 0;
        closedTicket  = 0;
        droppedTicket  = 0;
        overdueTicket  = 0;

        moduleCount  = [];
        priorityCount  = [];
        issueCount  = [];

        if(g.fnValCheck(value)){
          lstrTaskList = value["TASKS"]??[];
          var taskCount  =[];
          taskCount  =value["TASK_COUNT"]??[];
          if(g.fnValCheck(taskCount)){
            for(var e in taskCount){
              if(e["STATUS"] == "P"){
                openTicket  = e["COUNT"]??0;
              }else  if(e["STATUS"] == "C"){
                closedTicket  = e["COUNT"]??0;
              }else  if(e["STATUS"] == "D"){
                droppedTicket  = e["COUNT"]??0;
              }
            }
          }
          //OverDue
          var overDueCount  =[];
          overDueCount  =value["OVERDUE_COUNT"]??[];
          if(g.fnValCheck(overDueCount)){
            overdueTicket = overDueCount[0]["COUNT"]??0;
          }
          //MOduleCount
          moduleCount = value["MODULE_COUNT"]??[];
          if(g.fnValCheck(moduleCount)){
            moduleCount =  moduleCount..sort((a, b) => b['COUNT'].compareTo(a['COUNT']));
          }
          priorityCount = value["PRIORITY_COUNT"]??[];
          if(g.fnValCheck(priorityCount)){
            priorityCount =  priorityCount..sort((a, b) => b['COUNT'].compareTo(a['COUNT']));
          }
          issueCount = value["ISSUE_COUNT"]??[];
          if(g.fnValCheck(issueCount)){
            issueCount =  issueCount..sort((a, b) => b['COUNT'].compareTo(a['COUNT']));
          }
        }
      });
    }
  }

  apiGetTaskDet(mainClientId,docno,doctype){
    futureForm = apiCall.apiGetTaskDet(mainClientId, docno, doctype);
    futureForm.then((value) => apiGetTaskDetRes(value));
  }
  apiGetTaskDetRes(value){
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
        }
      });
    }
  }

  apiGetTaskMasters(){
    futureForm = apiCall.apiGetTaskMasters();
    futureForm.then((value) => apiGetTaskMastersRes(value));
  }
  apiGetTaskMastersRes(value){
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
          lstrPriorityList = value["PRIORITY"]??[];
          lstrIssueTypeList = value["ISSUE_TYPE"]??[];
        }
      });
    }
  }

  apiGetNotification(){
    var filterVal= [];
    filterVal  = [];
    filterVal.add({ "Column": "USERCD", "Operator": "LIKE", "Value": g.wstrUserCd, "JoinType": "OR" });
    filterVal.add({ "Column": "CLIENT_YN", "Operator": "LIKE", "Value": "N", "JoinType": "OR" });

    futureForm = apiCall.LookupSearch("NOTIFICATION", "MESSAGE|DOCNO|DOCTYPE|READ_YN|", 0, 100, filterVal);
    futureForm.then((value) => apiGetNotificationRes(value));
  }
  apiGetNotificationRes(value){
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
          notificationList = value;
          dprint(notificationList);
        }
      });
    }
  }

  apiUpdateTask(docno, doctype, status, issue, priority){
    futureForm = apiCall.apiUpdateTask(docno, doctype, status, issue, priority);
    futureForm.then((value) =>  apiUpdateTaskRes(value));
  }
  apiUpdateTaskRes(value){
    fnGetPageData();
  }


  //Task Actions

  apiStartTask(docno, doctype){
    futureForm =  apiCall.apiStartTask(docno, doctype);
    futureForm.then((value) => apiStartTaskRes(value));
  }
  apiStartTaskRes(value){
    if(mounted){
      setState(() {

      });
    }
  }

  apiMoveTask(docno, doctype){
    var userList = [];
    userList.add({"COL_VAL":"shihas@beams"});
    futureForm =  apiCall.apiMoveTask(docno, doctype, userList,'',"Check new exe","","");
    futureForm.then((value) => apiMoveTaskRes(value));
  }
  apiMoveTaskRes(value){
    if(mounted){
      setState(() {

      });
    }
  }


}
