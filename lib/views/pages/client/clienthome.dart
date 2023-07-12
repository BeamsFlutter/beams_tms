
import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/controller/services/apiManager.dart';
import 'package:bams_tms/views/components/Attachment/upload_attachment.dart';
import 'package:bams_tms/views/components/PopupLookup/searchpopup.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/components/inputField/form_inputfield.dart';
import 'package:bams_tms/views/components/lookup/lookup.dart';
import 'package:bams_tms/views/pages/login/client_login.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:bams_tms/views/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({Key? key}) : super(key: key);

  @override
  State<ClientHome> createState() => _ClientHomeState();
}
enum Menu { itemOne, itemTwo, itemThree, itemFour }
class _ClientHomeState extends State<ClientHome> {


  //Global Variables
  Global g = Global();
  var apiCall  = ApiCall();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final record = Record();
  late Future<dynamic> futureForm ;


  //Page Variables
  var blSearch = false;
  var blSideScreen  = false;
  var lstrMenuHoverMode = "";
  var lstrToday = DateTime.now();
  var lstrTaskList  = [];
  var lstrTaskListPageNo = 0;
  var lstrTaskListViewMode  = "L";
  var lstrCompanyList = [];
  var lstrModuleList = [];
  var lstrPriorityList = [];
  var lstrStatusList = [];
  var lstrIssueTypeList = [];


  //TaskData
  var lstrTTaskMode = "ADD";
  var lstrTTaskDocno = "";
  var lstrTTaskDoctype = "";
  var lstrTMainCompanyCode= "";
  var lstrTMainCompany= "";
  var lstrTCompany  = "";
  var lstrTCompanyCode  = "";
  var lstrTCompanyId  = "";
  var lstrTModule  = "";
  var lstrTPlatForms  = [];
  var lstrTCreatedBY  = "";
  var lstrTPriority  = "";
  var lstrTPriorityCode  = "";
  var lstrTIssueType  = "";
  var lstrTIssueTypeCode  = "";
  var lstrTStatus  = "";
  var blSaveTask = false;


  var txtTaskHead = TextEditingController();
  var txtTaskDescp = TextEditingController();
  var txtContactPeron = TextEditingController();
  var txtMobile = TextEditingController();
  var txtEmail = TextEditingController();

  //Controller
  var txtController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      endDrawer: Container(
        width:size.width*0.8,
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
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
            Expanded(child: wTaskCard()),

          ],
        ),

      ),
      body: Column(
        children: [
          Expanded(child: Row(
            children: [
              Container(
                width: 260,
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
                    wMenuCard(Icons.task_alt,"Task","T"),
                    wMenuCard(Icons.feed,"Feed","F"),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(

                              onTap: (){
                                if(mounted){
                                  setState(() {
                                    lstrMenuHoverMode = "";
                                  });
                                }
                              },
                              child: Container(
                                decoration: boxBaseDecoration(Colors.white, 10),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: boxGradientDecorationC(24, 10,10,0,0),
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        children: [
                                          tcn('Projects', Colors.white, 12),
                                        ],
                                      )
                                    ),
                                    gapHC(5),
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        children: wCompanyModuleList(),
                                      ),
                                    )
                                  ],
                                ),
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
                        decoration: boxDecoration(Colors.white, 10),
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
                                    child: Image.asset("assets/images/nameblack.png",width: 150,)),
                                Row(
                                  children:  [
                                    Bounce(
                                      duration: const Duration(milliseconds: 110),
                                      onPressed: (){
                                        fnNewTask();
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
                                    InkWell(
                                      onHover: (s){
                                        dprint("*****************************************");
                                      },
                                      child: const Icon(Icons.search,color: Colors.blueGrey,size: 25,)),
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
                                              tcn(g.wstrMainClientId.toString(),Colors.black,10),
                                              tc(g.wstrMainClientName.toString(),Colors.black,12)
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
                            child: Container(
                              decoration: boxDecoration(Colors.white, 5),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(Icons.task_alt,color: color2,size: 30,),
                                  gapWC(10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      tc('00', color2 , 25),
                                      ts('Open Task  ', color3 , 12)
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                          gapWC(5),
                          Flexible(
                            child: Container(
                              decoration: boxDecoration(Colors.white, 5),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(Icons.thumb_up_alt_outlined,color: Colors.green,size: 30,),
                                  gapWC(10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      tc('00', Colors.green , 25),
                                      ts('Closed Task  ', color3 , 12)
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                          gapWC(5),
                          Flexible(
                            child: Container(
                              decoration: boxDecoration(Colors.white, 5),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(Icons.task_alt,color: color2,size: 30,),
                                  gapWC(10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      tc('00', color2 , 25),
                                      ts('Open Task  ', color3 , 12)
                                    ],
                                  )

                                ],
                              ),
                            ),
                          ),
                          gapWC(5),
                          Flexible(
                            child: Container(
                              decoration: boxDecoration(Colors.white, 5),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  const Icon(Icons.task_alt,color: color2,size: 30,),
                                  gapWC(10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      tc('00', color2 , 25),
                                      ts('Open Task  ', color3 , 12)
                                    ],
                                  )

                                ],
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
                                tc('Task Details', Colors.deepOrange, 15),
                                Row(
                                  children: [
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
                                          fnNewTask();
                                          scaffoldKey.currentState?.openEndDrawer();
                                        },
                                        duration: const Duration(milliseconds: 110),
                                        child: const Icon(Icons.add_circle_outlined,color: Colors.deepOrange,size: 20,)),
                                    gapWC(10),
                                    const Icon(Icons.filter_list_alt,color: Colors.deepOrange,size: 20,),
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
                                wRowHead("Task",3),
                                wRowHead("Issue",1),
                                wRowHead("Company",1),
                                wRowHead("Module",1),
                                wRowHead("Status",1),
                                wRowHead("Create Date",1),
                                wRowHead("Priority",1),
                                wRowHead("Created By",1),


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
                        child: tc('CN', Colors.white, 20),
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
                              child: tc('CN', Colors.white, 25),
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
    );
  }

  //======================================WIDGET

    //TaskList
    List<Widget> wTaskList(){
      List<Widget> rtnList  = [];
      for(var e in lstrTaskList){
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
        var priority  = e["PRIORITY_DESCP"]??"";
        var status  = e["STATUS"]??"";
        var taskType  = e["TASK_TYPE"]??"";
        var clientType  = e["CLIENT_TYPE"]??"";
        var issueType  = e["ISSUE_TYPE_DESCP"]??"";
        var taskDate  =  createDate != ""? setDate(6, DateTime.parse(createDate)):"";


        rtnList.add(Bounce(
          duration:const Duration(milliseconds: 110),
          onPressed: (){
            apiGetTaskDet(mainClientId,docno,doctype);
          },
          child: Container(
            decoration: boxBaseDecoration(Colors.white, 0),
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    wRowDet(tcn(docno, color3, 10),1),
                    wRowDet(Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc(taskHead, Colors.black, 12),
                        //tcn(taskDetails, Colors.black, 10),
                      ],
                    ),2),
                    wRowDet(tcn(issueType, color3, 10),1),
                    wRowDet(tcn(clientCompany + " | " +clientCompanyName, color3, 10),1),
                    wRowDet(tcn('JOB', color3, 10),1),
                   
                    wRowDet( status != ""?Container(
                      decoration: boxBaseDecoration(status == "P"? Colors.green:status == "C"? Colors.red:status =="D"? Colors.purple:color2, 30),
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                      child: tcn(status == "P"?"Open":status == "C"?"Closed":status =="D"?"Dropped":"", Colors.white, 10),
                    ):gapHC(0),1),
                    wRowDet(tcn(taskDate, color3, 10),1),
                    wRowDet(Row(
                      children: [
                        const Icon(Icons.local_fire_department_outlined,color: Colors.red,size: 12,),
                        gapWC(5),
                        tcn(priority.toString(), Colors.black, 12),
                      ],
                    ),1),
                    wRowDet(tcn(createUser.toString().toUpperCase(), color3, 10),1),


                  ],
                ),
                gapHC(5),
                lineC(1.0, greyLight)

              ],
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
    Widget wRowHead(title,flex){
     return Flexible(
         flex: flex,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(),
             tc(title, color3, 12),
           ],
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
    Widget wTaskCard(){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        decoration: boxBaseDecoration(greyLight, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                lstrTTaskMode == "ADD"?
                tc('New Task', color3, 30):
                tc(lstrTTaskDocno.toString(), color3, 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person,color: Colors.black,size: 16,),
                        gapWC(5),
                        tcn(g.wstrUserName.toString(), Colors.black  , 15),
                      ],
                    ),
                    gapWC(20),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,color: Colors.black,size: 16,),
                        gapWC(5),
                        tcn(setDate(15, lstrToday).toString(), Colors.black  , 15),
                      ],
                    ),
                    gapWC(20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      decoration: boxOutlineCustom1(greyLight, 5, Colors.grey.withOpacity(0.5) , 0.5),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tcn(g.wstrMainClientId.toString(),Colors.black,10),
                              tc(g.wstrMainClientName.toString(),Colors.black,12)
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
                    ),
                  ],
                )
              ],
            ),
            gapHC(20),
            Expanded(child: Row(
              children: [
                Expanded(child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: boxBaseDecoration(Colors.white, 10),
                  child: Column(
                    children: [
                      Expanded(child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                enabled: lstrTStatus != "P"?false:true,
                                controller: txtTaskHead,
                                style: GoogleFonts.poppins(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.blueGrey),
                                decoration: const InputDecoration(
                                    hintText: 'Task Name',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.work ,color: Colors.blueGrey,)
                                ),
                              ),
                            ),
                            lineC(1.0, Colors.blueGrey.withOpacity(0.2)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                enabled: lstrTStatus != "P"?false:true,
                                controller: txtTaskDescp,
                                minLines: 15,
                                maxLines: 20,
                                style: GoogleFonts.poppins(fontSize: 15 ,fontWeight: FontWeight.normal,color: Colors.black),
                                decoration: const InputDecoration(
                                  hintText: 'Task Details',
                                  border: InputBorder.none,

                                ),
                              ),
                            ),
                            gapHC(10),
                            lineC(1.0, Colors.blueGrey.withOpacity(0.2)),
                            gapHC(10),
                            Row(
                              children: [
                                Flexible(child: PopupMenuButton<Menu>(
                                  enabled: lstrTStatus != "P"?false:true,
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
                                      child: SearchPopup(
                                        searchYn: "Y",
                                        lstrColumnList: [{"COLUMN":"DESCP","CAPTION":"Issue"}],
                                        lstrData: lstrIssueTypeList,
                                        callback: (val){
                                          dprint(val);
                                          if(mounted){
                                            setState(() {
                                              lstrTIssueTypeCode = val["CODE"]??"";
                                              lstrTIssueType = val["DESCP"]??"";
                                            });
                                          }
                                        },),
                                    ),
                                  ],
                                  child:  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: boxBaseDecoration(bGreyLight, 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.segment,color: color2,size: 15,),
                                            gapWC(5),
                                            tcn('Issue Type', Colors.black, 12),
                                          ],
                                        ),
                                        tcn(lstrTIssueType.toString(), Colors.black, 12),

                                      ],
                                    ),
                                  ),
                                ),),
                                gapWC(10),
                                Flexible(child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: boxBaseDecoration(bGreyLight, 5),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.add_task,color: color2,size: 15,),
                                      gapWC(5),
                                      tcn('Select Previous Ticket', Colors.black, 12),
                                    ],
                                  ),
                                ),),
                              ],
                            ),
                            gapHC(5),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: boxBaseDecoration(bGreyLight, 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.attach_file_outlined,color: color2,size: 15,),
                                      gapWC(5),
                                      tcn('Attachment', Colors.black, 12),
                                    ],
                                  ),
                                  Bounce(
                                    onPressed: (){
                                      //fnStartRecord();
                                      PageDialog().show(context, AttachmentUpload(docno: lstrTTaskDocno ,doctype:lstrTTaskDoctype,fnCallBack: (data){},), "Attachment");

                                    },
                                    duration: const Duration(milliseconds: 110),
                                    child: Container(
                                      decoration: boxOutlineCustom1(bGreyLight, 30, color2, 1.0),
                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          tcn('Add', Colors.black, 13),
                                          gapWC(5),
                                          const Icon(Icons.add_photo_alternate_rounded,color: color2,size: 15,),

                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            gapHC(5),
                          ],
                        ),
                      )),
                      gapHC(10),
                      Row(
                        children: [
                          Flexible(
                          flex: 7,
                          child:
                          Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: (){
                              if(!blSaveTask){
                               if(lstrTTaskMode == "ADD"){
                                 apiSaveTask();
                               }else{
                                 apiEditTask();
                               }
                              }

                            },
                            child: Container(
                              decoration: boxDecoration(color2, 5),
                              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                              child: Column(
                                children: [
                                  Row(),
                                  blSaveTask?const SpinKitThreeBounce(color: Colors.white,size: 20,):
                                  lstrTTaskMode == "ADD"?tcn('ADD TASK ', Colors.white, 15):tcn('UPDATE TASK ', Colors.white, 15)
                                ],
                              ),
                            ),
                          )),
                          gapWC(10),
                          Flexible(
                          flex: 3,
                          child:
                          Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: boxOutlineCustom1(bGreyLight, 5 , Colors.black, 1.0),
                              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                              child: Column(
                                children: [
                                  Row(),
                                  tcn('CANCEL', Colors.black, 15)
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                      gapHC(20),

                    ],
                  ),
                )),
                gapWC(10),
                Container(
                  width: 300,
                  decoration: boxBaseDecoration(Colors.white, 10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                        decoration: boxGradientDecorationC(24, 10,10,0,0),
                        child: Row(
                          children: [
                            tcn('Ticket Details', Colors.white , 10)
                          ],
                        ),
                      ),
                       gapHC(5),
                       Expanded(
                         child: Container(
                           padding: const EdgeInsets.all(10),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               tc(g.wstrMainClientName.toString()  , color2, 10),
                               gapHC(5),
                               lineC(1.0, greyLight),
                               wTaskDetRow(Icons.account_balance,'Company',g.wstrFromLink == "Y"? 'N':"",lstrTCompany,"COMPANY"),
                               wTaskDetRow(Icons.monitor,'Project',g.wstrFromLink == "Y"? 'N':"",lstrTModule,"PROJECT"),
                               wTaskDetRow(Icons.mobile_friendly,'Platform',g.wstrFromLink == "Y"? 'N':"",'',"PLATFORM"),
                               wTaskDetRow(Icons.person,'Created By','N',g.wstrUserName.toString(),""),
                               gapHC(20),
                               lstrTTaskMode == "EDIT"?
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
                                     child: SearchPopup(
                                       searchYn: "N",
                                       lstrColumnList: [{"COLUMN":"DESCP","CAPTION":"Status"}],
                                       lstrData: lstrStatusList,
                                       callback: (val){
                                         dprint(val);
                                         if(mounted){
                                           setState(() {
                                             lstrTStatus = val["CODE"];
                                           });
                                         }
                                       },),
                                   ),
                                 ],
                                 child:  Container(
                                   decoration: boxOutlineCustom1(Colors.white, 5, lstrTStatus == "P"? Colors.green:lstrTStatus == "C"? Colors.red:lstrTStatus =="D"? Colors.purple:color2, 1.0),
                                   padding: const EdgeInsets.all(10),
                                   child: Column(
                                     children: [
                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           Row(
                                             children: [
                                               Icon(Icons.adjust_rounded,color: lstrTStatus == "P"? Colors.green:lstrTStatus == "C"? Colors.red:lstrTStatus =="D"? Colors.purple:color2,size: 15,),
                                               gapWC(5),
                                               tcn('STATUS', lstrTStatus == "P"? Colors.green:lstrTStatus == "C"? Colors.red:lstrTStatus =="D"? Colors.purple:color2, 15),
                                             ],
                                           ),
                                           Row(
                                             children: [
                                               tcn(lstrTStatus == "P"?"Open":lstrTStatus == "C"?"Closed":lstrTStatus =="D"?"Dropped":"", lstrTStatus == "P"? Colors.green:lstrTStatus == "C"? Colors.red:lstrTStatus =="D"? Colors.purple:color2, 15),
                                               gapWC(5),
                                               const Icon(Icons.arrow_drop_down_outlined,color: Colors.black,size: 15,),
                                             ],
                                           )
                                         ],
                                       ),
                                     ],
                                   ),
                                 ),
                               ):gapHC(0),
                               gapHC(10),
                               PopupMenuButton<Menu>(
                                   enabled: lstrTStatus != "P"?false:true,
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
                                       child: SearchPopup(
                                         searchYn: "N",
                                         lstrColumnList: [{"COLUMN":"DESCP","CAPTION":"Priority"}],
                                         lstrData: lstrPriorityList,
                                         callback: (val){
                                           dprint(val);
                                           if(mounted){
                                             setState(() {
                                               lstrTPriorityCode = val["CODE"];
                                               lstrTPriority = val["DESCP"];
                                             });
                                           }
                                         },),
                                     ),
                                   ],
                                   child:  Container(
                                     decoration: boxOutlineCustom1(Colors.white, 5, color2, 1.0),
                                     padding: const EdgeInsets.all(10),
                                     child: Column(
                                       children: [
                                         Row(
                                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                           children: [
                                             Row(
                                               children: [
                                                 const Icon(Icons.local_fire_department,color: color2,size: 15,),
                                                 gapWC(5),
                                                 tcn('Priority', color2, 15),
                                               ],
                                             ),
                                             Row(
                                               children: [
                                                 tcn(lstrTPriority.toString(), color2, 15),
                                                 gapWC(5),
                                                 const Icon(Icons.arrow_drop_down_outlined,color: Colors.black,size: 15,),
                                               ],
                                             )
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                               ),


                               gapHC(20),
                               lineC(1.0, greyLight),
                               gapHC(10),
                               Container(
                                 decoration: boxBaseDecoration(bGreyLight, 10),
                                 padding: const EdgeInsets.all(10),
                                 child: Column(
                                   children: [
                                     Row(
                                       children: [
                                         const Icon(Icons.contact_mail,color: color2,size: 15,),
                                         gapWC(10),
                                         tcn('Contact Details', Colors.black  , 14)
                                       ],
                                     ),
                                     lineC(1.0, greyLight),
                                     gapHC(10),
                                     FormInput(
                                       hintText: "Contact Person",
                                       txtController: txtContactPeron,
                                       enablests:true,
                                       emptySts:true,
                                       onChanged: (value){
                                         setState((){
                                         });
                                       },
                                       onSubmit: (value){
                                       },
                                       validate: true,
                                     ),
                                     gapHC(5),
                                     FormInput(
                                       hintText: "Mobile",
                                       txtController: txtMobile,
                                       enablests:true,
                                       emptySts:true,
                                       textType: TextInputType.number,
                                       onChanged: (value){
                                         setState((){
                                         });
                                       },
                                       onSubmit: (value){
                                       },
                                       validate: true,
                                     ),
                                     gapHC(5),
                                     FormInput(
                                       hintText: "Email",
                                       txtController: txtEmail,
                                       enablests:true,
                                       emptySts:true,
                                       onChanged: (value){
                                         setState((){
                                         });
                                       },
                                       onSubmit: (value){
                                       },
                                       validate: true,
                                     )

                                   ],
                                 ),
                               )
                               

                             ],
                           ),
                         )
                       ),

                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      );
    }
    Widget wTaskDetRow(icon,head,hideMode,value,mode){

      return hideMode == "N"?
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapHC(15),
          Row(
            children: [
              Flexible(child: Row(
                children: [
                  Icon(icon,color: color2,size: 12,),
                  gapWC(5),
                  tcn(head.toString(), Colors.blueGrey, 12),
                  gapWC(10),
                ],
              )),
              Flexible(
                child: tc(value.toString(), Colors.black, 10),
              ),
            ],
          ),
          gapHC(15),
          lineC(1.0, greyLight),
        ],
      ):
      PopupMenuButton<Menu>(
          enabled: lstrTStatus != "P"?false:true,
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
            child: wSearchPopupChoice(mode)
          ),
        ],
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapHC(15),
            Row(
              children: [
                Flexible(child: Row(
                  children: [
                    Icon(icon,color: color2,size: 12,),
                    gapWC(5),
                    tcn(head.toString(), Colors.blueGrey, 12),
                    gapWC(10),
                  ],
                )),
                Flexible(
                  child: tc(value.toString(), Colors.black, 12),
                ),
              ],
            ),
            gapHC(15),
            lineC(1.0, greyLight),
          ],
        ));

    }
    Widget wSearchPopup(){
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: boxBaseDecoration(Colors.white, 0),
        child: Column(
          children: [
            Container(
              height: 30,
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: boxOutlineCustom1(Colors.white, 5, Colors.grey, 0.5),
              child: TextFormField(
                autofocus: true,
                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                keyboardType: TextInputType.visiblePassword,
                decoration:   InputDecoration(
                    hintText: 'Search',
                    hintStyle: GoogleFonts.poppins(fontSize: 12),
                    border: InputBorder.none,
                    suffixIcon: const Icon(Icons.search,color: Colors.blueGrey,size: 15,),
                ),
              ),
            ),
            Column(
              children: [
                Row(),
                gapHC(5),
                Container(
                  decoration: boxBaseDecoration(bGreyLight, 5),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      tcn('01 | ALFANAR', Colors.black , 10)
                    ],
                  ),
                ),
                gapHC(5),
                Container(
                  decoration: boxBaseDecoration(bGreyLight, 5),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      tcn('01 | ALFANAR', Colors.black , 10)
                    ],
                  ),
                ),
                gapHC(5),
                Container(
                  decoration: boxBaseDecoration(bGreyLight, 5),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      tcn('01 | ALFANAR', Colors.black , 10)
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }
    Widget wPriorityPopUp(){
      return Container(
      padding: const EdgeInsets.all(10),
      decoration: boxBaseDecoration(Colors.white, 0),
      child: Column(
        children: [
          Column(
            children: [
              Row(),
              gapHC(5),
              Container(
                decoration: boxBaseDecoration(bGreyLight, 5),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(),
                    tcn('Emergency', Colors.black , 10)
                  ],
                ),
              ),
              gapHC(5),
              Container(
                decoration: boxBaseDecoration(bGreyLight, 5),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(),
                    tcn('Critical', Colors.black , 10)
                  ],
                ),
              ),
              gapHC(5),
              Container(
                decoration: boxBaseDecoration(bGreyLight, 5),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(),
                    tcn('Normal', Colors.black , 10)
                  ],
                ),
              ),
              gapHC(5),
              Container(
                decoration: boxBaseDecoration(bGreyLight, 5),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(),
                    tcn('Low', Colors.black , 10)
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
    }
    List<Widget> wCompanyModuleList(){
      List<Widget> rtnList = [];
      for(var e in lstrCompanyList){

        var clientID = e["CLIENT_ID"]??"";
        var code = e["COMPANY_CODE"]??"";
        var name = e["NAME"]??"";
        rtnList.add(Container(
          decoration: boxBaseDecoration(bGreyLight, 5),
          padding:const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              const Icon(Icons.account_balance,color: color2,size: 12,),
              gapWC(10),
              Expanded(child: tcn(code + " | "+name, Colors.black, 10))
            ],
          ),
        ),);
        var selectedData = g.mfnJson(lstrModuleList);
        selectedData.retainWhere((i){
          return i["CLIENT_ID"] == clientID ;
        });
        for(var f in selectedData){
          var module = f["MODULE"]??"";
          rtnList.add(Row(
            children: [
              gapWC(20),
              const Icon(Icons.album_rounded,color: greyLight,size: 12,),
              gapWC(10),
              Expanded(child: tcn(module, Colors.black, 10))
            ],
          ));
          rtnList.add(gapHC(5));
          rtnList.add(lineC(1.0, greyLight));
          rtnList.add(gapHC(5));
        }
        rtnList.add(gapHC(10));

      }

      return rtnList;
    }
    Widget wMenuCard(icon,text,mode){
     return Bounce(
       duration: const Duration(milliseconds: 110),
       onPressed: (){
          if(mounted){
            setState(() {
              lstrMenuHoverMode = mode;
            });
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
    Widget wSearchPopupChoice(mode){
    Widget rtnWidget  =  Container();
    if(mode  == "COMPANY"){
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY_CODE', 'Display': 'Code'},
        {'Column': 'NAME', 'Display': 'Company'},
        {'Column': 'CLIENT_ID', 'Display': 'ID'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
      ];
      var lstrFilter =[
        {'Column': "MAIN_CLIENT_ID", 'Operator': '=', 'Value': lstrTMainCompanyCode, 'JoinType': 'AND'},
      ];

      rtnWidget = Lookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'CLIENT_DETAIL',
        title: 'Company',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'COMPANY_CODE',
        mode: "S",
        layoutName: "B",
        callback: (data){
          if(mounted){
            setState(() {
              if(g.fnValCheck(data)){
                lstrTCompany = data["NAME"];
                lstrTCompanyCode = data["COMPANY_CODE"];
                lstrTCompanyId = data["CLIENT_ID"];
                lstrTModule = "";
              }
            });
          }
        },
        searchYn: 'Y',
      );
    }
    else  if(mode  == "PROJECT"){
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'MODULE', 'Display': 'Module'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
      ];
      var lstrFilter =[
        {'Column': "MAIN_CLIENT_ID", 'Operator': '=', 'Value': lstrTMainCompanyCode, 'JoinType': 'AND'},
        {'Column': "CLIENT_ID", 'Operator': '=', 'Value': lstrTCompanyId, 'JoinType': 'AND'},
      ];

      rtnWidget = Lookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'CLIENT_MODULE',
        title: 'Module',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'MODULE',
        mode: "S",
        layoutName: "B",
        callback: (data){
          if(mounted){
            setState(() {
              if(g.fnValCheck(data)){
                lstrTModule = data["MODULE"];
              }
            });
          }
        },
        searchYn: 'Y',
      );
    }
    else  if(mode  == "MAIN_CLIENT"){
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'MAIN_CLIENT_ID', 'Display': '#'},
        {'Column': 'MAIN_COMPANY_NAME', 'Display': 'Company'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'MAIN_CLIENT_ID',
          'contextField': txtController,
          'context': 'window'
        },
      ];
      rtnWidget = Lookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'MAIN_CLIENT',
        title: 'Main Company',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'MAIN_CLIENT_ID',
        mode: "S",
        layoutName: "B",
        callback: (data){
          if(mounted){
            setState(() {
              if(g.fnValCheck(data)){
                lstrTMainCompany = data["MAIN_COMPANY_NAME"];
                lstrTMainCompanyCode = data["MAIN_CLIENT_ID"];

                lstrTCompany = "";
                lstrTCompanyCode = "";
                lstrTCompanyId = "";
                lstrTModule = "";

              }
            });
          }
        },
        searchYn: 'Y',
      );
    }
    return rtnWidget;
  }

  //======================================PAGE FN

  fnGetPageData(){
    if(mounted){
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
      });
    }
    apiCompanyDetails();

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
                    builder: (context) =>  const ClientLogin()
                ));
              } ,
              child: tc('YES', Colors.white, 12),
            ) ,
          ),
        ],
      ),
    );



  }

  //TASK
  fnNewTask(){
    apiGetTaskMasters();
  }
  fnNewTaskFillData(){
    fnClear();
    if(mounted){
      //Company List
      //Module List
      //Priority
      //Platform
      //IssueType

      setState(() {


        if(g.wstrFromLink == "Y")
        {
          lstrTCompany = g.wstrLCompanyName;
          lstrTCompanyCode = g.wstrLCompanyCode;
          lstrTCompanyId = g.wstrLCompanyID;
          lstrTModule = g.wstrLModule;
        }
        else{
          if(lstrCompanyList.isNotEmpty ){
            var e = lstrCompanyList[0]??[];
            var clientID = e["CLIENT_ID"]??"";
            var code = e["COMPANY_CODE"]??"";
            var name = e["NAME"]??"";
            lstrTCompany = name;
            lstrTCompanyCode = code;
            lstrTCompanyId = clientID;
          }
          if(lstrModuleList.isNotEmpty){
            var e = lstrModuleList[0]??[];
            lstrTModule = e["MODULE"]??"";
          }
        }
        lstrTMainCompanyCode = g.wstrMainClientId;
        lstrTMainCompany = g.wstrMainClientName;
        txtContactPeron.text = g.wstrUserName.toString();
        lstrTTaskMode = "ADD";
        lstrTStatus = "P";


      });

    }
  }
  fnEditTaskFillData(data){
    fnClear();
    if(mounted){
      setState(() {


        txtTaskHead.text = data["TASK_HEADER"].toString();
        txtTaskDescp.text = data["TASK_DETAIL"].toString();
        txtContactPeron.text = data["CONTACT_PERSON"].toString();
        txtMobile.text = data["CONTACT_MOB"].toString();
        txtEmail.text = data["CONTACT_EMAIL"].toString();

        lstrTTaskMode = "EDIT";
        lstrTTaskDocno = data["DOCNO"].toString();
        lstrTTaskDoctype = data["DOCTYPE"].toString();

        lstrTMainCompany = data["MAIN_COMPANY_NAME"].toString();
        lstrTMainCompanyCode = data["MAIN_CLIENT_ID"].toString();
        lstrTCompany = data["COMPANY_NAME"].toString();
        lstrTCompanyCode = data["CLIENT_COMPANY"].toString();
        lstrTCompanyId = data["CLIENT_ID"].toString();
        lstrTCreatedBY = data["CREATE_USER"].toString();
        lstrTPriorityCode = data["PRIORITY"].toString();
        lstrTPriority = data["PRIORITY_DESCP"].toString();
        lstrTIssueType = data["ISSUE_TYPE_DESCP"].toString();
        lstrTIssueTypeCode =data["ISSUE_TYPE"].toString();
        lstrTStatus =data["STATUS"].toString();

        lstrTModule = "JOB";


      });
    }
    scaffoldKey.currentState?.openEndDrawer();
  }
  fnClear(){
    if(mounted){
      setState(() {
        txtTaskHead.clear();
        txtTaskDescp.clear();
        txtContactPeron.clear();
        txtMobile.clear();
        txtEmail.clear();
        lstrTCompany  = "";
        lstrTCompanyCode  = "";
        lstrTCompanyId  = "";
        lstrTModule  = "";
        lstrTPlatForms  = [];
        lstrTCreatedBY  = "";
        lstrTPriority  = "";
        lstrTPriorityCode  = "";
        lstrTIssueType  = "";
        lstrTIssueTypeCode  = "";
        lstrTMainCompanyCode= "";
        lstrTMainCompany= "";
        lstrTTaskDocno = "";
        lstrTTaskDoctype = "";
        blSaveTask = false;
        lstrTStatus = "";
      });
    }
  }

  fnSaveTask(){




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
    var sortCol = "",sortDir = "",search = "";
    var client = [],task= [],issue= [],clientType= [],status= [],userList= [],priorityList= [],moduleList =[];

    futureForm = apiCall.apiGetTask(null,null,null,null,g.wstrMainClientId,"",lstrTaskListPageNo,sortCol,sortDir,search,client,task,issue,clientType,status,userList,priorityList,"N",moduleList,"",[],[],[]);
    futureForm.then((value) => apiGetTaskRes(value));
  }
  apiGetTaskRes(value){
    if(mounted){
      setState(() {
        lstrTaskList =[];
        if(g.fnValCheck(value)){
          lstrTaskList = value["TASKS"];
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
          fnEditTaskFillData(value);
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
      fnNewTaskFillData();
    }
  }

  apiSaveTask(){

    var TASK = [
      {
        //"COMPANY": "",
        // "DOCNO": "",
        // "DOCTYPE": "",
        // "DOCDATE": "",
        "MAIN_CLIENT_ID": g.wstrMainClientId,
        "CLIENT_ID": lstrTCompanyId,
        "CLIENT_COMPANY": lstrTCompanyCode,
        "CONTACT_PERSON": txtContactPeron.text.toString(),
        "CONTACT_MOB": txtMobile.text.toString(),
        "CONTACT_EMAIL": txtEmail.text.toString(),
        "TASK_HEADER": txtTaskHead.text.toString(),
        "TASK_DETAIL": txtTaskDescp.text.toString(),
        "DEADLINE": null,
        //"START_TIME": "",
        // "END_TIME": "",
        //"DURATION": "",
        //"DURATION_TYPE": "",
        //"CREATE_USER": "",
        //"CREATE_DATE": "",
        "PRV_DOCNO": "",
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
    var TASK_CHECKLIST =[
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
    if(mounted){
      setState(() {
        blSaveTask = true;
      });
    }
    futureForm = apiCall.apiSaveTask(TASK, TASK_CHECKLIST, TASK_PLATFORM, MODE,[]);
    futureForm.then((value) => apiSaveTaskRes(value));
  }
  apiSaveTaskRes(value){
    if(mounted){
      setState(() {
        blSaveTask = false;
      });

      if(g.fnValCheck(value)){
        var sts =  value[0]["STATUS"].toString();
        var msg =  value[0]["MSG"].toString();
        if(sts  == "1"){
          //Success
          var code =  value[0]["CODE"].toString();
          Navigator.pop(context);
          //successMsg(context, "$code \n New Task Added !!!");
          PageDialog().showTaskDone(context,code,"HEAD");
          apiGetTask();

        }else{
          //Failed
          errorMsg(context, "Sorry, Try Again !!!");

        }
      }

    }
   // [{STATUS: 1, MSG: SAVED, CODE: 0000000007, DOCTYPE: TASK}]
  }

  apiEditTask(){

    var TASK = [
      {
        "COMPANY": g.wstrCompany,
        "DOCNO": lstrTTaskDocno,
        "DOCTYPE": lstrTTaskDoctype,
        //"DOCDATE": "",
        "MAIN_CLIENT_ID": g.wstrMainClientId,
        "CLIENT_ID": lstrTCompanyId,
        "CLIENT_COMPANY": lstrTCompanyCode,
        "CONTACT_PERSON": txtContactPeron.text.toString(),
        "CONTACT_MOB": txtMobile.text.toString(),
        "CONTACT_EMAIL": txtEmail.text.toString(),
        "TASK_HEADER": txtTaskHead.text.toString(),
        "TASK_DETAIL": txtTaskDescp.text.toString(),
        "DEADLINE": null,
        //"START_TIME": "",
        //"END_TIME": "",
        //"DURATION": "",
        //"DURATION_TYPE": "",
        //"CREATE_USER": "",
        //"CREATE_DATE": "",
        "PRV_DOCNO": "",
        "MAIN_DOCNO": "",
        "MODULE": lstrTModule,
        "TASK_TYPE": "",
        "ISSUE_TYPE": lstrTIssueTypeCode,
        "CLIENT_TYPE": "",
        "PRIORITY": lstrTPriorityCode,
        "STATUS": lstrTStatus,
        "COMPLETED_USER": "",
        "COMPLETION_NOTE": "",
        "REMASRKS": ""
      }
    ];
    var TASK_CHECKLIST =[
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
    if(mounted){
      setState(() {
        blSaveTask = true;
      });
    }
    futureForm = apiCall.apiSaveTask(TASK, TASK_CHECKLIST, TASK_PLATFORM, MODE,[]);
    futureForm.then((value) => apiEditTaskRes(value));
  }
  apiEditTaskRes(value){
    if(mounted){
      setState(() {
        blSaveTask = false;
      });

      if(g.fnValCheck(value)){
        var sts =  value[0]["STATUS"].toString();
        var msg =  value[0]["MSG"].toString();
        if(sts  == "1"){
          //Success
          var code =  value[0]["CODE"].toString();
          Navigator.pop(context);
          //successMsg(context, "$code \n New Task Added !!!");
          PageDialog().showTaskUpdated(context,code,"HEAD");
          apiGetTask();

        }else{
          //Failed
          errorMsg(context, "Sorry, Try Again !!!");

        }
      }

    }
    // [{STATUS: 1, MSG: SAVED, CODE: 0000000007, DOCTYPE: TASK}]
  }

}
