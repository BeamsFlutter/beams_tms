import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/pages/login/client_login.dart';
import 'package:bams_tms/views/pages/splashscreen/splashscreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  String myurl = Uri.base.toString(); //get complete url
  String para1 = Uri.base.queryParameters["K"]??"";
  dprint("***********************************");
  dprint(myurl);
  dprint(para1);
  Global().wstrLKey =para1;
  dprint("***********************************");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return  const GetMaterialApp(
      title: 'Bits TMS',
      debugShowCheckedModeBanner: false,
      home:  SplashScreen(),
      //home:  SplashScreen(),
    );
  }
}


class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}
