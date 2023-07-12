

import 'dart:async';
import 'dart:io';

import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiController.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/pages/login/client_login.dart';
import 'package:bams_tms/views/pages/login/login.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var appMode  = "U"; //C-- CLIENT , U-- Uuse

  //Global
  Global g = Global();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<dynamic> futureForm;

  //Page variables
  var deviceId = '';
  var deviceName = '';
  var deviceIp = '';
  var deviceMode ='';



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: boxGradientDecoration(24, 0),
        child: Container(
          decoration: boxImageDecoration("assets/images/bg.png",0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              Expanded(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  //ts('V 1.0', Colors.white,8),
                ],
              )),
              tcn('BEAMS 2023', Colors.white.withOpacity(0.1),13),
               gapHC(20)
               //tcu('BEAMS TICKET ', GoogleFonts.poppins(color: Colors.white,fontSize: 25))
            ],
          ),
        ),
      ),
    );
  }
  //==================================WIDGET

  //==================================PAGE_FN

  fnGetPageData(){
    initPlatformState();
    fnDefaultPageSettings();
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }
  route() async{
    if(appMode == "U"){
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const LoginScreen()
      ));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const ClientLogin()
      ));
    }
  }
  fnDefaultPageSettings() async{
    final SharedPreferences prefs = await _prefs;
    g.wstrVersionName = "V 1.0";
    g.wstrBaseUrl =  "http://beamsdts-001-site1.atempurl.com/api/";
    //g.wstrBaseUrl =  "http://laptop-vi4dgus9:1111";

    prefs.setString("wstrDeviceId", deviceId);
    prefs.setString("wstrVersionName",  g.wstrVersionName);
    prefs.setString("wstrDeviceName", deviceName);
    prefs.setString("wstrDeviceIP", deviceIp);
  }

  //==================================APICALL


  //==================================SYSTEM INFO

  Future<void> initPlatformState() async {

    var deviceData = <String, dynamic>{};
    try {

      if (kIsWeb) {
        _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);

      } else {
        if (Platform.isAndroid) {
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;
    g.wstrDeviceName = deviceName;
    g.wstrDeivceId = deviceId;
    g.wstrDeviceIP = deviceIp;

  }
  _readAndroidBuildData(AndroidDeviceInfo build) {

    setState(() {
      deviceMode = '';
      deviceId = build.id??'';
      deviceName =  build.model??'';
    });

  }
  _readIosDeviceInfo(IosDeviceInfo data) {

    setState(() {
      deviceMode = '';
      deviceId = data.name??'';
      deviceName =  data.systemName??'';
    });

  }
  _readLinuxDeviceInfo(LinuxDeviceInfo data) {

  }
  _readWebBrowserInfo(WebBrowserInfo data)  {

    setState(() {
      deviceMode = 'W';
      deviceId = describeEnum(data.browserName);
      deviceName =  describeEnum(data.browserName);
    });


  }
  _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    setState(() {
      deviceMode = '';
      deviceId = data.systemGUID??'';
      deviceName =  data.computerName;
    });
  }
  _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    setState(() {
      deviceMode = '';
      deviceId = data.computerName;
      deviceName =  data.computerName;
    });
  }
}
