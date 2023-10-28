
import 'dart:convert';
import 'dart:io';

import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/controller/services/apiManager.dart';
import 'package:bams_tms/views/components/PopupLookup/searchpopup.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/components/inputField/form_inputfield.dart';
import 'package:bams_tms/views/components/lookup/lookup.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewTask extends StatefulWidget {
  final String pageMode;
  final String wMainClienId;
  final String wDoco;
  final String wDoctype;
  final String wSubOfDocno;
  final Function fnGetTask;
  final Function fnSubTaskCall;
  const NewTask({Key? key, required this.pageMode, required this.wMainClienId, required this.wDoco, required this.wDoctype, required this.fnGetTask, required this.wSubOfDocno, required this.fnSubTaskCall}) : super(key: key);

  @override
  State<NewTask> createState() => _NewTaskState();
}
enum Menu { itemOne, itemTwo, itemThree, itemFour }
class _NewTaskState extends State<NewTask> {

  //Global Variables
  Global g = Global();
  var apiCall  = ApiCall();
  late Future<dynamic> futureForm ;
  var wstrPageForm  = [];
  //QuillController _controller = QuillController.basic();

  //TaskData
  var lstrCompanyList = [];
  var lstrModuleList = [];
  var lstrPriorityList = [];
  var lstrStatusList = [];
  var lstrIssueTypeList = [];
  var lstrResponsibleUsers = [];
  var listSubTask = [];
  var listSubTaskDetData = [];

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
  var lstrDocument  = [];
  var lstrTCreatedBY  = "";
  var lstrTPriority  = "";
  var lstrTPriorityCode  = "";
  var lstrTIssueType  = "";
  var lstrTIssueTypeCode  = "";
  var lstrTStatus  = "";
  var lstrTLastStatus  = "";
  var blSaveTask = false;
  var lstrDeadlineDate  = DateTime.now();
  var lstrTPrvDocno  = "";
  var lstrTPrvDescp  = "";

  var lstrTSubDocno  = "";
  var lstrTSubDescp  = "";

  var lstrViewDocno  = "";
  var lstrBDeadLine = false;
  var completionUser = "";
  var closedDate = DateTime.now();
  var taskOptions = "A";
  var lstrTaskComments = [];
  var lstrTaskTimeLine = [];
  var lstrToday = DateTime.now();


  var txtTaskHead = TextEditingController();
  var txtTaskDescp = TextEditingController();
  var txtTaskCompletionNote = TextEditingController();
  var txtContactPeron = TextEditingController();
  var txtMobile = TextEditingController();
  var txtEmail = TextEditingController();
  var txtController = TextEditingController();
  var txtComment = TextEditingController();
  var createtask = TextEditingController();




  //File Upload
  List<File> lstrFiles  =[];
  var lstrRemoveAttachment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPgaeData();
  }


  @override
  Widget build(BuildContext context) {
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
                              enabled: lstrTStatus.contains(RegExp(r'[C,D]'))?false:true,
                              controller: txtTaskDescp,
                              minLines: 7,
                              maxLines: 20,
                              style: GoogleFonts.poppins(fontSize: 15 ,fontWeight: FontWeight.normal,color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Task Details',
                                border: InputBorder.none,

                              ),
                            ),
                          ),
                          gapHC(10),
                          // Container(
                          //     padding: EdgeInsets.all(5),
                          //     decoration: boxDecoration(Colors.white, 10),
                          //     child : Column(
                          //       children: [
                          //         QuillToolbar.basic(controller: _controller),
                          //         ConstrainedBox(
                          //           constraints:  const BoxConstraints(
                          //             minHeight: 100.0,
                          //             maxHeight: 250.0,
                          //           ),
                          //             child: QuillEditor.basic(
                          //               controller: _controller,
                          //               readOnly: false, // true for view only mode
                          //             ),
                          //         )
                          //
                          //       ],
                          //     ),
                          // ),
                          gapHC(10),
                          lineC(1.0, Colors.blueGrey.withOpacity(0.2)),
                          gapHC(10),
                          lstrTStatus.contains(RegExp(r'[C,D]'))?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tcn('Completion Note', Colors.black, 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextFormField(
                                  enabled: lstrTStatus == "P"?false:true,
                                  controller: txtTaskCompletionNote,
                                  minLines: 2,
                                  maxLines: 5,
                                  style: GoogleFonts.poppins(fontSize: 15 ,fontWeight: FontWeight.normal,color: Colors.black),
                                  decoration: const InputDecoration(
                                    hintText: 'Completion Note',
                                    border: InputBorder.none,

                                  ),
                                ),
                              ),
                              gapHC(10),
                              lineC(1.0, Colors.blueGrey.withOpacity(0.2)),
                              gapHC(10),
                            ],
                          ):
                          gapHC(0),
                          lstrTTaskMode == "EDIT" && listSubTask.isNotEmpty?
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: boxBaseDecoration(bGreyLight, 5),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.pending_actions_outlined,color: color2,size: 15,),
                                    gapWC(5),
                                    tcn('Sub Task Details', Colors.black, 12),
                                  ],
                                ),
                                gapHC(10),
                                Column(
                                  children: wSubTask(),
                                )
                              ],
                            ),
                          ):gapHC(0),
                          gapHC(5),
                          Row(
                            children: [
                              Flexible(child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: boxBaseDecoration(bGreyLight, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    PopupMenuButton<Menu>(
                                      enabled: lstrTStatus.contains(RegExp(r'[C,D]'))?false:true,
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
                                          child: wSearchPopupChoice("SUB"),
                                        ),
                                      ],
                                      child:  Row(
                                        children: [
                                          const Icon(Icons.add_task,color: color2,size: 15,),
                                          gapWC(5),
                                          tcn('Sub task of', Colors.black, 12),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
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
                                              child: wSubTaskView(),
                                            ),
                                          ],
                                          child:  tc(lstrTSubDocno.toString(), Colors.black, 12),
                                        ),

                                        gapWC(5),
                                        lstrTSubDocno.isNotEmpty && lstrTStatus == "P"?
                                        GestureDetector(
                                            onTap: (){
                                              if(mounted){
                                                setState(() {
                                                  lstrTSubDocno = "";
                                                  lstrTSubDescp = "";
                                                  listSubTaskDetData = [];
                                                });
                                              }
                                            },
                                            child: const Icon(Icons.clear,color: Colors.black,size: 15,)
                                        ):gapHC(0)
                                      ],
                                    ),

                                  ],
                                ),
                              ),),
                              gapWC(5),
                              Flexible(child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: boxBaseDecoration(bGreyLight, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    PopupMenuButton<Menu>(
                                      enabled: lstrTStatus.contains(RegExp(r'[C,D]'))?false:true,
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
                                          child: wSearchPopupChoice("TASK"),
                                        ),
                                      ],
                                      child:  Row(
                                        children: [
                                          const Icon(Icons.note_alt_outlined,color: color2,size: 15,),
                                          gapWC(5),
                                          tcn('Dependent Task', Colors.black, 12),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        tc(lstrTPrvDocno.toString(), Colors.black, 12),
                                        gapWC(5),
                                        lstrTPrvDocno.isNotEmpty?
                                        GestureDetector(
                                            onTap: (){
                                              if(mounted){
                                                setState(() {
                                                  lstrTPrvDocno = "";
                                                  lstrTPrvDescp = "";
                                                });
                                              }
                                            },
                                            child: const Icon(Icons.clear,color: Colors.black,size: 15,)
                                        ):gapHC(0)
                                      ],
                                    ),


                                  ],
                                ),
                              ),),
                            ],
                          ),


                          gapHC(5),
                          lstrTTaskMode == "ADD"?
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: boxBaseDecoration(bGreyLight, 5),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    PopupMenuButton<Menu>(
                                      enabled: lstrTStatus.contains(RegExp(r'[C,D]'))?false:true,
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
                                          child: wSearchPopupChoice("USERS"),
                                        ),
                                      ],
                                      child:  Row(
                                        children: [
                                          const Icon(Icons.group,color: color2,size: 15,),
                                          gapWC(5),
                                          tcn('Responsible Persons', Colors.black, 12),
                                        ],
                                      ),
                                    ),
                                    gapHC(0)


                                  ],
                                ),
                                gapHC(5),
                                Row(
                                  children: wUsersList(),
                                )
                              ],
                            ),
                          ):gapHC(0),
                          gapHC(5),

                          lstrTTaskMode == "EDIT"?
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: boxBaseDecoration(bGreyLight, 5),
                            child: Row(
                              children: [
                                wTaskOptionCard(Icons.attachment,"Attachment","A"),
                                gapWC(5),
                                wTaskOptionCard(Icons.mark_unread_chat_alt_sharp,"Comments","C"),
                                gapWC(5),
                                wTaskOptionCard(Icons.access_time_rounded,"Timeline","T"),
                              ],
                            ),
                          ):
                          gapHC(0),
                          gapHC(5),
                          taskOptions == "A"?
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: boxBaseDecoration(bGreyLight, 5),
                            child: Column(
                              children: [
                                Row(
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
                                        //PageDialog().show(context, AttachmentUpload(docno: lstrTTaskDocno ,doctype:lstrTTaskDoctype,fnCallBack: (data){},), "Attachment");
                                        fnAddFiles();
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
                                gapHC(10),
                                lstrTTaskMode == "ADD"?
                                Column(
                                  children:  viewAttachments(),
                                ):
                                Wrap(
                                  children: lstrDocument.isNotEmpty?
                                  viewAttachmentsEdit():
                                  [
                                    Center(child : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.image,color: greyLight,size: 30,),
                                        gapHC(10),
                                        tcn('NO ATTACHMENTS', greyLight, 12)
                                      ],
                                    ))
                                  ],
                                )
                              ],
                            ),
                          ):
                          taskOptions != "A" && lstrTTaskMode == "EDIT" ?
                          taskOptions == "C"?
                          Container(
                            decoration: boxBaseDecoration(bGreyLight, 10),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                lstrTaskComments.isNotEmpty?
                                Column(
                                  children: wTaskComments(),
                                ):Center(child : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    gapHC(20),
                                    const Icon(Icons.comment,color: greyLight,size: 30,),
                                    gapHC(10),
                                    tcn('NO COMMENTS', greyLight, 12),
                                    gapHC(30),
                                  ],
                                )),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.account_circle,color: color2,size: 30,),
                                    gapWC(5),
                                    Flexible(
                                      child: Container(
                                        decoration: boxOutlineCustom1(Colors.white, 10, Colors.blueGrey, 0.5),
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: TextFormField(
                                          controller: txtComment,
                                          minLines: 1,
                                          maxLines: 5,
                                          style: GoogleFonts.poppins(fontSize: 12,color: Colors.black),
                                          decoration: const InputDecoration(
                                              hintText: 'Add Comment...',
                                              border: InputBorder.none,
                                              prefixIcon: Icon(Icons.comment ,color: Colors.blueGrey,size: 13,)
                                          ),
                                          onChanged: (v){
                                            if(mounted){
                                              setState(() {

                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                gapHC(10),
                                txtComment.text.isNotEmpty?
                                Row(
                                  children: [
                                    gapWC(35),
                                    Bounce(
                                      onPressed: (){
                                        apiAddComment(lstrTTaskDocno, lstrTTaskDoctype, txtComment.text);
                                      },
                                      duration: const Duration(milliseconds: 110),
                                      child: Container(
                                        width:150,
                                        decoration: boxBaseDecoration(color2, 5),
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                            tcn('SEND', Colors.white, 13)
                                          ],
                                        ),
                                      ),
                                    ),
                                    gapWC(15),
                                    GestureDetector(
                                      onTap: (){
                                        if(mounted){
                                          setState(() {
                                            txtComment.clear();
                                          });
                                        }
                                      },
                                      child: tcn('CANCEL', Colors.black, 12),
                                    )
                                  ],
                                ):gapHC(0)
                              ],
                            ),
                          ):
                          Container(
                            child: Column(
                              children: wTaskTimeLineList(),
                            ),
                          ):
                          gapHC(0)
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
                                    apiSaveTask("");
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
                        gapWC(5),
                        lstrTTaskMode == "ADD"?
                        Flexible(
                            flex: 7,
                            child:
                            Bounce(
                              duration: const Duration(milliseconds: 110),
                              onPressed: (){
                                if(!blSaveTask){
                                  if(lstrTTaskMode == "ADD"){
                                    apiSaveTask("NEW");
                                  }
                                }

                              },
                              child: Container(
                                decoration: boxOutlineCustom1(Colors.white, 5, color2, 1.0),
                                padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                                child: Column(
                                  children: [
                                    Row(),
                                    blSaveTask?const SpinKitThreeBounce(color: color2,size: 20,):
                                    tcn('ADD TASK & NEW ', color2, 15)
                                  ],
                                ),
                              ),
                            )):gapHC(0),
                        gapWC(10),
                        // lstrTTaskMode == "EDIT"?
                        // Flexible(
                        //     flex: 2,
                        //     child:
                        //     Bounce(
                        //       duration: const Duration(milliseconds: 110),
                        //       onPressed: (){
                        //         PageDialog().deleteDialog(context, apiDeleteTask);
                        //       },
                        //       child: Container(
                        //         decoration: boxOutlineCustom1(bGreyLight, 5 , Colors.red, 1.0),
                        //         padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 10),
                        //         child: Column(
                        //           children: [
                        //             Row(),
                        //             tcn('REMOVE', Colors.red, 15)
                        //           ],
                        //         ),
                        //       ),
                        //     )):gapHC(0),

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
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                gapHC(5),
                                lineC(1.0, greyLight),
                                wTaskDetRow(Icons.account_balance,'Main Client','',lstrTMainCompany,"MAIN_CLIENT"),
                                wTaskDetRow(Icons.account_balance,'Company',"",lstrTCompany,"COMPANY"),
                                wTaskDetRow(Icons.monitor,'Project',"",lstrTModule,"PROJECT"),
                                wTaskDetRow(Icons.mobile_friendly,'Platform',"",'',"PLATFORM"),
                                wTaskDetRow(Icons.person,'Created By','N',lstrTCreatedBY.toString(),""),
                                gapHC(20),
                                PopupMenuButton<Menu>(
                                  enabled: lstrTStatus.contains(RegExp(r'[C,D]'))?false:true,
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
                                        lstrColumnList: const [{"COLUMN":"DESCP","CAPTION":"Issue"}],
                                        lstrData: lstrIssueTypeList,
                                        callback: (val){
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
                                            tcn('Issue Type',  color2, 12),
                                          ],
                                        ),
                                        tcn(lstrTIssueType.toString(), color2, 12),
                                      ],
                                    ),
                                  ),
                                ),
                                gapHC(5),
                                lstrTTaskMode == "EDIT"?
                                PopupMenuButton<Menu>(
                                  enabled: false,
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
                                      enabled: false,
                                      value: Menu.itemOne,
                                      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                                      child: SearchPopup(
                                        searchYn: "N",
                                        lstrColumnList: [{"COLUMN":"DESCP","CAPTION":"Status"}],
                                        lstrData: lstrStatusList,
                                        callback: (val){
                                          if(mounted){
                                            setState(() {
                                              lstrTStatus = val["CODE"];
                                            });
                                          }
                                        },),
                                    ),
                                  ],
                                  child:  Container(
                                    decoration: boxBaseDecoration(bGreyLight, 5),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.adjust_rounded,color: lstrTStatus == "P"? Colors.green:lstrTStatus == "C"? Colors.red:lstrTStatus =="D"? Colors.purple:lstrTStatus =="A"? color2:lstrTStatus =="H"? Colors.deepOrange:color2,size: 15,),
                                                gapWC(5),
                                                tcn('STATUS', lstrTStatus == "P"? Colors.green:lstrTStatus == "C"? Colors.red:lstrTStatus =="D"? Colors.purple:color2, 12),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                tcn(lstrTStatus == "P"?"Open":lstrTStatus == "C"?"Closed":lstrTStatus =="D"?"Dropped":lstrTStatus =="A"?"Started":lstrTStatus =="H"?"Hold":"", lstrTStatus == "P"? Colors.green:lstrTStatus == "C"? Colors.red:lstrTStatus =="D"? Colors.purple:color2, 12),
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
                                lstrTTaskMode == "EDIT"?gapHC(5):gapHC(0),
                                PopupMenuButton<Menu>(
                                  enabled: lstrTStatus.contains(RegExp(r'[C,D]'))?false:true,
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
                                      enabled: lstrTStatus.contains(RegExp(r'[C,D]'))?false:true,
                                      value: Menu.itemOne,
                                      padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                                      child: SearchPopup(
                                        searchYn: "N",
                                        lstrColumnList: const [{"COLUMN":"DESCP","CAPTION":"Priority"}],
                                        lstrData: lstrPriorityList,
                                        callback: (val){
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
                                    decoration: boxBaseDecoration(bGreyLight, 5),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.local_fire_department,color:
                                                lstrTPriority == "EMERGENCY"?Colors.deepOrange:lstrTPriority == "CRITICAL"?Colors.red:lstrTPriority == "NORMAL"?Colors.blue:lstrTPriority == "MEDIUM"?Colors.amber:Colors.black

                                                  ,size: 15,),
                                                gapWC(5),
                                                tcn('Priority', lstrTPriority == "EMERGENCY"?Colors.deepOrange:lstrTPriority == "CRITICAL"?Colors.red:lstrTPriority == "NORMAL"?Colors.blue:lstrTPriority == "MEDIUM"?Colors.amber:Colors.black, 12),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                tcn(lstrTPriority.toString(), lstrTPriority == "EMERGENCY"?Colors.deepOrange:lstrTPriority == "CRITICAL"?Colors.red:lstrTPriority == "NORMAL"?Colors.blue:lstrTPriority == "MEDIUM"?Colors.amber:Colors.black, 12),
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
                                gapHC(5),
                                Bounce(
                                  duration:const Duration(milliseconds: 110),
                                  onPressed: (){
                                    _selectFromDate(context);
                                  },
                                  child: Container(
                                    decoration: boxBaseDecoration(bGreyLight, 5),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.calendar_month,color: color2,size: 15,),
                                                gapWC(5),
                                                tcn('Deadline', color2, 12),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                lstrBDeadLine?
                                                tcn(setDate(6, lstrDeadlineDate), color2, 12):gapHC(0),
                                                gapWC(10),
                                                GestureDetector(
                                                    onTap: (){
                                                      if(mounted){
                                                        setState(() {
                                                          lstrBDeadLine  = false;
                                                        });
                                                      }
                                                    },
                                                    child: const Icon(Icons.cancel_outlined,color: color2,size: 12,))
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

  //========================================================WIDGET
  Widget wSearchPopupChoice(mode){
    Widget rtnWidget  =  Container();
    if(lstrTStatus.contains(RegExp(r'[C,D]'))){
      return rtnWidget;
    }
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
                lstrTModule = data["MODULE"]??"";
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
    else  if(mode  == "TASK"){
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'DOCNO', 'Display': '#'},
        {'Column': 'TASK_HEADER', 'Display': 'Task Name'},
        {'Column': 'TASK_DETAIL', 'Display': 'Task Details'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [

      ];
      var lstrFilter =[
        {'Column': "DOCNO", 'Operator': '<>', 'Value': lstrTTaskDocno, 'JoinType': 'AND'},
      ];
      rtnWidget = Lookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'TASK',
        title: 'Task List',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter:lstrFilter,
        keyColumn: 'DOCNO',
        mode: "S",
        layoutName: "B",
        callback: (data){
          if(mounted){
            setState(() {
              if(g.fnValCheck(data)){
                lstrTPrvDocno = data["DOCNO"];
                lstrTPrvDescp = data["TASK_HEADER"];
              }
            });
          }
        },
        searchYn: 'Y',
      );
    }
    else  if(mode  == "SUB"){
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'DOCNO', 'Display': '#'},
        {'Column': 'TASK_HEADER', 'Display': 'Task Name'},
        {'Column': 'TASK_DETAIL', 'Display': 'Task Details'},
        {'Column': 'MAIN_CLIENT_ID', 'Display': 'N'},
        {'Column': 'STATUS', 'Display': 'N'}
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [

      ];
      var lstrFilter =[
        {'Column': "DOCNO", 'Operator': '<>', 'Value': lstrTTaskDocno, 'JoinType': 'AND'},
        {'Column': "STATUS", 'Operator': '<>', 'Value': 'C', 'JoinType': 'AND'},
      ];
      rtnWidget = Lookup(
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
        callback: (data){
          if(mounted){
            setState(() {
              if(g.fnValCheck(data)){
                lstrTSubDocno = data["DOCNO"];
                lstrTSubDescp = data["TASK_HEADER"];
              }
            });
            apiGetSubTaskDet(data["MAIN_CLIENT_ID"], lstrTSubDocno, "TASK");
          }
        },
        searchYn: 'Y',
      );
    }
    else  if(mode  == "USERS"){
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'USER_CD', 'Display': 'Code'},
        {'Column': 'USER_NAME', 'Display': 'Name'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [

      ];
      rtnWidget = Lookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'USER_MASTER',
        title: 'Task List',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'USER_CD',
        mode: "S",
        layoutName: "B",
        callback: (data){
          if(mounted){
            setState(() {
              if(g.fnValCheck(data)){
                if(!lstrResponsibleUsers.contains(data["USER_CD"])){
                  lstrResponsibleUsers.add(data["USER_CD"]);
                }
              }
            });
          }
        },
        searchYn: 'Y',
      );
    }
    return rtnWidget;
  }
  Future<void> _selectFromDate(BuildContext context) async {

    if(lstrTStatus.contains(RegExp(r'[C,D]'))){
      return;
    }

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
  Widget wTaskOptionCard(icon,text,mode){
    return  Flexible(
      child: Bounce(
        onPressed: (){
          if(mounted){
            setState(() {
              taskOptions = mode;
            });
          }
        },
        duration:const Duration(milliseconds: 110),
        child: Container(
          decoration:taskOptions == mode? boxDecoration(Colors.white, 5): boxBaseDecoration(Colors.transparent, 0),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon,color:taskOptions == mode? color2 :Colors.black,size: 15,),
                  gapWC(5),
                  tcn(text, taskOptions == mode? color2 :Colors.black, 10)
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
  List<Widget> viewAttachmentsEdit(){
    List<Widget> rtnList =[] ;
    rtnList.add(Row());
    for(var e in lstrDocument){
      var dataList = e;
      var fileAttachPath =g.wstrBaseUrl+  dataList["ATTACHED_FILEPATH"]??'';

      rtnList.add(Bounce(
        onPressed: (){

        },
        duration: const Duration(milliseconds: 110),
        child: Container(
          width: 120,
          height: 120,
          padding:const EdgeInsets.all(5),
          margin: EdgeInsets.all(2),
          decoration: boxDecoration(Colors.white, 10),
          child:Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:  [
                  GestureDetector(
                    onTap: (){
                      fnAttachmentRemove(dataList);
                    },
                    child: const Icon(Icons.cancel_outlined,color: bgColorDark,size: 12,),
                  )
                ],
              ),
              GestureDetector(
                onTap: (){
                  _launchUrl(fileAttachPath);
                },
                child: Container(
                  decoration: boxBaseDecoration(greyLight.withOpacity(0.3), 10),
                  padding: const EdgeInsets.all(5),
                  height: 80,
                  width: 100,
                  child: Image.network(fileAttachPath,
                    errorBuilder: (context,  exception,  stackTrace) {
                      return const Icon(Icons.image,color: greyLight,size: 40,);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ));
    }

    if(rtnList.isEmpty){
      rtnList.add(Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image,color: greyLight,size: 30,),
            gapHC(5),
            tcn('No attachment selected', greyLight, 12)
          ],
        ),
      ));
    }

    return rtnList;
  }
  List<Widget> wTaskComments(){
    List<Widget> rtnList  = [];
    var srno  = 1;
    for(var e in lstrTaskComments){
      var comment  = e["COMMENT"]??"";
      var commentUser  = e["USER_CD"]??"";
      var commentDate  = e["CREATE_DATE"]??"";
      var commentCheckDate  = commentDate == ""?"":setDate(6, DateTime.parse(commentDate));
      var commentViewDate  = commentDate == ""?"":setDate(7, DateTime.parse(commentDate));
      var now = setDate(6, DateTime.now());
      if(now  ==  commentCheckDate){
        commentViewDate  = commentDate == ""?"":setDate(11, DateTime.parse(commentDate));
      }
      rtnList.add(

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.account_circle,color: commentUser.toString().toLowerCase() != g.wstrUserCd.toString().toLowerCase()?Colors.blueGrey:Colors.blueGrey,size: 30,),
              gapWC(10),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.all(10),
                  decoration:commentUser.toString().toLowerCase() != g.wstrUserCd.toString().toLowerCase()? boxBaseDecorationC(Colors.white, 0, 10, 10, 10) :boxBaseDecorationC(blueLight, 0, 10, 10, 10) ,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      tc(commentUser.toString(), color2, 15),
                      Row(
                        children: [
                          const Icon(Icons.access_time,color: Colors.blueGrey,size: 10,),
                          gapWC(5),
                          tcn(commentViewDate.toString(), Colors.blueGrey, 10),
                        ],
                      ),
                      gapHC(5),
                      Row(
                        children: [
                          tcn(comment, Colors.black, 12)
                        ],
                      ),
                      gapHC(5),
                    ],
                  ),
                ),
              ),
            ],
          )
      );
      srno = srno+1;
    }
    return rtnList;
  }
  List<Widget> wSubTask(){
    List<Widget> rtnList  = [];
    var srno  = 1;
    rtnList.add(
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.only(bottom: 5),
          decoration: boxGradientDecoration(2, 0),
          child: Row(
            children: [
              Flexible(
                child: Row(
                  children: [
                    tc("Task#", Colors.black, 10)
                  ],
                ),
              ),

              Flexible(
                child: Row(
                  children: [
                    tc("Head", Colors.black, 10)
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    tc("Created Date", Colors.black, 10)
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    tc("Created By", Colors.black, 10)
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    tc("Action", Colors.black, 10)
                  ],
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    tc("Status", Colors.black, 10)
                  ],
                ),
              ),
            ],
          ),
        )
    );
    for(var e in listSubTask){
      var createUser  = e["CREATE_USER"]??"";
      var activeUser  = e["ACTIVE_USER"]??"";
      var assignUser  = e["ASSIGNED_USER"]??"";
      var taskStatus  = e["STATUS"]??"";
      var lastStatus  = e["LAST_ACTION"]??"";
      var createDate  = e["CREATE_DATE"]??"";
      var completionNote  = e["COMPLETION_NOTE"]??"";
      var completedUser  = e["COMPLETED_USER"]??"";
      var closedTime  = e["END_TIME"]??"";
      var closeDate  =  closedTime != ""? setDate(7, DateTime.parse(closedTime)):"";
      var docno  = e["DOCNO"]??"";
      var doctype  = e["DOCTYPE"]??"";
      var docDate  = e["DOCDATE"]??"";
      var mainClientId  = e["MAIN_CLIENT_ID"]??"";
      
      var taskDate  =  createDate != ""? setDate(7, DateTime.parse(createDate)):"";
      rtnList.add(
        GestureDetector(
          onDoubleTap: (){
            Navigator.pop(context);
            widget.fnSubTaskCall(mainClientId,docno,doctype);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: boxBaseDecoration(Colors.white, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          tc("#"+e["DOCNO"].toString(), Colors.black, 10)
                        ],
                      ),
                    ),

                    Flexible(
                      child: Row(
                        children: [
                          Expanded(child: tc(e["TASK_HEADER"].toString(), Colors.black, 10))
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(child: tcn(taskDate, Colors.black, 10))
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(child: tcn(e["CREATE_USER"].toString(), Colors.black, 10))
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(child: tcn(lastStatus, Colors.black, 10))
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          tc(taskStatus =="C"?"Closed":taskStatus == "P"?"Pending":taskStatus == "A"?"Active":"", Colors.black, 10)
                        ],
                      ),
                    ),
                  ],
                ),
                gapHC(5),
                taskStatus == "C"?
                Row(
                  children: [
                    tcn('Completed by $completedUser | $closeDate | $completionNote', Colors.black, 10)
                  ],
                ):gapHC(0),
                Divider()
              ],
            ),
          ),
        )
      );
      srno = srno+1;
    }
    return rtnList;
  }

  //Upload File
  List<Widget> viewAttachments(){
    List<Widget> rtnList =[] ;
    for(var e in lstrFiles){
      rtnList.add(Bounce(

        onPressed: (){

        },
        duration: const Duration(milliseconds: 110),
        child:  Container(
          decoration: boxBaseDecoration(Colors.white, 0),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 2),
          child: Row(
            children: [
              Container(
                decoration: boxBaseDecoration(greyLight, 1),
                padding: const EdgeInsets.all(5),
                height: 40,
                width: 60,
                child: Image.network(e.toString(),
                  errorBuilder: (context,  exception,  stackTrace) {
                    dprint(exception);
                    return const Icon(Icons.sticky_note_2,color: Colors.white,size: 20,);
                  },
                ),
              ),
              gapWC(10),
              Expanded(child:  tcn(e.toString(), bgColorDark, 12)),
              GestureDetector(
                onTap: (){
                  fnRemoveFile(e);
                },
                child: const Icon(Icons.delete_sweep_outlined,color: Colors.blueGrey,size: 15,),
              )
            ],
          ),

        ),
      ));
    }

    if(rtnList.isEmpty){
      rtnList.add(Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image,color: greyLight,size: 30,),
            gapHC(5),
            tcn('No attachment selected', greyLight, 12)
          ],
        ),
      ));
    }

    return rtnList;
  }
  Widget viewImageList(){
    return lstrDocument.isNotEmpty ?
    GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio:  1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  lstrDocument.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = lstrDocument[index];
          var fileAttachPath =g.wstrBaseUrl+  dataList["ATTACHED_FILEPATH"]??'';
          return Bounce(
            onPressed: (){

            },
            duration: const Duration(milliseconds: 110),
            child: Container(
              padding:const EdgeInsets.all(5),
              decoration: boxDecoration(Colors.white, 10),
              child:Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:  [
                      GestureDetector(
                        onTap: (){
                          fnAttachmentRemove(dataList);
                        },
                        child: const Icon(Icons.cancel_outlined,color: bgColorDark,size: 12,),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      _launchUrl(fileAttachPath);
                    },
                    child: Container(
                      decoration: boxBaseDecoration(blueLight, 10),
                      padding: const EdgeInsets.all(5),
                      height: 80,
                      width: 100,
                      child: Image.network(fileAttachPath,
                        errorBuilder: (context,  exception,  stackTrace) {
                          return const Icon(Icons.sticky_note_2,color: greyLight,size: 40,);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }):
    Center(child : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.image,color: greyLight,size: 30,),
        gapHC(10),
        tcn('NO ATTACHMENTS', greyLight, 12)
      ],
    ));
  }
  Widget wTaskDetRow(icon,head,hideMode,value,mode){

    return hideMode == "N"?
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapHC(5),
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
        gapHC(5),
        lineC(1.0, greyLight),
      ],
    ):
    PopupMenuButton<Menu>(
        enabled: lstrTStatus.contains(RegExp(r'[C,D]'))?false:true,
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
              enabled: lstrTStatus.contains(RegExp(r'[C,D]'))?false:true,
              value: Menu.itemOne,
              padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
              child: wSearchPopupChoice(mode)
          ),
        ],
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapHC(5),
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
            gapHC(5),
            lineC(1.0, greyLight),
          ],
        ));

  }

  //Responsible Person
  List<Widget> wUsersList(){
    List<Widget> rtnList =[] ;
    for(var e in lstrResponsibleUsers){
      rtnList.add(
        Container(
          margin: EdgeInsets.only(left: 5),
          padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
          decoration: boxOutlineCustom1(Colors.white, 5, Colors.black, 0.5),
          child: Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: bgColorDark,
                child: tcn(e.toString().substring(0,2).toUpperCase(), Colors.white  , 8),
              ),
              gapWC(5),
              tcn(e.toString(), Colors.black, 10),
              gapWC(5),
              GestureDetector(
                onTap: (){
                  if(mounted){
                    setState(() {
                      lstrResponsibleUsers.remove(e);
                    });
                  }
                },
                child: const Icon(Icons.close,color: Colors.black,size: 10,),
              )

            ],
          ),
        )
      );
    }
    return rtnList;
  }
  List<Widget> wTaskTimeLineList(){
    List<Widget> rtnList  = [];
    var srno  = 1;
    rtnList.add(gapHC(10));
    for(var e in lstrTaskTimeLine){
      var action  = e["NOTE"]??"";
      var actionUser  = e["USER_CODE"]??"";
      var actionDate  = e["ACTION_DATE"]??"";
      var actionCheckDate  = actionDate == ""?"":setDate(6, DateTime.parse(actionDate));
      var actionViewDate  = actionDate == ""?"":setDate(7, DateTime.parse(actionDate));
      var now = setDate(6, DateTime.now());
      if(now  ==  actionCheckDate){
        actionViewDate  = actionDate == ""?"":setDate(11, DateTime.parse(actionDate));
      }
      rtnList.add(

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.access_time_sharp,color: actionUser.toString().toLowerCase() != g.wstrUserCd.toString().toLowerCase()?Colors.blueGrey:Colors.blueGrey,size: 15,),
              gapWC(5),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  padding: const EdgeInsets.all(5),
                  decoration:actionUser.toString().toLowerCase() != g.wstrUserCd.toString().toLowerCase()? boxBaseDecorationC(Colors.white, 0, 10, 10, 10) :boxBaseDecorationC(blueLight.withOpacity(0.5), 0, 10, 10, 10) ,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: tcn(action, Colors.black, 12))
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,color: Colors.blueGrey,size: 10,),
                          gapWC(5),
                          tcn(actionViewDate.toString(), Colors.blueGrey, 10),
                        ],
                      ),
                      gapHC(5),
                      Row(
                        children: [
                          const Icon(Icons.account_circle,color: Colors.blueGrey,size: 10,),
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
          )
      );
      srno = srno+1;
    }
    return rtnList;
  }

  //SubTaskView
  Widget wSubTaskView(){
    if(listSubTaskDetData.isEmpty){
      return Container();
    }
    var data  =  listSubTaskDetData[0];


    var docno =  (data["DOCNO"]??"").toString();
    var head =  (data["TASK_HEADER"]??"").toString();
    var details =  (data["TASK_DETAIL"]??"").toString();
    var createdBy =  (data["CREATE_USER"]??"").toString();
    var createdDate =  (data["CREATE_DATE"]??"").toString();

    var taskDate  =  createdDate != ""? setDate(7, DateTime.parse(createdDate)):"";

    return Container(
      padding: EdgeInsets.all(10),
      width:  300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tc('Task Details', bgColorDark , 10),
          const Divider(
            thickness: 0.5,
          ),
          tc("#$docno", Colors.black, 10),
          Row(
            children: [
              const Icon(Icons.person,color: Colors.black,size: 12,),
              gapWC(5),
              tcn(createdBy, Colors.black, 10),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.calendar_month,color: Colors.black,size: 12,),
              gapWC(5),
              tcn(taskDate, Colors.black, 10),
            ],
          ),
          const Divider(
            thickness: 0.5,
          ),
          tc("Task  :$head", Colors.black, 10),
          tcn("Details $details", Colors.black, 10),


        ],
      ),
    );
  }


  //========================================================PAGE FN


  fnGetPgaeData(){
    if(mounted){
      setState(() {
        lstrTTaskMode = widget.pageMode;
        lstrTSubDocno = widget.wSubOfDocno??"";

        wstrPageForm = [];
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtTaskHead,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please Fill Task Head","FILL_CODE":"PRICE","PAGE_NODE":""});
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtTaskDescp,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please fill task description","FILL_CODE":"PRICE","PAGE_NODE":""});
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtContactPeron,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please mention contact person","FILL_CODE":"PRICE","PAGE_NODE":""});
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtMobile,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please enter mobile no","FILL_CODE":"PRICE","PAGE_NODE":""});
        wstrPageForm.add({"C_TYPE":"W","CONTROLLER":txtEmail,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please enter email no","FILL_CODE":"PRICE","PAGE_NODE":""});

      });
    }
    apiGetTaskMasters();
    if(lstrTTaskMode=="EDIT"){
      apiGetTaskDet(widget.wMainClienId,widget.wDoco,widget.wDoctype);
    }else{

      if(widget.wSubOfDocno.isNotEmpty){
        apiGetSubTaskDet(widget.wMainClienId,widget.wSubOfDocno,widget.wDoctype);
      }
      fnNewTaskFillData();

    }
  }

  //FileUpload
  fnEditTaskFillData(data){
    fnClear();
    if(mounted){
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
        lstrTPrvDocno = data["PRV_DOCNO"]??"";
        lstrTSubDocno = data["MAIN_DOCNO"]??"";
        lstrTTaskDocno = data["DOCNO"]??"";
        lstrTTaskDoctype = data["DOCTYPE"]??"";
        lstrTMainCompany = data["MAIN_COMPANY_NAME"]??"";
        lstrTMainCompanyCode = data["MAIN_CLIENT_ID"]??"";
        lstrTCompany = data["COMPANY_NAME"]??"";
        lstrTCompanyCode = data["CLIENT_COMPANY"]??"";
        lstrTCompanyId = data["CLIENT_ID"]??"";
        lstrTCreatedBY = data["CREATE_USER"]??"";
        lstrTPriorityCode = data["PRIORITY"]??"";
        lstrTPriority = data["PRIORITY_DESCP"]??"";
        lstrTIssueType = data["ISSUE_TYPE_DESCP"]??"";
        lstrTIssueTypeCode =data["ISSUE_TYPE"]??"";
        lstrTStatus =data["STATUS"]??"";
        lstrTLastStatus =data["STATUS"]??"";
        lstrDocument =data["ATTACHMENT_TXN"]??[];
        lstrTaskComments =data["TASK_COMMENTS"]??[];
        lstrTaskTimeLine =data["TASK_HISTORY"]??[];
        listSubTask =data["SUBTASK"]??[];

        dprint(listSubTask);

        lstrTModule = data["MODULE"]??"";
        txtTaskCompletionNote.text =data["COMPLETION_NOTE"]??"";
        try{
          lstrDeadlineDate =  DateTime.parse(data["DEADLINE"]);
          lstrBDeadLine = true;
        }
        catch(e){
          lstrBDeadLine = false;
          lstrDeadlineDate =  DateTime.now();
        }


      });
    }

  }
  fnSubTaskFillData(data){

    if(mounted){
      setState(() {
        // var myJSON = jsonDecode(data["TASK_DETAIL"].toString());
        // _controller = QuillController(
        //     document: Document.fromJson(myJSON),
        //     selection: TextSelection.collapsed(offset: 0));
        listSubTaskDetData.add(data);


        txtContactPeron.text = data["CONTACT_PERSON"].toString();
        txtMobile.text = data["CONTACT_MOB"].toString();
        txtEmail.text = data["CONTACT_EMAIL"].toString();


        lstrTMainCompany = data["MAIN_COMPANY_NAME"]??"";
        lstrTMainCompanyCode = data["MAIN_CLIENT_ID"]??"";
        lstrTCompany = data["COMPANY_NAME"]??"";
        lstrTCompanyCode = data["CLIENT_COMPANY"]??"";
        lstrTCompanyId = data["CLIENT_ID"]??"";
        lstrTPriorityCode = data["PRIORITY"]??"";
        lstrTPriority = data["PRIORITY_DESCP"]??"";
        lstrTIssueType = data["ISSUE_TYPE_DESCP"]??"";
        lstrTIssueTypeCode =data["ISSUE_TYPE"]??"";

        lstrTModule = data["MODULE"]??"";

      });
    }

  }
  fnSubTaskClear(){

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
        lstrFiles = [];
        lstrDocument = [];
        lstrTPrvDocno = "";
        lstrTPrvDescp = "";

        lstrTSubDocno  = "";
        lstrTSubDescp  = "";
        lstrDeadlineDate  = DateTime.now();
        lstrViewDocno = "";
        lstrBDeadLine = false;
        txtTaskCompletionNote.clear();
        lstrTaskTimeLine = [];
        lstrTaskComments = [];
        lstrResponsibleUsers = [];
        listSubTask = [];

      });
    }
  }

  fnAddFiles() async{

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path.toString())).toList();
      print(files[0].toString());
      List<Uint8List> bytsArray =[] ;
      for(var e in files){
        Uint8List bytes  =  await e.readAsBytes();
        bytsArray.add(bytes);
      }
      //filesArray
      if(mounted){
        setState((){
          //lstrFiles = lstrFiles + files;
          if(lstrTTaskMode == "EDIT"){
            lstrFiles = [];
          }
          for(var e in files){
            if(!lstrFiles.contains(e)){
              lstrFiles.add(e);
            }
          }
        });
      }
      if(lstrTTaskMode == "EDIT"){
        fnUploadFile(lstrTTaskDocno, lstrTTaskDoctype);
      }

    }
    else {
      // User canceled the picker
    }

  }
  fnRemoveFile(file){
    if(mounted){
      setState((){
        lstrFiles.remove(file);
      });
    }
  }
  fnUploadFile(docno,doctype){
    if(lstrFiles.isEmpty){
      return ;
    }


    apiUploadFiles(docno,doctype);
  }
  Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
  fnAttachmentRemove(dataList){
    if(mounted){
      setState((){
        lstrRemoveAttachment =  dataList;
      });
    }
    PageDialog().deleteDialog(context, apiDeleteAttachment);
  }
  fnAddNewClear(){
    if(mounted){
      setState(() {
        txtTaskHead.clear();
        txtTaskDescp.clear();
        lstrFiles = [];
        lstrTPrvDocno = "";
        lstrTPrvDescp = "";
        lstrTSubDocno  = "";
        lstrTSubDescp  = "";
      });
    }
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
        taskOptions = "A";
        lstrTCreatedBY = g.wstrUserCd.toString();
        lstrTTaskMode = "ADD";
        lstrTStatus = "P";
        lstrTSubDocno =  widget.wSubOfDocno;
        lstrTPriorityCode ="P1";
        lstrTPriority = "NORMAL";

      });

    }
  }


  //========================================================API CALL

  apiUploadFiles(docno,doctype) {
    futureForm =  ApiManager().mfnAttachment(lstrFiles, docno, doctype);
    futureForm.then((value) => apiUploadFilesRes(value));
  }
  apiUploadFilesRes(value){
    apiGetTaskDocumentDet(lstrTMainCompanyCode,lstrTTaskDocno,lstrTTaskDoctype);
  }

  apiDeleteAttachment(){
    //print(dataList);
    Navigator.pop(context);
    var dataList  =  lstrRemoveAttachment;
    futureForm =  apiCall.apiDeleteAttachment( dataList["DOCNO"], dataList["DOCTYPE"], dataList["SRNO"], dataList["RELATIVE_PATH"]);
    futureForm.then((value) => apiDeleteAttachmentRes(value));
  }
  apiDeleteAttachmentRes(value){
    print(value);
    if(g.fnValCheck(value)){

      if(value  == "DELETED"){
        //call fill api with code;
        infoMsg(context, "Removed");
        apiGetTaskDocumentDet(lstrTMainCompanyCode,lstrTTaskDocno,lstrTTaskDoctype);
      }else{
        errorMsg(context, "Sorry, Try Again !!!");
      }
    }else{
      errorMsg(context, "Please try again!");
    }
  }

  apiGetTaskDocumentDet(mainClientId,docno,doctype){
    futureForm = apiCall.apiGetTaskDet(mainClientId, docno, doctype);
    futureForm.then((value) => apiGetTaskDocumentDetRes(value));
  }
  apiGetTaskDocumentDetRes(value){
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
          lstrDocument =value["ATTACHMENT_TXN"]??[];
        }
      });
    }
  }

  apiAddComment(docno, doctype, comment){
    futureForm = apiCall.apiAddTaskComment(docno, doctype, comment);
    futureForm.then((value) => apiAddCommentRes(value));
  }
  apiAddCommentRes(value){
    if(mounted){
      setState(() {
        txtComment.clear();
      });
      apiGetTaskDet(lstrTMainCompanyCode,lstrTTaskDocno,lstrTTaskDoctype);
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

  apiGetSubTaskDet(mainClientId,docno,doctype){
    futureForm = apiCall.apiGetTaskDet(mainClientId, docno, doctype);
    futureForm.then((value) => apiGetSubTaskDetRes(value));
  }
  apiGetSubTaskDetRes(value){
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
          fnSubTaskFillData(value);
        }
      });
    }
  }

  apiSaveTask(mode){

    var saveSts = true;
    for(var e in wstrPageForm){
      var validate =  e["VALIDATE"];
      if(validate){
        var value  = e["C_TYPE"].toString() ==  "W"?e["CONTROLLER"].text:e["CONTROLLER"].toString();
        if(value ==  null || value ==  ""){
          errorMsg(context, e["ERROR_MSG"].toString());
          saveSts = false;
          return;
        }
      }
    }

    if(lstrTMainCompanyCode.isEmpty){
      errorMsg(context, "Please select Main Company");
      saveSts = false;
      return;
    }
    if(lstrTCompanyCode.isEmpty){
      errorMsg(context, "Please select company");
      saveSts = false;
      return;
    }
    if(lstrTModule.isEmpty){
      errorMsg(context, "Please select module");
      saveSts = false;
      return;
    }
    if(lstrTPriority.isEmpty){
      errorMsg(context, "Please choose priority");
      saveSts = false;
      return;
    }
    if(lstrTIssueType.isEmpty){
      errorMsg(context, "Please select Issue Type");
      saveSts = false;
      return;
    }


    if(!saveSts){
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
        "DEADLINE":lstrBDeadLine? setDate(2, lstrDeadlineDate):null,
        //"START_TIME": "",
        // "END_TIME": "",
        //"DURATION": "",
        //"DURATION_TYPE": "",
        //"CREATE_USER": "",
        //"CREATE_DATE": "",
        "PRV_DOCNO": lstrTPrvDocno,
        "MAIN_DOCNO": lstrTSubDocno,
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
    var userList = [];
    if(lstrResponsibleUsers.isNotEmpty){
      for(var e in  lstrResponsibleUsers){
        userList.add({'COL_VAL':e});
      }
    }
    futureForm = apiCall.apiSaveTask(TASK, TASK_CHECKLIST, TASK_PLATFORM, MODE,userList);
    futureForm.then((value) => apiSaveTaskRes(value,mode));
  }
  apiSaveTaskRes(value,mode){
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
          var doctype =  value[0]["DOCTYPE"].toString();

          if(mode == "NEW"){
            fnAddNewClear();
          }else{
            Navigator.pop(context);
          }
          //successMsg(context, "$code \n New Task Added !!!");
          PageDialog().showTaskDone(context,code,"HEAD");
          fnUploadFile(code,doctype);

          widget.fnGetTask("");

        }else{
          //Failed
          errorMsg(context, msg.toString());

        }
      }

    }
    // [{STATUS: 1, MSG: SAVED, CODE: 0000000007, DOCTYPE: TASK}]
  }

  apiEditTask(){
    var saveSts = true;
    for(var e in wstrPageForm){
      var validate =  e["VALIDATE"];
      if(validate){
        var value  = e["C_TYPE"].toString() ==  "W"?e["CONTROLLER"].text:e["CONTROLLER"].toString();
        if(value ==  null || value ==  ""){
          errorMsg(context, e["ERROR_MSG"].toString());
          saveSts = false;
          return;
        }
      }
    }

    if(lstrTMainCompanyCode.isEmpty){
      errorMsg(context, "Please select Main Company");
      saveSts = false;
      return;
    }
    if(lstrTCompanyCode.isEmpty){
      errorMsg(context, "Please select company");
      saveSts = false;
      return;
    }
    if(lstrTModule.isEmpty){
      errorMsg(context, "Please select module");
      saveSts = false;
      return;
    }
    if(lstrTPriority.isEmpty){
      errorMsg(context, "Please choose priority");
      saveSts = false;
      return;
    }
    if(lstrTIssueType.isEmpty){
      errorMsg(context, "Please select Issue Type");
      saveSts = false;
      return;
    }


    if(!saveSts){
      return;
    }

    // if(lstrTStatus.contains(RegExp(r'[C,D]')) && txtTaskCompletionNote.text.isEmpty){
    //   errorMsg(context, "Please fill completion note");
    //   saveSts = false;
    //   return;
    // }



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

        "DEADLINE":lstrBDeadLine? setDate(2, lstrDeadlineDate):null,
        //"START_TIME": "",
        //"END_TIME": "",
        //"DURATION": "",
        //"DURATION_TYPE": "",
        //"CREATE_USER": "",
        //"CREATE_DATE": "",
        "PRV_DOCNO": lstrTPrvDocno,
        "MAIN_DOCNO": lstrTSubDocno,
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
          widget.fnGetTask();
        }else{
          //Failed
          errorMsg(context, msg.toString());

        }
      }

    }



    // [{STATUS: 1, MSG: SAVED, CODE: 0000000007, DOCTYPE: TASK}]
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


}
