

import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/controller/services/apiManager.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/pages/users/usershome.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
  var blRemember =  false;

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
              decoration: boxImageDecoration("assets/images/bg.png",0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  Bounce(
                    duration: const Duration(milliseconds: 110),
                    onPressed: (){

                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: boxGradientDecoration(23, 30),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration:  boxImageDecoration("assets/gifs/logo.gif", 30),
                      ),
                    ),
                  ),
                  gapHC(10),
                  Image.asset("assets/images/namewhite.png",width: 300,),
                  //tc('BEAMS TMS', Colors.white,30),
                  ts('BEAMS TASK MANAGEMENT', Colors.white,15),
                  ts('SYSTEM', Colors.white,15),
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
                        tcn1('Username', Colors.black, 15),
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
                        tcn1('Password', Colors.black, 15),
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
                        gapHC(10),
                        Row(
                          children: [
                            Bounce(
                              onPressed: () {
                                if(mounted){
                                  setState(() {
                                    blRemember = blRemember?false:true;
                                  });
                                }
                              },
                              duration: const Duration(milliseconds: 110),
                              child: Container(
                                height: 15,
                                width: 15,
                                decoration:blRemember? boxDecoration(color2, 5): boxOutlineCustom1(Colors.white, 5, color2, 1.0),
                                child: blRemember?const Icon(Icons.done,color: Colors.white,size: 10,):gapHC(0),
                              ),
                            ),
                            gapWC(10),
                            tcn1('Remember me', color2, 10)
                          ],
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
                                    loginsts?  tcn1('Sign In', Colors.white, 15):const SpinKitThreeBounce(color: Colors.white,size: 20,),
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
                            const Icon(Icons.chat,color: Colors.green,size: 20,),
                            gapWC(10),
                            const Icon(Icons.facebook,color: Colors.blueAccent,size: 20,),
                            gapWC(10),
                            const Icon(Icons.email_outlined,color: Colors.red,size: 20,),
                            gapWC(10),
                            GestureDetector(
                                onTap: (){
                                  apiSendNotification();
                                },
                                child: const Icon(Icons.support_agent_outlined,color: Colors.grey,size: 20,)),
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
    fnCheckRememberMe();
  }
  fnLogin(){
    apiLogin();

  }
  fnLoginDone(data,mode) async{
    fnRememberMe(blRemember);
    final SharedPreferences prefs = await _prefs;
    try{
      var now = DateTime.now();
      var lstrLoginDate = setDate(9,now);

      prefs.setString('wstrUserCd', data["USER_CD"]??"");
      prefs.setString('wstrUserName', data["USER_NAME"]??"");
      prefs.setString('wstrUserRole', data["ROLE_CODE"]??"");
      prefs.setString('wstrUserRoleDescp', data["ROLE_DESCP"]??"");
      prefs.setString('wstrUserDepartment', data["DEPARTMENT_CODE"]??"");
      prefs.setString('wstrUserDepartmentDescp', data["DEPARTMENT_DESCP"]??"");
      prefs.setString('wstrLoginYn', "Y");
      prefs.setString('wstrLoginDate', lstrLoginDate);

      g.wstrLoginYn = "Y";
      g.wstrLoginDate = lstrLoginDate;
      g.wstrUserCd = data["USER_CD"]??"";
      g.wstrUserName = data["USER_NAME"]??"";
      g.wstrUserRole = data["ROLE_CODE"]??"";
      g.wstrUserRoleDescp = data["ROLE_DESCP"]??"";
      g.wstrUserDepartment = data["DEPARTMENT_CODE"]??"";
      g.wstrUserDepartmentDescp = data["DEPARTMENT_DESCP"]??"";


      fnGoHome();

    }catch(e){
      dprint(e);
    }

  }
  fnGoHome(){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>  const UserHome()
    ));
  }

  fnRememberMe(sts) async{
    final SharedPreferences prefs = await _prefs;
    if(sts){
      prefs.setString('remember', "Y");
      prefs.setString('rUserName', txtUserName.text);
      prefs.setString('rPassword', txtPassword.text);
    }else{
      prefs.setString('remember', "N");
      prefs.setString('rUserName', "");
      prefs.setString('rPassword', "");
    }
  }

  fnCheckRememberMe() async{
    final SharedPreferences prefs = await _prefs;
    if(mounted){
      setState(() {
        blRemember = prefs.getString("remember").toString() == "Y"?true:false;
        if(blRemember){
          var username  =  prefs.getString("rUserName").toString();
          var password  =  prefs.getString("rPassword").toString();
          txtUserName.text = username;
          txtPassword.text = password;
        }
      });
    }
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

  }

  apiLogin(){
    if(mounted){
      setState((){
        loginsts = false;
      });
    }
    futureLogin = apiCall.apiUserLogin(txtUserName.text.toString(), txtPassword.text.toString());
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

  apiSendNotification(){
    var token  =  "dWwFD_RHQumyim21vhIR-I:APA91bEl5TH4s1fHEa5Ba4-9dtv8tXme5wgsLPLzUhPDO3r8M6J1Hsm2FlzaXYpG3rgMDwsMVDAb1vEUkxQxJ30-n4mPmrIYydlccpAbA3M4dzZrcIJ1cfnZMXSPUslDSMku_W1TO6Da";
    futureForm  =  ApiManager().sendNotificationToUser(token);
    futureForm.then((value) => apiSendNotificationRes(value));
  }
  apiSendNotificationRes(value){
      dprint(value);
  }

}
