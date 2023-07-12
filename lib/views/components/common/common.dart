
import 'package:bams_tms/main.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';


//===========================================================Text Styles

Text th(text,color,double size) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontWeight: FontWeight.bold,fontSize: size,color: color),);
Text ts(text,color,double size) => Text(text,style: TextStyle(fontFamily: 'Roboto',fontSize: size,color: color),);

Text tcn(text,color,double size) => Text(text,style: GoogleFonts.poppins(fontSize: size,color: color));
Text tcnL(text,color,double size) => Text(text,style: GoogleFonts.poppins(fontSize: size,color: color),maxLines: 100,);
Text tc(text,color,double size) => Text(text,style: GoogleFonts.beVietnamPro(fontSize: size,color: color,fontWeight: FontWeight.bold));
Text thL(text,color,double size) => Text(text,style: GoogleFonts.poppins(fontSize: size,color: color,fontWeight: FontWeight.bold),maxLines: 100,);

Text tc1(text,color,double size) => Text(text,style: GoogleFonts.beVietnamPro(fontSize: size,color: color,fontWeight: FontWeight.bold));
Text tcn1(text,color,double size) => Text(text,style: GoogleFonts.poppins(fontSize: size,color: color));

SelectableText stc(text,color,double size) => SelectableText(text,style: GoogleFonts.beVietnamPro(fontSize: size,color: color,fontWeight: FontWeight.bold));
SelectableText stcn(text,color,double size) => SelectableText(text,style: GoogleFonts.poppins(fontSize: size,color: color));


//Strike Line
Text tcns(text,color,double size) => Text(text,style: GoogleFonts.poppins(fontSize: size,color: color,decoration: TextDecoration.lineThrough));
Text tcs(text,color,double size) => Text(text,style: GoogleFonts.beVietnamPro(fontSize: size,color: color,fontWeight: FontWeight.bold,decoration: TextDecoration.lineThrough));

Text tcu(text, style) => Text(text,style: style);

//===========================================================Box Decorations

BoxDecoration boxDecoration(color,double radius) => BoxDecoration(
color: color,
boxShadow: [
    BoxShadow(
    color: Colors.blueAccent.withOpacity(0.2),
    blurRadius: 8,
    spreadRadius: 1,
    offset: Offset(4, 4),
    ),
    ],
    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxDecorationC(color,double tl,double tr,double bl,double br,) => BoxDecoration(
    color: color,
    boxShadow: [
        BoxShadow(
            color: Colors.blueAccent.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
        ),
    ],
    borderRadius: BorderRadius.only(topLeft:Radius.circular(tl),topRight:Radius.circular(tr),bottomLeft:Radius.circular(bl),bottomRight:Radius.circular(br)),

);
BoxDecoration boxBaseDecorationC(color,double tl,double tr,double bl,double br,) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.only(topLeft:Radius.circular(tl),topRight:Radius.circular(tr),bottomLeft:Radius.circular(bl),bottomRight:Radius.circular(br)),

);
BoxDecoration boxBaseDecoration(color,double radius) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxGradientDecoration(gradientNum,double radius) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
    ),
    boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
        ),
    ],
    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxGradientDecorationS(gradientNum,double radius) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
    ),
    boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
        ),
    ],
    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxGradientDecorationC(gradientNum,double tl,double tr,double bl,double br,) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
    ),
    boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
        ),
    ],
    borderRadius: BorderRadius.only(topLeft:Radius.circular(tl),topRight:Radius.circular(tr),bottomLeft:Radius.circular(bl),bottomRight:Radius.circular(br)),
);
BoxDecoration boxGradientDecorationBaseC(gradientNum,double tl,double tr,double bl,double br,) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.only(topLeft:Radius.circular(tl),topRight:Radius.circular(tr),bottomLeft:Radius.circular(bl),bottomRight:Radius.circular(br)),
);
BoxDecoration boxGradientDecorationBase(gradientNum,double radius) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
    ),

    borderRadius: BorderRadius.all(Radius.circular(radius)),
);
BoxDecoration boxGradientMainDecoration(gradientNum,double radius) => BoxDecoration(

    gradient: LinearGradient(
        colors: GradientTemplate
            .gradientTemplate[gradientNum].colors,
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
    ),
    boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(4, 4),
        ),
    ],
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(radius),bottomLeft: Radius.circular(radius)),
);
BoxDecoration boxOutlineDecoration(color,double radius) => BoxDecoration(
    color: color,
    boxShadow: [

    ],
    border: Border.all(
        color: Colors.black87,width: 2.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius)),


);
BoxDecoration boxOutlineCustom(color,double radius,borderColor) => BoxDecoration(
    color: color,
    border: Border.all(
        color: borderColor,width: 1.0,
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius)),


);
BoxDecoration boxOutlineCustom1(color,double radius,borderColor,width) => BoxDecoration(
    color: color,
    border: Border.all(
        color: borderColor,width: width,
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius)),


);
BoxDecoration boxOutlineInput(enablests,focusSts) => BoxDecoration(
    color: enablests?Colors.white:greyLight.withOpacity(0.5),
    border: Border.all(
        color:enablests? (focusSts?bgColor: Colors.black.withOpacity(0.5)):Colors.grey.withOpacity(0.5),width: 0.9,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(5)),


);
BoxDecoration boxImageDecoration(img,double radius) => BoxDecoration(
    image: DecorationImage(
        image: AssetImage(img),
        fit: BoxFit.cover
    ),
    borderRadius: BorderRadius.all(Radius.circular(radius))
);
BoxDecoration boxImageDecorationC(img,double tl,double tr,double bl,double br,) => BoxDecoration(
    image: DecorationImage(
        image: AssetImage(img),
        fit: BoxFit.cover
    ),
    borderRadius: BorderRadius.only(topLeft:Radius.circular(tl),topRight:Radius.circular(tr),bottomLeft:Radius.circular(bl),bottomRight:Radius.circular(br)),
);

//===========================================================AppBar

AppBar navigationAppBar(context,fnPageBack) => AppBar(
    backgroundColor: Colors.white12,
    elevation: 0,
    leading: Container(
        margin: EdgeInsets.only(left:10),
        child: InkWell(
            onTap: (){
                fnPageBack();
            },
            child: Icon(Icons.arrow_back,color: Colors.black,size: 25,),
        ),
    ),
    actions: [
        Container(

        )

    ],
);
AppBar navigationTitleAppBar(context,title,fnPageBack) => AppBar(
    backgroundColor: Colors.white12,
    elevation: 0,
    leading: Container(
        margin: EdgeInsets.only(left:10),
        child: InkWell(
            onTap: (){
                fnPageBack();
            },
            child: Icon(Icons.arrow_back,color: Colors.black,size: 25,),
        ),
    ),
    title: tc(title,Colors.black,25),
    actions: [
        Container(

        )

    ],
);

//===========================================================margin

EdgeInsets pageMargin() =>  const EdgeInsets.only(left: 25,right: 20,top: 0,bottom:0);
EdgeInsets gapMargin() =>  const EdgeInsets.only(left: 5,right: 5,top: 0,bottom:0);

//===========================================================padding

EdgeInsets pagePadding() =>  const EdgeInsets.all(10);

//===========================================================gap

SizedBox gapH() => const SizedBox(height: 20,);
SizedBox gapHC(double h) => SizedBox(height: h,);
SizedBox gapW() => const SizedBox(width: 20,);
SizedBox gapWC(double w) => SizedBox(width: w,);


//===========================================================Screen

Scaffold pageScreen(child,Size size,context,fnPageBack) => Scaffold(
    appBar: navigationAppBar(context,fnPageBack),
    body: SafeArea(
        child: Container(
            height: size.height,
            width: size.width,
            padding: pagePadding(),
            margin: pageMargin(),
            child: SingleChildScrollView(
                child: child,
            ),
        ),
    ),
);
Scaffold pageMenuScreen(child,Size size,context,bottom,fnPageBack) => Scaffold(
    appBar: navigationAppBar(context,fnPageBack),
    bottomNavigationBar: bottom,
    body: SafeArea(
        child: Container(
            height: size.height,
            width: size.width,
            padding: pagePadding(),
            margin: pageMargin(),
            child: SingleChildScrollView(
                child: child,
            ),
        ),
    ),
);

//===========================================================Row

Row clockRow(text) => Row(
    children: [
        const Icon(Icons.access_time_rounded, size: 15,),
        gapWC(5),
        tcn(text, Colors.black, 15)
    ],
);

//===========================================================Line

Container line() => Container(
    height: 1,
    decoration: boxBaseDecoration(Colors.grey, 1),
);
Container lineC(h,color) => Container(
    height: h,
    decoration: boxBaseDecoration(color, 1),
);
Widget lineS(){
    return Column(
        children: [
            gapHC(10),
            lineC(1.0, greyLight),
            gapHC(10),
        ],
    );
}
Widget lineSC(height){
    return Column(
        children: [
            gapHC(height),
            lineC(1.0, greyLight),
            gapHC(height),
        ],
    );
}

//===========================================================Animation

Bounce bnc(child){
    return Bounce(child: child, duration: const Duration(milliseconds: 110), onPressed: (){});
}
AnimationLimiter animColumn(children) => AnimationLimiter(child:
Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: AnimationConfiguration.toStaggeredList(
        duration: const Duration(milliseconds: 200),
        childAnimationBuilder: (widget) => ScaleAnimation(
            child: FadeInAnimation(child: widget),
        ),
        children: children,
    ),
)
);

//===========================================================MASTER MENU
Widget masterMenu(fnCallBack,mode){
    return ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end  ,
            children: [
                menuCard(Icons.add,fnCallBack,"ADD",mode == "VIEW"?true:false),
                menuCard(Icons.save,fnCallBack,"SAVE",mode != "VIEW"?true:false),
                menuCard(Icons.edit,fnCallBack,"EDIT",mode == "VIEW"?true:false ),
                menuCard(Icons.first_page,fnCallBack,"FIRST",mode == "VIEW"?true:false),
                menuCard(Icons.navigate_before_sharp,fnCallBack,"BACK",mode == "VIEW"?true:false),
                menuCard(Icons.navigate_next_sharp,fnCallBack,"NEXT",mode == "VIEW"?true:false),
                menuCard(Icons.last_page_outlined,fnCallBack,"LAST",mode == "VIEW"?true:false),
                menuCard(Icons.attach_file,fnCallBack,"ATTACH",mode == "VIEW"?true:false),
                menuCard(Icons.delete_sweep_outlined,fnCallBack,"DELETE",mode == "VIEW"?true:false),
                menuCard(Icons.access_time_sharp,fnCallBack,"LOG",mode == "VIEW"?true:false),
                menuCard(Icons.help,fnCallBack,"HELP",true),
                menuCard(Icons.cancel,fnCallBack,"CLOSE",mode != "VIEW"?true:false),


            ],
        ),
    ));
}
Widget menuCard(icon,fnCallBack,mode,pagemode){
    return Bounce(
        duration: const Duration(milliseconds: 110),
        onPressed: (){
            if(pagemode){
                fnCallBack(mode);
            }
        },
        child:  Container(
            margin: EdgeInsets.only(right: 10),
            height: 30,
            width: 50,
            decoration: boxDecoration(Colors.white, 5),
            child: Center(
                child: Icon(icon,size: 18,color: pagemode? bgColorDark :  greyLight,),
            ),
        ),);
}

//===========================================================Form Input

Widget formInput(controller,hint,width,height,errormsg,validate){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            tcn(hint, bgColorDark, 12),
            gapHC(2),
            Container(
                height:height?? 45,
                width:width?? 300,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: boxBaseDecoration(greyLight, 5),
                child: TextFormField(
                    controller: controller,
                    decoration:  InputDecoration(
                        hintText:hint,
                        border: InputBorder.none,
                        suffixIcon: GestureDetector(
                            onTap: (){
                                controller.text.clear();
                            },
                            child: Icon(Icons.cancel_outlined,size: 20,color: Colors.grey.withOpacity(0.7),),
                        ),
                    ),
                    validator: (value) {
                        if(validate){
                            if (value == null || value.isEmpty) {
                                return errormsg;
                            }
                        }
                        return null;
                    },
                ),
            ),
        ],
    );
}

//============================================================Buttons

Widget closeButton(){
    return Container(
        height: 35,
        width: 100,
        decoration: boxDecoration(bgColorDark, 30),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(Icons.close,color: Colors.white,size: 15,),
                gapWC(5),
                tcn('CANCEL', Colors.white  , 12)
            ],
        ),
    );
}

Widget saveButton(){
    return Container(
        height: 35,
        width: 150,
        decoration: boxDecoration(subColor, 30),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(Icons.save,color: Colors.white,size: 15,),
                gapWC(5),
                tcn('SAVE', Colors.white, 12)
            ],
        ),
    );
}

Widget holdButton(){
    return Container(
        height: 35,
        width: 100,
        decoration: boxDecoration(bgColorDark, 30),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                const Icon(Icons.pending_outlined,color: Colors.white,size: 15,),
                gapWC(5),
                tcn('HOLD', Colors.white, 12)
            ],
        ),
    );
}

Widget customBButton(title,bgcolor,forcolor,icon){
    return Container(
        height: 35,
        decoration: boxDecoration(bgcolor, 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(icon,color: forcolor,size: 15,),
                gapWC(5),
                tcn(title, forcolor, 12)
            ],
        ),
    );
}
Widget customBButtonFlat(title,bgcolor,forcolor,icon){
    return Container(
        height: 35,
        decoration: boxBaseDecoration(bgcolor, 30),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Icon(icon,color: forcolor,size: 15,),
                gapWC(5),
                tcn(title, forcolor, 12)
            ],
        ),
    );
}

//============================================================Message

errorMsg(context,msg){
   PageDialog().showMessage(context, msg,"CLOSE","E","");
}

successMsg(context,msg){
    PageDialog().showMessage(context, msg,"CLOSE","S","");
}

warningMsg(context,msg){
    PageDialog().showMessage(context, msg,"CLOSE","W","");
}

infoMsg(context,msg){
    PageDialog().showMessage(context, msg,"CLOSE","I","");
}

customMsg(context,msg,icon){
    PageDialog().showMessage(context, msg,"CLOSE","C",icon);
}

msgBox(context,msg,mode,icon){
    PageDialog().showMessage(context, msg,"",mode,icon);
}


//=============================================================IMAGE CARD

Widget imageCard(img,context){
    return Bounce(
        onPressed: (){
            _launchUrl(img);
        },
        duration: const Duration(milliseconds: 110),
        child: Container(
            padding:const EdgeInsets.all(5),
            decoration: boxDecoration(Colors.white, 10),
            child:Column(
                children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                            Icon(Icons.cancel_outlined,color: bgColorDark,size: 15,)
                        ],
                    ),
                    Container(
                        decoration: boxBaseDecoration(blueLight, 10),
                        padding: EdgeInsets.all(5),
                        height: 100,
                        width: 150,
                        child: Image.network(img,
                            errorBuilder: (context,  exception,  stackTrace) {
                                return const Icon(Icons.sticky_note_2,color: greyLight,size: 70,);
                            },
                        ),
                    )
                ],
            ),
        ),
    );
}


//================================================================INTENT

class fnAddIntent extends Intent {
    const fnAddIntent();
}

class fnSaveIntent extends Intent {
    const fnSaveIntent();
}

class fnDeleteIntent extends Intent {
    const fnDeleteIntent();
}

class fnCommonIntent extends Intent {
    const fnCommonIntent();
}
class fnMenuIntent1 extends Intent {
    const fnMenuIntent1();
}


class fnNavL extends Intent {
    const fnNavL();
}

class fnNavR extends Intent {
    const fnNavR();
}

class fnNavB extends Intent {
    const fnNavB();
}

class fnNavF extends Intent {
    const fnNavF();
}

//================================================================RADIO

Widget radioSet(value,lstrTypeRadio,fnChangeType,title){
        final String a =  value.toString();
        return Row(
            children: [
                Transform.scale(
                    scale: 0.8,
                    child: Radio(
                        value: a,
                        groupValue: lstrTypeRadio,
                        fillColor: MaterialStateColor.resolveWith((states) => subColor),
                        onChanged: (value){
                            fnChangeType(value);
                        }),
                ),
                GestureDetector(
                    onTap: (){
                        fnChangeType(value);
                    },
                    child: tcn(title, bgColorDark, 13),
                )
            ],
        );
}


//====================================================================SubHead

Widget subHead(name){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            gapHC(10),
            lineC(1.0, greyLight),
            gapHC(5),
            tcn(name, subColor, 14),
            gapHC(5),
            lineC(1.0, greyLight),
            gapHC(10),
        ],
    );
}


//======================================================================Date

    setDate(mode,DateTime date){
        var dateRtn  = "";
        var formatDate1 = DateFormat('yyyy-MM-dd hh:mm:ss');
        var formatDate2 = DateFormat('yyyy-MM-dd');
        var formatDate3 = DateFormat('yyyy-MM-dd hh:mm');
        var formatDate4 = DateFormat('yyyy-MM-dd hh:mm:ss a');
        var formatDate5 = DateFormat('hh:mm:ss a');
        var formatDate6 = DateFormat('dd-MM-yyyy');
        var formatDate7 = DateFormat('dd-MM-yyyy hh:mm:ss a');
        var formatDate8 = DateFormat('dd-MM-yyyy hh:mm:ss');
        var formatDate9 = DateFormat('dd-MM-yyyy hh:mm');
        var formatDate10 = DateFormat('hh:mm:ss');
        var formatDate11 = DateFormat('hh:mm a');
        var formatDate12 = DateFormat('yyyy-MM-dd');
        var formatDate13 = DateFormat('dd-MMM-yyyy');
        var formatDate14 = DateFormat('MMMM');
        var formatDate15 = DateFormat('dd MMM yyyy');

        try{
            switch(mode){
                case 1:{
                    dateRtn =  formatDate1.format(date);
                }
                break;
                case 2:{
                    dateRtn =  formatDate2.format(date);
                }
                break;
                case 3:{
                    dateRtn =  formatDate3.format(date);
                }
                break;
                case 4:{
                    dateRtn =  formatDate4.format(date);
                }
                break;
                case 5:{
                    dateRtn =  formatDate5.format(date);
                }
                break;
                case 6:{
                    dateRtn =  formatDate6.format(date);
                }
                break;
                case 7:{
                    dateRtn =  formatDate7.format(date);
                }
                break;
                case 8:{
                    dateRtn =  formatDate8.format(date);
                }
                break;
                case 9:{
                    dateRtn =  formatDate9.format(date);
                }
                break;
                case 10:{
                    dateRtn =  formatDate10.format(date);
                }
                break;
                case 11:{
                    dateRtn =  formatDate11.format(date);
                }
                break;
                case 12:{
                    dateRtn =  formatDate12.format(date);
                }
                break;
                case 13:{
                    dateRtn =  formatDate13.format(date);
                }
                break;
                case 14:{
                    dateRtn =  formatDate14.format(date);
                }
                break;
                case 15:{
                    dateRtn =  formatDate15.format(date);
                }
                break;
                default: {
                    //statements;
                }
                break;

            }



        }catch(e){
            if (kDebugMode) {
              print(e);
            }
        }

        return dateRtn;

    }

//================================================== TUTORIAL

void createTutorial(tutorialCoachMark,targets) {
    tutorialCoachMark = TutorialCoachMark(
        targets: targets,
        colorShadow: Colors.red,
        textSkip: "SKIP",
        paddingFocus: 10,
        opacityShadow: 0.8,
        onFinish: () {
            print("finish");
        },
        onClickTarget: (target) {
            print('onClickTarget: $target');
        },
        onClickTargetWithTapPosition: (target, tapDetails) {
            print("target: $target");
            print(
                "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
        },
        onClickOverlay: (target) {
            print('onClickOverlay: $target');
        },
        onSkip: () {
            print("skip");
        },
    );
}
//================================================== SetState

extension StateExt on State {
    void safeState(VoidCallback call) {
        if (mounted) {
            // ignore: invalid_use_of_protected_member
            setState(call);
        }
    }
}
//================================================== OPEN URL
Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
        throw 'Could not launch $_url';
    }
}

//================================================== OPEN URL
dprint(msg){
    if (kDebugMode) {
      print(msg);
    }
}

//================================================== VALUE ASSIGN'

mfnAssign(value){
    var v  =  [];
    try{
        v = value;
    }catch(e){
        v = [];
    }
    return v;
}

//================================================== TextInputFormatter

List<TextInputFormatter> mfnInputFormatters(){
    List<TextInputFormatter> inputFormatters = [];
    inputFormatters.add(FilteringTextInputFormatter.digitsOnly);

    return inputFormatters;
}
List<TextInputFormatter> mfnInputDecFormatters(){
    List<TextInputFormatter> inputFormatters = [];
    inputFormatters.add(FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')));

    return inputFormatters;
}

//
// fnScreenClose(context){
//     var _alertShowing = false;
//     var _index = 0;
//     FlutterWindowClose.setWindowShouldCloseHandler(() async {
//         if (_index == 0) {
//             if (_alertShowing) return false;
//             _alertShowing = true;
//
//             return await showDialog(
//                 context: context,
//                 builder: (context) {
//                     return AlertDialog(
//                         title: tcn('Do you really want to quit?', Colors.black, 12),
//                         actions: [
//                             Container(
//                                 width : 80,
//                                 height: 35,
//                                 decoration: boxBaseDecoration(color2, 30),
//                                 child:TextButton(
//                                     onPressed: () async {
//                                         Navigator.of(context).pop(true);
//                                         _alertShowing = false;
//                                     } ,
//                                     child: tc('YES', Colors.white, 12),
//                                 ) ,
//                             ),
//                             gapWC(3),
//                             Container(
//                                 width : 80,
//                                 height:35,
//                                 decoration: boxOutlineCustom1(Colors.white, 30, Colors.blueGrey  , 1.0),
//                                 child:  TextButton(
//                                     onPressed: () {
//                                         Navigator.of(context).pop(false);
//                                         _alertShowing = false;
//                                     },
//                                     child: tc('NO', Colors.blueGrey, 12),
//                                 ),
//                             ),
//
//
//                         ]);
//                 });
//         }
//         return true;
//     });
// }