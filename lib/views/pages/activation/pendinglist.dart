

import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingList extends StatefulWidget {
  const PendingList({Key? key}) : super(key: key);

  @override
  State<PendingList> createState() => _PendingListState();
}

class _PendingListState extends State<PendingList> {

  //Global
  var g = Global();
  var apiCall  = ApiCall();
  late Future<dynamic> futureForm;


  //Page Variables
  var lstrPendingMode = "Client";
  var lstrProductList = [];
  var lstrPendingList = [];

  var lstrSelectedList  =  [];
  var lstrSelectedListDet  =  [];
  var blDeviceLimit = false;
  var blUserLimit = false;
  var blProductSelect = false;
  var blSave = true;
  var lstrSelectedClient = [];


  var fMainCompany = "";
  var fMainCompanyName = "";
  var fClient = "";
  var fCompany = "";
  var fCompanyName = "";
  var fRegDate = "";
  var fMacId = "";
  var fDeviceID = "";
  var fDbName = "";

  //Controller
  var txtSearch =  TextEditingController();
  var txtSearchProduct =  TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiGetActivationList();

  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Column(
      children: [
        Container(
          decoration: boxDecoration(Colors.white, 10),
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.pending_actions,color: Colors.black,size: 15,),
                  gapWC(5),
                  tc('Activation Pending', Colors.black, 15)
                ],
              ),


            ],
          ),
        ),
        gapHC(10),
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                width: 280,
                decoration: boxDecoration(Colors.white, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(),
                    gapHC(10),
                    tc('Pending List', Colors.black, 15),
                    gapHC(5),
                    Container(
                      width: 75,
                      height: 5,
                      decoration: boxBaseDecoration(bgColorDark, 30),
                    ),
                    gapHC(10),
                    Row(
                      children: [
                        wPendingCard("Client"),
                        gapWC(5),
                        wPendingCard("Device"),
                        gapWC(5),
                        wPendingCard("Users"),
                      ],
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
                          apiGetActivationList();
                        },
                      ),

                    ),
                    gapHC(5),
                    Expanded(
                      child: ListView.builder(
                        itemCount: lstrPendingList.length,
                        itemBuilder: (context,index){

                          var dataList  =  lstrPendingList[index]??[];
                          var mainCompany = dataList["MAIN_CLIENT_ID"]??"";
                          var mainCompanyName = dataList["MAIN_COMPANY_NAME"]??"";
                          var clientId = dataList["CLIENT_ID"]??"";
                          var company = dataList["COMPANY_CODE"]??"";
                          var companyName = dataList["NAME"]??"";
                          var productId = dataList["PRODUCT_ID"]??"";
                          var macId = dataList["MACID"]??"";
                          var deviceId = dataList["DEVICE_ID"]??"";
                          var dbName = dataList["DBNAME"]??"";
                          var regDate = setDate(7, DateTime.parse(dataList["REQUEST_DATE"].toString()));

                          return  Bounce(
                            onPressed: (){
                              if(mounted){
                                fnClear();
                                setState(() {
                                  lstrSelectedClient.clear();
                                  lstrSelectedClient.add(dataList);


                                  fMainCompany = mainCompany;
                                  fMainCompanyName = mainCompanyName;
                                  fClient = clientId;
                                  fCompany = company;
                                  fCompanyName = companyName;
                                  fRegDate = regDate;
                                  fMacId = macId;
                                  fDeviceID = deviceId;
                                  fDbName = dbName;

                                });
                                fnSelectClient();

                              }
                            },
                            duration: const Duration(milliseconds: 110),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              padding: const EdgeInsets.all(5),
                              decoration: boxOutlineCustom1(Colors.white, 5,Colors.black,1.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    decoration: boxBaseDecorationC(bgColorDark, 5,5,0 ,0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        tc('$lstrPendingMode Activation', Colors.white, 10),
                                      ],
                                    ),
                                  ),
                                  gapHC(5),
                                  tc(mainCompany.toString(), Colors.black, 10),
                                  tc(mainCompanyName, Colors.black, 10),
                                  const Divider(
                                    thickness: 0.5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.account_balance,color: bgColorDark,size: 12,),
                                      gapWC(10),
                                      tcn("$company | $companyName", Colors.black, 10)
                                    ],
                                  ),
                                  gapHC(3),
                                  Row(
                                    children: [
                                      const Icon(Icons.monitor,color: bgColorDark,size: 12,),
                                      gapWC(10),
                                      tcn(productId.toString(), Colors.black, 10)
                                    ],
                                  ),
                                  gapHC(3),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_month,color: bgColorDark,size: 12,),
                                      gapWC(10),
                                      tcn(regDate.toString(), Colors.black, 10)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              gapWC(10),
                Flexible(child: lstrSelectedClient.isNotEmpty? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      Container(
                        decoration: boxDecoration(Colors.white, 5),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(),

                            gapHC(10),
                            tc('Activation Details', Colors.black, 15),
                            gapHC(5),
                            Container(
                              width: 75,
                              height: 5,
                              decoration: boxBaseDecoration(bgColorDark, 30),
                            ),
                            gapHC(10),

                           Row(
                             children: [
                               Flexible(child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   tc('Client Details', Colors.black, 12),
                                   const Divider(
                                     thickness: 0.5,
                                   ),
                                   tc(fMainCompany, Colors.black, 10),
                                   tc(fMainCompanyName, Colors.black, 10),
                                   gapHC(10),
                                   Row(
                                     children: [
                                       const Icon(Icons.account_balance,color: bgColorDark,size: 12,),
                                       gapWC(10),
                                       tcn('$fCompany | $fCompanyName', Colors.black, 10)
                                     ],
                                   ),
                                   gapHC(3),
                                   Row(
                                     children: [
                                       const Icon(Icons.monitor,color: bgColorDark,size: 12,),
                                       gapWC(10),
                                       tcn("", Colors.black, 10)
                                     ],
                                   ),
                                   gapHC(3),
                                   Row(
                                     children: [
                                       const Icon(Icons.calendar_month,color: bgColorDark,size: 12,),
                                       gapWC(10),
                                       tcn(fRegDate, Colors.black, 10)
                                     ],
                                   )
                                 ],
                               )),
                               Flexible(child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   tc('Server Details', Colors.black, 12),
                                   const Divider(
                                     thickness: 0.5,
                                   ),
                                   tc(fMainCompany, Colors.black, 10),
                                   tc(fMainCompanyName, Colors.black, 10),
                                   gapHC(10),
                                   Row(
                                     children: [
                                       const Icon(Icons.important_devices,color: bgColorDark,size: 12,),
                                       gapWC(10),
                                       tcn(fMacId, Colors.black, 10)
                                     ],
                                   ),
                                   gapHC(3),
                                   Row(
                                     children: [
                                       const Icon(Icons.monitor,color: bgColorDark,size: 12,),
                                       gapWC(10),
                                       tcn(fDeviceID, Colors.black, 10)
                                     ],
                                   ),
                                   gapHC(3),
                                   Row(
                                     children: [
                                       const Icon(Icons.storage,color: bgColorDark,size: 12,),
                                       gapWC(10),
                                       tcn(fDbName, Colors.black, 10)
                                     ],
                                   )
                                 ],
                               ))
                             ],
                           ),
                            const Divider(
                              thickness: 0.5,
                            ),
                           // Row(
                           //   children: [
                           //     GestureDetector(
                           //       onTap: (){
                           //         if(mounted){
                           //           setState(() {
                           //             blDeviceLimit= !blDeviceLimit;
                           //           });
                           //         }
                           //       },
                           //       child: Container(
                           //         width: 160,
                           //         decoration: boxDecoration(Colors.white, 5),
                           //         padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                           //         child: Row(
                           //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           //           children: [
                           //             tcn('1. Set Device Limit Y/N ?', Colors.black , 10),
                           //             Container(
                           //               height: 15,
                           //               width: 15,
                           //               decoration: blDeviceLimit? boxDecoration(bgColorDark, 30):boxBaseDecoration(greyLight, 30),
                           //               child: Icon(Icons.done,color: Colors.white,size: 10,),
                           //             )
                           //           ],
                           //         ),
                           //       ),
                           //     ),
                           //     gapWC(10),
                           //     GestureDetector(
                           //       onTap: (){
                           //         if(mounted){
                           //           setState(() {
                           //             blUserLimit= !blUserLimit;
                           //           });
                           //         }
                           //       },
                           //       child: Container(
                           //         width: 160,
                           //         decoration: boxDecoration(Colors.white, 5),
                           //         padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                           //         child: Row(
                           //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           //           children: [
                           //             tcn('2. Set User Limit Y/N ?', Colors.black , 10),
                           //             Container(
                           //               height: 15,
                           //               width: 15,
                           //               decoration: blUserLimit? boxDecoration(bgColorDark, 30):boxBaseDecoration(greyLight, 30),
                           //               child: Icon(Icons.done,color: Colors.white,size: 10,),
                           //             )
                           //           ],
                           //         ),
                           //       ),
                           //     ),
                           //   ],
                           // ),
                           // gapHC(10),

                          ],
                        ),
                      ),
                      gapHC(8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxDecoration(Colors.white, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(),
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(

                                      flex: 3,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: boxBaseDecoration(bGreyLight, 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                tc('Products', Colors.black, 15),
                                                 GestureDetector(
                                                   onTap: (){
                                                        fnSelectRemoveProduct();
                                                   },
                                                   child:  tcn(blProductSelect? 'Select All' :"Clear", bgColorDark, 12),
                                                 )
                                              ],
                                            ),
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
                                                controller: txtSearchProduct,
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
                                              child: ListView.builder(
                                                itemCount: lstrProductList.length,
                                                itemBuilder:  (context, index){
                                                  var dataList  =  lstrProductList[index]??[];
                                                  var code  =  (dataList["PRODUCT_ID"]??"").toString();
                                                  var name  =  (dataList["NAME"]??"").toString();
                                                  return wProductCard(code,name);
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    gapWC(10),
                                    Flexible(
                                      flex: 7,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(),
                                            tc('Product Setup', Colors.black, 15),
                                            gapHC(5),
                                            Container(
                                              width: 75,
                                              height: 5,
                                              decoration: boxBaseDecoration(bgColorDark, 30),
                                            ),
                                            gapHC(10),
                                            Expanded(
                                              child: lstrSelectedListDet.isNotEmpty? ListView.builder(
                                                itemCount: lstrSelectedListDet.length,
                                                itemBuilder: (context,index){
                                                  var data  =  lstrSelectedListDet[index];
                                                  var code = data["CODE"]??"";
                                                  var name = data["NAME"]??"";
                                                  var aproveYn = data["APR_YN"]??"N";
                                                  var unlimited = data["UNLIMITED"]??"Y";
                                                  var count = (data["COUNT"]??"").toString();

                                                  var UaproveYn = data["U_APR_YN"]??"N";
                                                  var Uunlimited = data["U_UNLIMITED"]??"Y";
                                                  var Ucount = (data["U_COUNT"]??"").toString();


                                                  return Container(
                                                    padding:const EdgeInsets.all(5),
                                                    margin: const EdgeInsets.only(bottom: 5),
                                                    decoration: boxBaseDecoration(blueLight, 5),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [

                                                        tc(name.toString(), Colors.black, 12),
                                                        const Divider(
                                                          thickness: 0.5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.monitor,color: bgColorDark,size: 13,),
                                                            gapWC(5),
                                                            tc('Device Limit', Colors.black, 10),
                                                          ],
                                                        ),
                                                        gapHC(5),
                                                        Row(
                                                          children: [

                                                            gapWC(5),
                                                            Bounce(
                                                              onPressed: (){
                                                                var val  = aproveYn == "Y"?"N":"Y";
                                                                fnChangeProductSetup(code,val,unlimited,count,"D");
                                                              },
                                                              duration: const Duration(milliseconds: 110),
                                                              child: Container(
                                                                decoration: boxBaseDecoration(Colors.white, 5),
                                                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                child: Row(

                                                                  children: [
                                                                    tcn('Activation need all time?', Colors.black , 10),
                                                                    gapWC(10),
                                                                    Container(
                                                                      height: 15,
                                                                      width: 15,
                                                                      decoration: aproveYn == "Y"? boxDecoration(bgColorDark, 30):boxBaseDecoration(greyLight, 30),
                                                                      child: const Icon(Icons.done,color: Colors.white,size: 10,),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            gapWC(5),
                                                            Bounce(
                                                              onPressed: (){
                                                                var val  = unlimited == "Y"?"N":"Y";
                                                                fnChangeProductSetup(code,aproveYn,val,count,"D");
                                                              },
                                                              duration: const Duration(milliseconds: 110),
                                                              child: Container(
                                                                decoration: boxBaseDecoration(Colors.white, 5),
                                                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                child: Row(

                                                                  children: [
                                                                    tcn('Unlimited', Colors.black , 10),
                                                                    gapWC(10),
                                                                    Container(
                                                                      height: 15,
                                                                      width: 15,
                                                                      decoration: unlimited == "Y"? boxDecoration(bgColorDark, 30):boxBaseDecoration(greyLight, 30),
                                                                      child: const Icon(Icons.done,color: Colors.white,size: 10,),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            gapWC(5),
                                                            unlimited != "Y"?
                                                            Container(
                                                              height: 25,
                                                              width: 100,
                                                              decoration: boxBaseDecoration(Colors.white, 5),
                                                              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                              child: TextFormField(
                                                                maxLength: 4,
                                                                initialValue: count.toString(),
                                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                style: GoogleFonts.poppins(fontSize: 10,),
                                                                decoration: const InputDecoration(
                                                                   counterText: "",
                                                                    hintText: 'Limit',
                                                                    border: InputBorder.none,
                                                                ),
                                                                onChanged: (value){
                                                                  fnChangeProductSetup(code,aproveYn,unlimited,value,"D");
                                                                },
                                                              ),

                                                            ):gapHC(0),
                                                          ],
                                                        ),
                                                        gapHC(5),
                                                        Row(
                                                          children: [
                                                            const Icon(Icons.supervised_user_circle_outlined,color: bgColorDark,size: 13,),
                                                            gapWC(5),
                                                            tc('User Limit', Colors.black, 10),
                                                          ],
                                                        ),
                                                        gapHC(5),
                                                        Row(
                                                          children: [

                                                            gapWC(5),
                                                            Bounce(
                                                              onPressed: (){
                                                                var val  = UaproveYn == "Y"?"N":"Y";
                                                                fnChangeProductSetup(code,val,unlimited,count,"U");
                                                              },
                                                              duration: const Duration(milliseconds: 110),
                                                              child: Container(
                                                                decoration: boxBaseDecoration(Colors.white, 5),
                                                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                child: Row(

                                                                  children: [
                                                                    tcn('Activation need all time?', Colors.black , 10),
                                                                    gapWC(10),
                                                                    Container(
                                                                      height: 15,
                                                                      width: 15,
                                                                      decoration: UaproveYn == "Y"? boxDecoration(bgColorDark, 30):boxBaseDecoration(greyLight, 30),
                                                                      child: const Icon(Icons.done,color: Colors.white,size: 10,),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            gapWC(5),
                                                            Bounce(
                                                              onPressed: (){
                                                                var val  = Uunlimited == "Y"?"N":"Y";
                                                                fnChangeProductSetup(code,UaproveYn,val,count,"U");
                                                              },
                                                              duration: const Duration(milliseconds: 110),
                                                              child: Container(
                                                                decoration: boxBaseDecoration(Colors.white, 5),
                                                                padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                                child: Row(

                                                                  children: [
                                                                    tcn('Unlimited', Colors.black , 10),
                                                                    gapWC(10),
                                                                    Container(
                                                                      height: 15,
                                                                      width: 15,
                                                                      decoration: Uunlimited == "Y"? boxDecoration(bgColorDark, 30):boxBaseDecoration(greyLight, 30),
                                                                      child: const Icon(Icons.done,color: Colors.white,size: 10,),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            gapWC(5),
                                                            Uunlimited != "Y"?
                                                            Container(
                                                              height: 25,
                                                              width: 100,
                                                              decoration: boxBaseDecoration(Colors.white, 5),
                                                              padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                                              child: TextFormField(
                                                                maxLength: 4,
                                                                initialValue: count.toString(),
                                                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                style: GoogleFonts.poppins(fontSize: 10,),
                                                                decoration: const InputDecoration(
                                                                  counterText: "",
                                                                  hintText: 'Limit',
                                                                  border: InputBorder.none,
                                                                ),
                                                                onChanged: (value){
                                                                  fnChangeProductSetup(code,UaproveYn,Uunlimited,value,"U");
                                                                },
                                                              ),

                                                            ):gapHC(0),
                                                          ],
                                                        ),
                                                        gapHC(5),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ):Center(child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  const Icon(Icons.dashboard_customize_outlined,color: greyLight,size: 60,),
                                                  gapHC(10),
                                                  tcn('NO PRODUCT SELECTED', greyLight  , 12)
                                                ],
                                              ),),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Bounce(
                            onPressed: (){
                              fnCancel();
                            },
                            duration: const Duration(milliseconds: 110),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 5),
                              decoration: boxOutlineCustom1(Colors.white, 30, bgColorDark, 1.0),
                              child: tcn('Cancel', Colors.black, 13)  ,
                            ),
                          ),
                          gapWC(8),
                          Bounce(
                            onPressed: (){
                              apiActivate();
                            },
                            duration: const Duration(milliseconds: 110),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 6),
                              decoration: boxDecoration(bgColorDark, 30),
                              child: tcn("Activate", Colors.white, 13)  ,
                            ),
                          )
                        ],
                      )
                    ],
                  )
                  ,
                ):
                Container(
                  decoration: boxDecoration(Colors.white, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(),
                      const Icon(Icons.admin_panel_settings_rounded,color: greyLight,size: 60,),
                      gapHC(10),
                      tcn('Select pending activation', greyLight  , 12)
                    ],
                  ),
                )
              )
            ],
          ),
        )
      ],
    ));
  }

  //========================================WIDGET
    Widget wPendingCard(text){
      return Expanded(
        child: Bounce(
          onPressed: (){
            if(mounted){
              setState(() {
                lstrPendingMode = text;
              });
            }
            apiGetActivationList();
          },
          duration: const Duration(milliseconds: 110),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 0),
            decoration: lstrPendingMode == text? boxGradientDecoration(24, 5): boxBaseDecoration(Colors.black.withOpacity(0.03), 5),
            child: tcn(text,lstrPendingMode == text?Colors.white: Colors.black, 12),
          ),
        ),
      );
    }
    Widget wProductCard(code,name){
      return Bounce(
        onPressed: (){
          fnSelectProduct(code,name);
        },
        duration: const Duration(milliseconds: 110),
        child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: boxDecoration(Colors.white, 0),
          child: Row(
            children: [
              Image.asset("assets/icons/appicon.jpg",width: 25,),
              gapWC(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tc(code, Colors.black, 10),
                    tcn(name, Colors.black, 8),
                  ],
                ),
              ),
              lstrSelectedList.contains(code)?
              Container(
                width: 30,
                height: 30,
                decoration: boxBaseDecoration(bgColorDark, 30),
                child: const Icon(Icons.done,color: Colors.white,size: 12,),
              ):gapHC(0)
            ],
          ),
        ),
      );
    }
  //========================================PAGE FN

  fnSelectClient(){

    apiSearchProduct();
  }
  fnCancel(){
    fnClear();
  }
  fnClear(){
    if(mounted){
      setState(() {
        lstrSelectedClient.clear();
        lstrProductList.clear();
        lstrSelectedList.clear();
        lstrSelectedListDet.clear();
        blDeviceLimit = false;
        blUserLimit = false;
        blProductSelect = true;
        fMainCompany = "";
        fMainCompanyName = "";
        fClient = "";
        fCompany = "";
        fCompanyName = "";
        fRegDate = "";
        fMacId = "";
        fDeviceID = "";
        fDbName = "";
      });
    }
  }
  fnSelectProduct(code,name){
    if(mounted){
      setState(() {
        if(lstrSelectedList.contains(code)){
          lstrSelectedList.remove(code);

          lstrSelectedListDet.removeWhere((element) => element["CODE"] == code);
        }else{
          lstrSelectedList.add(code);
          lstrSelectedListDet.add({
            "CODE":code,
            "NAME":name,
            "UNLIMITED":"Y",
            "U_UNLIMITED":"Y",
            "COUNT":-1,
            "U_COUNT":-1,
            "APR_YN":"N",
            "U_APR_YN":"N",
          });
        }
      });
    }
  }
  fnSelectRemoveProduct(){
    if(mounted){
      setState(() {
        if(blProductSelect){
          lstrSelectedList.clear();
          lstrSelectedListDet.clear();
          for(var e in lstrProductList){
            lstrSelectedList.add(e["PRODUCT_ID"]??"");
            lstrSelectedListDet.add({
              "CODE":e["PRODUCT_ID"]??"",
              "NAME":e["NAME"]??"",
              "UNLIMITED":"Y",
              "U_UNLIMITED":"Y",
              "COUNT":-1,
              "U_COUNT":-1,
              "APR_YN":"N",
              "U_APR_YN":"N",
            });
          }
        }else{
          lstrSelectedList.clear();
          lstrSelectedListDet.clear();
        }
        blProductSelect = !blProductSelect;
      });

    }
  }
  fnChangeProductSetup(code,apr,unlimited,count,mode){
    if(mounted){
      setState(() {
        for(var e in lstrSelectedListDet){
          if(e["CODE"] == code){
            if(mode == "D"){
              e["UNLIMITED"] = unlimited;
              e["APR_YN"] = apr;
              e["COUNT"] = count;
            }else{
              e["U_UNLIMITED"] = unlimited;
              e["U_APR_YN"] = apr;
              e["U_COUNT"] = count;
            }

          }
        }
      });
    }
  }

  //========================================API CALL

  apiGetActivationList(){
    var typeList  =  [];
    var type = "";

    type = lstrPendingMode == "Client" ?"S":lstrPendingMode == "Device"?"D":lstrPendingMode == "User"?"U":"";

    typeList.add({
      "COL_VAL":type
    });

    futureForm = apiCall.apiGetPendingActivation(txtSearch.text, typeList);
    futureForm.then((value) => apiGetActivationListRes(value));
  }
  apiGetActivationListRes(value){
    if(mounted){
      setState(() {
        lstrPendingList = [] ;
        if(g.fnValCheck(value)){
          lstrPendingList = value["ACTIVATION_LIST"]??[];
        }
      });
    }
  }

  apiActivate(){
    var product = [];
    for(var e in lstrSelectedListDet){
      var count  =e["UNLIMITED"] == "Y"?-1: g.mfnInt(e["COUNT"]);
      var uCount  =e["U_UNLIMITED"] == "Y"?-1: g.mfnInt(e["U_COUNT"]);
      count = count == 0?-1:count;
      uCount = uCount ==  0?-1:uCount;
      product.add(
          {
            "PRODUCT_ID": e["CODE"],
            "COMPANY_CODE": fCompany,
            "PRODUCT_NAME": e["NAME"],
            "NO_USERS": uCount,
            "NO_DEVICES": count,
            "USER_REQUEST_YN": e["U_APR_YN"],
            "DEVICE_REQUEST_YN": e["APR_YN"]
          }
      );
    }

    if(product.isEmpty){
      errorMsg(context, "Please select product");
      return;
    }
    setState(() {
      blSave = false  ;
    });
    futureForm =  apiCall.apiActivate(fMainCompany, fClient, product);
    futureForm.then((value) => apiActivateRes(value));
  }
  apiActivateRes(value){
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
          PageDialog().showSuccess(context,"Activated",code);
          apiGetActivationList();
          fnClear();
        }else{
          //Failed
          errorMsg(context, msg.toString());
        }
      }

    }
  }

  apiSearchProduct(){
    var filterVal= [];
    filterVal  = [];
    filterVal.add({ "Column": "PRODUCT_ID", "Operator": "LIKE", "Value": txtSearchProduct.text, "JoinType": "OR" });
    filterVal.add({ "Column": "NAME", "Operator": "LIKE", "Value": txtSearchProduct.text, "JoinType": "OR" });

    futureForm = apiCall.LookupSearch("PRODUCT_MAST", "PRODUCT_ID|NAME|DESCP|LOGO|MODULE|", 0, 100, filterVal);
    futureForm.then((value) => apiSearchProductRes(value));
  }
  apiSearchProductRes(value){
    if(mounted){
      setState(() {
        lstrProductList = [];
        if(g.fnValCheck(value)){
          lstrProductList = value;
        }
      });

    }
  }


}
