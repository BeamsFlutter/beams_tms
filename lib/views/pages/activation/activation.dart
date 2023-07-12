
import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/components/inputField/form_inputfield.dart';
import 'package:bams_tms/views/pages/activation/mainClient.dart';
import 'package:bams_tms/views/pages/activation/pendinglist.dart';
import 'package:bams_tms/views/pages/activation/productStore.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Activation extends StatefulWidget {
  const Activation({Key? key}) : super(key: key);

  @override
  State<Activation> createState() => _ActivationState();
}

class _ActivationState extends State<Activation> {

  //Global
  var g = Global();
  var apiCall  = ApiCall();
  late Future<dynamic> futureForm;

  //Page Variables
  var lstrMenuHoverMode =  "H";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 180,
              padding: const EdgeInsets.all(10),
              decoration: boxDecoration(Colors.black, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  Expanded(child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: boxGradientDecoration(22, 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: tc('TM', Colors.white, 15),
                        ),
                        gapHC(30),
                        wMenuCard(Icons.account_balance_outlined,"Company","H"),
                        wMenuCard(Icons.pending,"Pending","L"),
                        wMenuCard(Icons.dashboard,"Product","P"),
                        wMenuCard(Icons.support_agent,"Support","S"),
                        wMenuCard(Icons.handshake_outlined,"Demo","D"),
                        wMenuCard(Icons.code_outlined,"Development","E"),
                      ],
                    ),
                  )),
                  gapHC(10),
                  Bounce(
                    duration: const Duration(milliseconds: 110),
                    onPressed: (){
                      Get.back();
                    },
                    child: Container(
                      decoration: boxOutlineCustom1(Colors.black, 30, greyLight.withOpacity(0.5), 1.0),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          tcn('Close', Colors.white, 12),
                          gapWC(5),
                          const Icon(Icons.cancel,color: Colors.white,size: 14,)
                        ],
                      ),
                    ),
                  ),
                  gapHC(10),
                ],
              ),
            ),
            gapWC(12),
            wCardDet()
          ],
        ),
      ),
    );
  }
  //===================================WIDGET
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

   Widget wCardDet(){
      return lstrMenuHoverMode == "H"? const MainClient():
      lstrMenuHoverMode == "P"?const ProductStore():
      lstrMenuHoverMode == "L"?const PendingList():
      Expanded(child: Container());
   }

  //===================================PAGE FN

  //===================================API CALL




}
