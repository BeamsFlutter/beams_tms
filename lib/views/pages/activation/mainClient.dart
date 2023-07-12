

import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/components/inputField/form_inputfield.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';


class MainClient extends StatefulWidget {
  const MainClient({Key? key}) : super(key: key);

  @override
  State<MainClient> createState() => _MainClientState();
}

class _MainClientState extends State<MainClient> {

  //Global
  var g = Global();
  var apiCall  = ApiCall();
  var wstrPageMode  = "VIEW";
  late Future<dynamic> futureForm;

  //Page Variables
  var listSearchData = [];
  var blSave =  true;

  //Controller
  var txtCompany  =  TextEditingController();
  var txtCompanyName =  TextEditingController();
  var txtSearch  =  TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiSearchCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            decoration: boxDecoration(Colors.white, 10),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_balance,color: Colors.black,size: 15,),
                    gapWC(5),
                    tc('Main Company', Colors.black, 15)
                  ],
                ),
                Bounce(
                  onPressed: (){
                    fnAdd();
                  },
                  duration: const Duration(milliseconds: 110),
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
                        tcn('Create    ', Colors.white, 14)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          gapHC(10),
          Expanded(child: Row(
            children: [
              Container(
                width: 280,
                padding: EdgeInsets.all(10),
                decoration: boxDecoration(Colors.white, 10),
                child: Column(
                  children: [
                    Row(),
                    Container(
                      height: 35,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: boxBaseDecoration(greyLight, 5),
                      child: TextFormField(
                        controller: txtSearch,
                        style: GoogleFonts.poppins(fontSize: 10,),
                        decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            suffixIcon:  Icon(Icons.search,color: bgColorDark,size: 13,)
                        ),
                        onChanged: (value){
                          apiSearchCompany();
                        },
                      ),

                    ),
                    gapHC(10),
                    Expanded(child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: listSearchData.length,
                        itemBuilder: (context, index) {
                          var dataList  =  listSearchData[index]??[];
                          return Bounce(
                            onPressed: (){
                              if(mounted){
                                setState(() {
                                  wstrPageMode = "EDIT";
                                });
                              }
                              fnFill(dataList);
                            },
                            duration: const Duration(milliseconds: 110),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.all(10),
                              decoration:txtCompany.text == (dataList["MAIN_CLIENT_ID"]??"").toString()?boxDecoration(bgColor, 5): boxBaseDecoration(bgColorDark, 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  tc((dataList["MAIN_CLIENT_ID"]??"").toString(),  Colors.white, 12),
                                  tcn((dataList["MAIN_COMPANY_NAME"]??"").toString(), Colors.white, 12),
                                  tcn('12-05-2023', Colors.white, 12)
                                ],
                              ),
                            ),
                          );
                        }))
                  ],
                ),
              ),
              gapWC(10),
              Flexible(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start  ,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: boxDecoration(Colors.white, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(),
                          gapHC(10),
                          tc('Company Details', Colors.black, 15),
                          gapHC(5),
                          Container(
                            width: 75,
                            height: 5,
                            decoration: boxBaseDecoration(bgColorDark, 30),
                          ),
                          gapHC(30),
                          FormInput(
                            txtController: txtCompany,
                            hintText: "Company Code",
                            txtWidth: 0.2,
                            enablests: false,
                            emptySts: false,
                            onClear: (){
                            },
                            onChanged: (value){
                            },
                            validate: true,
                          ),
                          gapHC(5),
                          FormInput(
                            txtController: txtCompanyName,
                            hintText: "Company Name",
                            txtWidth: 0.3,
                            enablests: wstrPageMode == "VIEW"?false:true,
                            emptySts: wstrPageMode == "VIEW"?false:true,
                            onClear: (){
                              setState((){
                              });
                            },
                            onChanged: (value){
                              setState((){
                              });
                            },
                            validate: true,
                          ),
                        ],
                      ),
                    ),
                    gapHC(10),
                    Expanded(
                      child: Container(
                        decoration: boxDecoration(Colors.white, 10),
                        child: Column(
                          children: [
                            Row()
                          ],
                        ),
                      ),
                    ),
                    wstrPageMode !="VIEW"?
                    gapHC(10):gapHC(0),
                    wstrPageMode !="VIEW"?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Bounce(
                          onPressed: (){
                            fnClear();
                            apiSearchCompany();
                          },
                          duration: const Duration(milliseconds: 110),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 40,vertical: 5),
                            decoration: boxOutlineCustom1(Colors.white, 30, bgColorDark, 1.0),
                            child: tcn('Cancel', Colors.black, 13)  ,
                          ),
                        ),
                        gapWC(8),
                        Bounce(
                          onPressed: (){
                            if(blSave){
                              apiSave();
                            }
                          },
                          duration: const Duration(milliseconds: 110),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 80,vertical: 6),
                            decoration: boxDecoration(bgColorDark, 30),
                            child: tcn(wstrPageMode == "EDIT"?"Update": "Save", Colors.white, 13)  ,
                          ),
                        )
                      ],
                    ):gapHC(0),
                  ],
                ),
              )
            ],
          ))

        ],
      ),
    );
  }

  //===================================PAGE FN

  fnAdd(){
    if(mounted){
      fnClear();
      setState(() {
        wstrPageMode = "ADD";
      });
    }
  }

  fnClear(){
    if(mounted){
      setState(() {
        txtCompany.clear();
        txtCompanyName.clear();
        wstrPageMode = "VIEW";
      });
    }
  }

  fnFill(data){
    if(mounted){
      setState(() {
        txtCompany.text  = (data["MAIN_CLIENT_ID"]??"").toString();
        txtCompanyName.text  = (data["MAIN_COMPANY_NAME"]??"").toString();
      });
    }
  }

  //===================================API CALL

  apiSearchCompany(){
    var filterVal= [];
    filterVal  = [];
    filterVal.add({ "Column": "MAIN_CLIENT_ID", "Operator": "LIKE", "Value": txtSearch.text, "JoinType": "OR" });
    filterVal.add({ "Column": "MAIN_COMPANY_NAME", "Operator": "LIKE", "Value": txtSearch.text, "JoinType": "OR" });

    futureForm = apiCall.LookupSearch("MAIN_CLIENT", "MAIN_CLIENT_ID|MAIN_COMPANY_NAME|", 0, 100, filterVal);
    futureForm.then((value) => apiSearchCompanyRes(value));
  }
  apiSearchCompanyRes(value){
    if(mounted){
      setState(() {
        listSearchData = [];
        if(g.fnValCheck(value)){
          listSearchData = value;
        }
      });

    }
  }

  apiSave(){

    if(txtCompanyName.text.isEmpty){
      errorMsg(context, "Please Enter Company Name");
      return;
    }else if(wstrPageMode == "EDIT" && txtCompany.text.isEmpty){
      errorMsg(context, "Please Select Company");
      return;
    }
    setState(() {
      blSave = false;
    });
    futureForm = apiCall.apiSaveMainCompany(txtCompany.text,txtCompanyName.text,wstrPageMode);
    futureForm.then((value) => apiSaveRes(value));
  }
  apiSaveRes(value){
    if(mounted){
      setState(() {
        blSave = true;
      });

      if(g.fnValCheck(value)){
        var sts =  value[0]["STATUS"].toString();
        var msg =  value[0]["MSG"].toString();
        if(sts  == "1"){
          //Success
          var code =  value[0]["CODE"].toString();
          PageDialog().showClientSaves(context,code,txtCompanyName.text.toString(),wstrPageMode);
          apiSearchCompany();
          fnClear();
        }else{
          //Failed
          errorMsg(context, msg.toString());
        }
      }

    }
  }
}
