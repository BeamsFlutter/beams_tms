

import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/components/inputField/form_inputfield.dart';
import 'package:bams_tms/views/components/lookup/filterLookup.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';


class TaskAssign extends StatefulWidget {
  final Function  fnCallBack;
  const TaskAssign({Key? key, required this.fnCallBack}) : super(key: key);

  @override
  State<TaskAssign> createState() => _TaskAssignState();
}

class _TaskAssignState extends State<TaskAssign> {


  //Global Variables
  Global g = Global();
  var apiCall  = ApiCall();
  late Future<dynamic> futureForm;
  var lstrDeadlineDate  = DateTime.now();
  var lstrBDeadLine = false;

  //Page Variable
  var lstrPageMode = "U";
  var listUsers = [];
  var listDepartment = [];

  var listSUsers = [];
  var listSDepartment = [];


  //Controller
  var txtAssignNote = TextEditingController();
  var txtController = TextEditingController();
  var txtSearch = TextEditingController();
  var txtWorkTime = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.task_alt,color: color2,size: 15,),
              gapWC(10),
              tcn('Task Assign', color2 , 15),
            ],
          ),
          gapHC(5),
          lineC(1.0, greyLight),
          gapHC(10),

          Container(
            padding: const EdgeInsets.all(5),
            decoration: boxBaseDecoration(greyLight, 5),
            child: Row(
              children: [
                wDepartmentSelection(Icons.group,"To Users","U"),
                gapWC(5),
                wDepartmentSelection(Icons.laptop,"To Department","D"),
              ],
            ),
          ),
          gapHC(15),
          Container(
            height: 30,
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: boxOutlineCustom1(Colors.white, 5, Colors.grey, 0.5),
            child: TextFormField(
              autofocus: true,
              controller: txtSearch,
              style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
              keyboardType: TextInputType.visiblePassword,
              decoration:   InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.poppins(fontSize: 12),
                border: InputBorder.none,

                suffixIcon: InkWell(
                  onTap: (){
                    setState(() {
                      txtSearch.clear();
                    });
                    if(lstrPageMode == "U"){
                      apiGetUsers();
                    }else{
                      apiGetDepartment();
                    }
                  },
                  child: const Icon(Icons.close,color: Colors.blueGrey,size: 15,),
                ),

              ),
              onChanged: (value){
                apiGetUsers();
              },
            ),
          ),
          gapHC(15),
          Expanded(
            child: lstrPageMode == "U"?wUsersList():wDepartmentList(),
          ),
          gapHC(15),

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
          gapHC(10),
          FormInput(
            hintText: "Work Time (Minutes)",
            enablests:true,
            emptySts:true,
            txtController: txtWorkTime,
            textType: TextInputType.number,
            onChanged: (value){
              setState((){
              });
            },
            onSubmit: (value){
            },
            onClear: (){
              setState((){
                txtWorkTime.clear();
              });
            },
            validate: true,
          ),
          gapHC(10),
          Row(
            children: [
              const Icon(Icons.edit_note,color: Colors.black,size: 15,),
              gapWC(5),
              tcn('Assign Note', Colors.black, 12),
            ],
          ),
          gapHC(2),
          Container(
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: boxOutlineCustom1(Colors.white, 5, Colors.black, 0.5),
            child: TextFormField(
              controller: txtAssignNote,
              autofocus: true,
              style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
              keyboardType: TextInputType.visiblePassword,
              minLines: 5,
              maxLines: 5,
              decoration:   InputDecoration(
                hintText: 'Assign Note',
                hintStyle: GoogleFonts.poppins(fontSize: 12),
                border: InputBorder.none,
              ),
              onChanged: (val){
                if(mounted){
                  setState(() {

                  });
                }
              },
            ),
          ),
          gapHC(10),

          GestureDetector(
            onTap: (){
              fnDone();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: boxBaseDecoration(color2, 30),
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tcn('Done', Colors.white, 10),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: boxOutlineCustom1(Colors.white,30,Colors.black.withOpacity(0.5), 1.0),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tcn('Cancel', Colors.black, 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //===================================WIDGET

  Widget wDepartmentSelection(icon,text,mode){
     return Expanded(child: Bounce(
       onPressed: (){
        if(mounted){
          setState(() {
            lstrPageMode = mode;
          });
        }
        if(mode == "U"){
          apiGetUsers();
        }else{
          apiGetDepartment();
        }
       },
       duration: const Duration(milliseconds: 110),
       child: Container(
         decoration:lstrPageMode == mode? boxDecoration(Colors.white, 5): boxBaseDecoration(Colors.transparent, 5),
         padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
         child: Row(
           children: [
             CircleAvatar(
               backgroundColor: bgColorDark,
               radius: 12,
               child: Icon(icon,color: Colors.white,size: 12,),
             ),
             gapWC(10),
             tcn(text, Colors.black, 12),
           ],
         ),
       ),
     ));
    }
  Widget wUsersList(){
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listUsers.length,
        itemBuilder: (context, index){
          var dt =  listUsers[index];
          return Bounce(
            onPressed: (){
              if(mounted){
                setState(() {
                  if (listSUsers.contains(dt["USER_CD"])) {
                    listSUsers.remove(dt["USER_CD"]);
                  }else{
                    listSUsers.add(dt["USER_CD"]);
                  }
                });
              }
            },
            duration: const Duration(milliseconds: 110),
            child: Container(
              decoration: boxBaseDecoration(bGreyLight, 5),
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    decoration:listSUsers.contains(dt["USER_CD"])? boxDecoration(color2, 5): boxOutlineCustom1(Colors.white, 5, color2, 1.0),
                    child: listSUsers.contains(dt["USER_CD"])?const Icon(Icons.done,color: Colors.white,size: 10,):gapHC(0),
                  ),
                  gapWC(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc(dt["USER_CD"].toString(), Colors.black , 10),
                        tcn(dt["USER_NAME"].toString(), Colors.black , 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget wDepartmentList(){
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: listDepartment.length,
        itemBuilder: (context, index){
          var dt =  listDepartment[index];
          return Bounce(
            onPressed: (){
              if(mounted){
                setState(() {
                  listSDepartment.clear();
                  listSDepartment.add(dt["CODE"]);
                });
              }
            },
            duration: const Duration(milliseconds: 110),
            child: Container(
              decoration: boxBaseDecoration(bGreyLight, 5),
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    decoration:listSDepartment.contains(dt["CODE"])? boxDecoration(color2, 5): boxOutlineCustom1(Colors.white, 5, color2, 1.0),
                    child: listSDepartment.contains(dt["CODE"])?const Icon(Icons.done,color: Colors.white,size: 10,):gapHC(0),
                  ),
                  gapWC(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc(dt["CODE"].toString(), Colors.black , 10),
                        tcn(dt["DESCP"].toString(), Colors.black , 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  Widget wAssignList(){
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
      title: 'Assign Users',
      lstrOldData: [],
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
          //apiMoveTask(docno, doctype, data,txtAssignNote.text);
        }
      },
      searchYn: 'Y',
    );
  }

  //===================================PAGE FN

  fnGetPageData(){
    if(mounted){
      apiGetUsers();
    }
  }

  fnDone(){
    if(lstrPageMode == "U" && listSUsers.isEmpty){
      errorMsg(context, 'Select Users');
      return;
    }
    var dept= "";
    if(lstrPageMode == "D" && listSDepartment.isEmpty){
      errorMsg(context, 'Select Department');
      return;
    }
    if(listSDepartment.isNotEmpty){
      dept =  listSDepartment[0];
    }
    var deadLine  = "";
    if(lstrBDeadLine){
      deadLine = setDate(2, DateTime.now());
    }
    var min =  g.mfnInt(txtWorkTime.text);
    Navigator.pop(context);
    widget.fnCallBack(listSUsers,dept,lstrPageMode,txtAssignNote.text,deadLine,min);

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
  //===================================API CALL

  apiGetUsers(){
    var filterVal= [];
    filterVal  = [];
    filterVal.add({ "Column": "USER_CD", "Operator": "<>", "Value": g.wstrUserCd.toString(), "JoinType": "AND" });
    filterVal.add({ "Column": "USER_CD", "Operator": "LIKE", "Value": txtSearch.text, "JoinType": "OR" });
    filterVal.add({ "Column": "USER_NAME", "Operator": "LIKE", "Value": txtSearch.text, "JoinType": "OR" });

    futureForm = apiCall.LookupSearch("USER_MASTER", "USER_CD|USER_NAME|", 0, 100, filterVal);
    futureForm.then((value) => apiGetUsersRes(value));
  }
  apiGetUsersRes(value){
    if(mounted){
      setState(() {
        listUsers = [];
        if(g.fnValCheck(value)){
          listUsers = value;
        }
      });
    }
  }

  apiGetDepartment(){
    var filterVal= [];
    filterVal  = [];
    filterVal.add({ "Column": "CODE", "Operator": "LIKE", "Value": txtSearch.text, "JoinType": "OR" });
    filterVal.add({ "Column": "DESCP", "Operator": "LIKE", "Value": txtSearch.text, "JoinType": "OR" });

    futureForm = apiCall.LookupSearch("DEPARTMENT_MAST  ", "CODE|DESCP|", 0, 100, filterVal);
    futureForm.then((value) => apiGetDepartmentRes(value));
  }
  apiGetDepartmentRes(value){
    if(mounted){
      setState(() {
        listDepartment = [];
        if(g.fnValCheck(value)){
          listDepartment = value;
        }
      });
    }
  }

}
