
import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/components/inputField/form_inputfield.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductStore extends StatefulWidget {
  const ProductStore({Key? key}) : super(key: key);

  @override
  State<ProductStore> createState() => _ProductStoreState();
}

class _ProductStoreState extends State<ProductStore> {

  //Global
  var g = Global();
  var apiCall  = ApiCall();
  var wstrPageMode  = "VIEW";
  late Future<dynamic> futureForm;

  //Page variable
  var blSave =  true;
  var listSearchData  =  [];

  //Controllers
  var txtSearch =  TextEditingController();
  var txtProductId =  TextEditingController();
  var txtProductName =  TextEditingController();
  var txtProductNote =  TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiSearchProduct();
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
                    const Icon(Icons.dashboard_outlined,color: Colors.black,size: 15,),
                    gapWC(5),
                    tc('Beams Store', Colors.black, 15)
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
                        tcn('Add New  ', Colors.white, 14)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          gapHC(10),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  flex: 8,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(),
                        gapHC(10),
                        tc('Applications', Colors.black, 15),
                        gapHC(5),
                        Container(
                          width: 75,
                          height: 5,
                          decoration: boxBaseDecoration(bgColorDark, 30),
                        ),
                        gapHC(10),
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
                              apiSearchProduct();
                            },
                          ),

                        ),
                        gapHC(10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              children: wProductList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                gapWC(15),
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(10),
                  decoration: boxDecoration(Colors.white, 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(),
                              gapHC(10),
                              tc('App Details', Colors.black, 15),
                              gapHC(5),
                              Container(
                                width: 75,
                                height: 5,
                                decoration: boxBaseDecoration(bgColorDark, 30),
                              ),
                              gapHC(10),
                              FormInput(
                                txtController: txtProductId,
                                hintText: "Product Code",
                                enablests: false,
                                emptySts: false,
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
                              gapHC(5),
                              FormInput(
                                txtController: txtProductName,
                                hintText: "Product Name",
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

                              gapHC(5),
                              FormInput(
                                txtController: txtProductNote,
                                hintText: "Product Details",
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
                      ),
                      Bounce(
                        onPressed: (){
                          if(blSave){
                            apiSave();
                          }
                        },
                        duration: const Duration(milliseconds: 110),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 8),
                          decoration: boxBaseDecoration(bgColorDark, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              tcn(wstrPageMode == "EDIT"?"Update": "Save", Colors.white, 13)
                            ],
                          ) ,
                        ),
                      ),
                      gapHC(5),
                      wstrPageMode == "EDIT"?
                      Bounce(
                        onPressed: (){
                          if(blSave){
                            fnDelete();
                          }
                        },
                        duration: const Duration(milliseconds: 110),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 8),
                          decoration: boxBaseDecoration(subColor, 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              tcn("Delete", Colors.white, 13)
                            ],
                          ) ,
                        ),
                      ):gapHC(0),
                      gapHC(10),
                      Bounce(
                        onPressed: (){
                          fnClear();
                          apiSearchProduct();
                        },
                        duration: const Duration(milliseconds: 110),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 5),
                          decoration: boxOutlineCustom1(Colors.white, 30, bgColorDark, 1.0),
                          child : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              tcn('Cancel', Colors.black, 13)  ,
                            ],
                          ) ,

                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  //===================================WIDGET

    Widget wProductCard(code,name,descp,e){
      return Bounce(
        onPressed: (){
          if(mounted){
            setState(() {
              wstrPageMode = "EDIT";
            });
          }
          fnFill(e);
        },
        duration: const Duration(milliseconds: 110),
        child: Container(
        height: 200,
        margin: const EdgeInsets.all(5),
        decoration:txtProductId.text == code ? boxBaseDecoration(bgColorDark.withOpacity(0.4), 15): boxDecoration(Colors.white, 15),
        width: 180,
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  Image.asset("assets/icons/appicon.jpg",width: 70,),
                  gapHC(5),
                  tc(code, Colors.black, 12),
                  tcn(name, Colors.black, 10),
                  const SizedBox(
                    width: 100,
                    child: Divider(
                      thickness: 0.5,
                    ),
                  ),
                  tcn(descp, Colors.black, 8),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3),
              decoration: boxBaseDecorationC(bgColorDark, 0,0,15 ,15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tcn('VERSION 1.0.0', Colors.white, 8)
                ],
              ),
            )
          ],
        ),
    ),
      );
    }

    List<Widget> wProductList(){
      List<Widget> rtnList = [];
      for(var e in  listSearchData){
        var id  =  (e["PRODUCT_ID"]??"").toString();
        var name  =  (e["NAME"]??"").toString();
        var descp  =  (e["DESCP"]??"").toString();
        rtnList.add( wProductCard(id,name,descp,e));
      }
      return rtnList;
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
        txtProductId.clear();
        txtProductName.clear();
        txtProductNote.clear();
        wstrPageMode = "VIEW";
      });
    }
  }
  fnFill(data){
    if(mounted){
      setState(() {
        txtProductId.text  = (data["PRODUCT_ID"]??"").toString();
        txtProductName.text  = (data["NAME"]??"").toString();
        txtProductNote.text  = (data["DESCP"]??"").toString();
      });
    }
  }

  fnDelete(){
    PageDialog().deleteDialog(context, apiDelete);
  }

  //===================================API CALL

  apiSearchProduct(){
    var filterVal= [];
    filterVal  = [];
    filterVal.add({ "Column": "PRODUCT_ID", "Operator": "LIKE", "Value": txtSearch.text, "JoinType": "OR" });
    filterVal.add({ "Column": "NAME", "Operator": "LIKE", "Value": txtSearch.text, "JoinType": "OR" });
    filterVal.add({ "Column": "DESCP", "Operator": "LIKE", "Value": txtSearch.text, "JoinType": "OR" });

    futureForm = apiCall.LookupSearch("PRODUCT_MAST", "PRODUCT_ID|NAME|DESCP|LOGO|MODULE|", 0, 100, filterVal);
    futureForm.then((value) => apiSearchProductRes(value));
  }
  apiSearchProductRes(value){
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

    if(txtProductName.text.isEmpty){
      errorMsg(context, "Please Enter Product Name");
      return;
    }else if(wstrPageMode == "EDIT" && txtProductId.text.isEmpty){
      errorMsg(context, "Please Select Product");
      return;
    }
    setState(() {
      blSave = false;
    });
    futureForm = apiCall.apiSaveProduct(txtProductId.text,txtProductName.text,txtProductNote.text,wstrPageMode);
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
          if(wstrPageMode == "ADD"){
            successMsg(context, "Saved !!!");
          }else if(wstrPageMode == "EDIT"){
            successMsg(context, "Updated !!!");
          }
          apiSearchProduct();
          fnClear();
        }else{
          //Failed
          errorMsg(context, msg.toString());
        }
      }

    }
  }

  apiDelete(){
    Navigator.pop(context);
    if(wstrPageMode != "EDIT"){
      return;
    }
    if(wstrPageMode == "EDIT" && txtProductId.text.isEmpty){
      errorMsg(context, "Please Select Company");
      return;
    }
    setState(() {
      blSave = false;
    });
    futureForm = apiCall.apiSaveProduct(txtProductId.text,txtProductName.text,txtProductNote.text,"DELETE");
    futureForm.then((value) => apiDeleteRes(value));
  }

  apiDeleteRes(value){
    if(mounted){


      if(g.fnValCheck(value)){
        var sts =  value[0]["STATUS"].toString();
        var msg =  value[0]["MSG"].toString();
        if(sts  == "1"){
          //Success
          var code =  value[0]["CODE"].toString();
          successMsg(context, "Deleted");
          apiSearchProduct();
          fnClear();
        }else{
          //Failed
          errorMsg(context, msg.toString());
        }
      }

    }
  }

}
