

import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/controller/services/apiManager.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/components/resposive/responsive_helper.dart';
import 'package:bams_tms/views/pages/client/clienthome.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientLogin extends StatefulWidget {
  const ClientLogin({Key? key}) : super(key: key);

  @override
  State<ClientLogin> createState() => _ClientLoginState();
}

class _ClientLoginState extends State<ClientLogin> {

  //Global
  Global g = Global();
  var apiCall  = ApiCall();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<dynamic> futureToken;
  late Future<dynamic> futureCompany;
  late Future<dynamic> futureLogin;
  late Future<dynamic> futureForm;

  //Page Variables
  var lstrErrorMsg = "";
  var loginsts = true;

  //Controller
  var txtUserName  = TextEditingController();
  var fnUserName =  FocusNode();

  var txtPassword  = TextEditingController();
  var fnPassword =  FocusNode();
  var passWordView = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          wWindows()
          
        ],
      ),
    );
  }
  //=====================================WIDGET
  Widget wWindows(){
    return Expanded(child: Row(
      children: [
        Flexible(
        flex: 7,
        child: Container(
          //decoration: boxImageDecoration("assets/images/loginbg.png", 0),
          decoration: boxGradientDecoration(24, 0),
          child: Container(
                decoration: boxBaseDecoration(color2.withOpacity(0.0), 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(),
                    tc('2023', Colors.white.withOpacity(0.2  ), 250)
                  ],
                ),
              ),
        ),),
        Flexible(
            flex: 3,
            child:
            Container(
              padding: const EdgeInsets.all(10),
              decoration: boxDecoration(Colors.white, 0),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  gapHC(10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: boxImageDecoration("assets/icons/tmlogo.png", 20),
                        ),
                        gapHC(10),
                        Image.asset("assets/images/nameblack.png",width: 200,),

                        tcn('Ticket management system from Beams', Colors.grey  , 15),
                        tcn('Please sign-in to your account and continue to the dashboard.', Colors.grey  , 15),
                        gapHC(30),
                        tcn(lstrErrorMsg, subColor, 12),
                        gapHC(5),
                        tcn('Username', Colors.black, 15),
                        gapHC(5),
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: boxOutlineCustom1(Colors.white, 10, Colors.grey, 0.5),
                          child: TextFormField(
                            controller: txtUserName,
                            focusNode: fnUserName,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        gapHC(10),
                        tcn('Password', Colors.black, 15),
                        gapHC(5),
                        Container(
                          height: 45,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: boxOutlineCustom1(Colors.white, 10, Colors.grey, 0.5),
                          child: TextFormField(
                            controller: txtPassword,
                            obscureText: passWordView,
                            keyboardType: TextInputType.visiblePassword,
                            decoration:  InputDecoration(
                                hintText: 'Password',
                                border: InputBorder.none,
                                suffixIcon: InkWell(
                                  onTap: (){
                                    setState(() {
                                      passWordView =  passWordView? false:true;
                                    });
                                  },
                                  child: passWordView? const Icon(Icons.lock, color: Colors.grey,):const Icon(Icons.lock_open, color: Colors.grey,),
                                )
                            ),

                          ),
                        ),

                        gapHC(20),
                        Bounce(
                          duration: const  Duration(milliseconds: 110),
                          onPressed: (){
                            fnLogin();
                          },
                          child: Container(
                            decoration: boxDecoration(color2, 10),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    loginsts?  tcn('Sign In', Colors.white, 15):const SpinKitThreeBounce(color: Colors.white,size: 20,),
                                    gapWC(5),
                                    const Icon(Icons.arrow_forward_sharp,color: Colors.white,size: 15,)
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        gapHC(30),
                        lineC(1.0, greyLight),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.message,color: Colors.green,size: 20,),
                            gapWC(10),
                            const Icon(Icons.facebook,color: Colors.blueAccent,size: 20,),
                            gapWC(10),
                            const Icon(Icons.email_outlined,color: Colors.red,size: 20,),
                            gapWC(10),
                            const Icon(Icons.support_agent_outlined,color: Colors.grey,size: 20,),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ))
      ],
    ));
  }
  //=====================================PAGE FN
  fnGetPageData(){
    apiGetToken();
  }
  fnLogin(){
    apiLogin();

  }
  fnLoginDone(data,mode) async{
    final SharedPreferences prefs = await _prefs;
    try{
      var now = DateTime.now();
      var lstrLoginDate = setDate(9,now);



      prefs.setString('wstrUserCd', data["USERNAME"]??"");
      prefs.setString('wstrUserName', data["USERNAME"]??"");
      prefs.setString('wstrLoginYn', "Y");
      prefs.setString('wstrLoginDate', lstrLoginDate);


      g.wstrLoginYn = "Y";
      g.wstrLoginDate = lstrLoginDate;
      g.wstrUserCd = data["USERNAME"]??"";
      g.wstrUserName = data["USERNAME"]??"";

      var mainClient  = data["MAIN_CLIENT"]??[];
      var client  = data["CLIENT_DETAIL"]??[];

      if(g.fnValCheck(mainClient)){
        g.wstrMainClientId = mainClient[0]["MAIN_CLIENT_ID"]??"";
        g.wstrMainClientName = mainClient[0]["MAIN_COMPANY_NAME"]??"";
      }

      if(g.fnValCheck(client)){
        g.wstrClientId =  client[0]["CLIENT_ID"]??"";
        g.wstrClientName =   client[0]["MAIN_COMPANY_NAME"]??"";
      }

      //From Link
      g.wstrFromLink = "N";
      g.wstrLModule =  "";
      g.wstrLCompanyCode =  "";
      g.wstrLCompanyName =  "";
      g.wstrLCompanyID =  "";
      g.wstrLUserCd =  "";
      g.wstrLKey = "";
      if(mode == "L"){
        g.wstrFromLink = "Y";
        var loginData  =data["LOGINDATA"];
        if(g.fnValCheck(loginData)){
          g.wstrUserCd = loginData[0]["USERNAME"]??"";
          g.wstrUserName = loginData[0]["USERNAME"]??"";
          g.wstrLModule =  loginData[0]["MODULE"]??"";
          g.wstrLCompanyCode =  loginData[0]["COMPANY_CODE"]??"";
          g.wstrLCompanyName =   g.wstrClientName;
          g.wstrLCompanyID =  loginData[0]["CLIENT_ID"]??"";
          g.wstrLKey = "";
        }

      }

      fnGoHome();

    }catch(e){
      dprint(e);
    }

  }
  fnGoHome(){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>  const ClientHome()
    ));
  }

  //======================================API CALL

  apiGetToken(){
    futureToken =  ApiManager().mfnGetToken();
    futureToken.then((value) => apiGetTokenRes(value));
  }
  apiGetTokenRes(value) async{
    final SharedPreferences prefs = await _prefs;
    prefs.setString('wstrToken', value["access_token"]);
    g.wstrToken =  value["access_token"];
    dprint(g.wstrToken.toString());
    apiGetCompany();
  }

  apiGetCompany(){
    futureCompany =  apiCall.apiGetCompany();
    futureCompany.then((value) => apiGetCompanyRes(value));
  }
  apiGetCompanyRes(value) async{
    final SharedPreferences prefs = await _prefs;
    if(g.fnValCheck(value)){
      prefs.setString('wstrCompany', value["COMPANY"]);
      prefs.setString('wstrYearcode', value["YEARCODE"]);
      g.wstrCompany = value["COMPANY"]??"00";
      g.wstrYearcode = value["YEARCODE"]??"00";
    }

    if(kIsWeb){
      //GET URL PARA
      if(g.wstrLKey.isNotEmpty){
        apiClientDirectLogin(g.wstrLKey);
      }
    }

  }

  apiClientDirectLogin(key){
    futureForm =  ApiCall().apiClientDirectLogin(key);
    futureForm.then((value) => apiLoginRes(value,"L"));
  }

  apiLogin(){
    if(mounted){
      setState((){
        loginsts = false;
      });
    }
    futureLogin = apiCall.apiClientLogin(txtUserName.text.toString(), txtPassword.text.toString());
    futureLogin.then((value) => apiLoginRes(value,""));
  }
  apiLoginRes(value,mode){
    if(mounted){
      setState((){
        loginsts = true;
      });
    }


    if(g.fnValCheck(value)){
      var sts  =  value["STATUS"];
      var msg  =  value["MSG"]??"";
      if(sts == "1"){
        var data =  value["DATA"];
        if(g.fnValCheck(data)){


          fnLoginDone(data,mode);
        }
      }


      if(mounted){
        setState((){
          lstrErrorMsg = msg;
        });
      }

    }else{
      if(mounted){
        setState((){
          lstrErrorMsg = "Please try again";
        });
      }
    }
  }



  
}
