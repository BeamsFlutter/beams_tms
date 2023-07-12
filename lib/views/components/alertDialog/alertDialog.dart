

import 'package:bams_tms/views/components/messageBox/message_box.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';

import '../common/common.dart';

class PageDialog{
  Future<void> show(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.5,
                height: size.height*0.63,
                decoration: boxDecoration(Colors.white, 10),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th(headName,Colors.black,13),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Container(
                      height: size.height*0.5,
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              child
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showNote(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 400,
                height: size.height*0.6,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th(headName,Colors.black,13),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              child
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showPhoneLookup(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.height*0.9,
                height: size.height*0.7,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th(headName,Colors.black,13),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              child
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showShortNote(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 400,
                height: 220,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th(headName,Colors.black,13),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                            children: [
                              child
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> showSystemInfo(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: size.width*0.35,
                height: size.height*0.5,
                decoration: boxDecoration(Colors.white, 10),
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          th(headName,Colors.black,13),
                          IconButton(onPressed: (){
                            Navigator.pop(context);
                          }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                        ],
                      ),
                      gapHC(5),
                      Container(
                        height: size.height*0.4,
                        child: SingleChildScrollView(
                            child: Column(
                              children: [
                                child
                              ],
                            )
                        ),
                      )
                    ],
                  ),
                )

            )
        );
      },
    );
  }

  Future<void> deleteDialog(context,fnDelete) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 30),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tc1("Delete",Colors.black,13),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tcn1('Do you want to delete ?',Colors.black,12),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      fnDelete();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 100,
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: boxBaseDecoration(color2, 30),
                                      child: Center(
                                        child: tc1('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> cancelDialog(context,fnCancel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th('Cancel',Colors.black,12),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              th('Do you want to cancel ?',Colors.black,12),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      fnCancel();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 10),
                                      child: Center(
                                        child: tc1('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> mailDialog(context,fnSend) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 30),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th('Email',Colors.black,12),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tcn1('Send Mail ?',Colors.black,12),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      fnSend();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 30),
                                      child: Center(
                                        child: tcn1('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }

  Future<void> printDialog(context,fnPrint) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 30),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tc1('Print',Colors.black,15),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              th('Do you want to print ?',Colors.black,12),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.red, 10),
                                      child: Center(
                                        child: tc1('No', Colors.white, 15),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      fnPrint();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 10),
                                      child: Center(
                                        child: tc1('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> saveDialog(context,fnSave) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 10),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th('Save',Colors.black,14),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              th('Do you want to save ?',Colors.black,12),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.red, 10),
                                      child: Center(
                                        child: tc1('No', Colors.white, 15),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      fnSave();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 10),
                                      child: Center(
                                        child: tc1('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }
  Future<void> endDialog(context,fnEnd) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 300,
                height: 200,
                decoration: boxDecoration(Colors.white, 30),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th('End Trip',Colors.black,14),
                        IconButton(onPressed: (){
                          Navigator.pop(context);
                        }, icon: const Icon(Icons.highlight_remove_sharp,color: Colors.black,size: 30,))
                      ],
                    ),
                    gapHC(5),

                    Container(
                      height: 100,
                      width: 300,
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tcn1('Do you want to proceed ?',Colors.black,10),
                              gapHC(20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.red, 10),
                                      child: Center(
                                        child: tc1('No', Colors.white, 15),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      fnEnd("END");
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 60,
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: boxDecoration(Colors.green, 10),
                                      child: Center(
                                        child: tc1('Yes', Colors.white, 15),
                                      ),
                                    ),
                                  ),

                                ],
                              )
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }

  Future<void> showMessage(context,msg,type,mode,icon) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: icon == "" ? MessageBox(msg: msg,type: type,mode:mode):MessageBox(msg: msg,type: type,mode:mode,icon: icon,)
        );
      },
    );
  }
  Future<void> showTaskDone(context,code,det) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(

                height: 300,
                width: 500,

                decoration: boxDecoration(Colors.white, 20),
                child: Column(
                  children: [
                    Expanded(child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset("assets/gifs/done.gif",width: 120,),
                          gapHC(5),
                          tc1("#$code", color2, 15),
                          tcn1('New Task Created !!!', color2, 20),
                          lineC(0.5, greyLight),
                          gapHC(5),
                          tcn1('Thank you for reaching out to us and raising a support ticket.  We appreciate your patience and understanding as we work to resolve your issue.', color3, 10)

                        ],
                      ),
                    )),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: boxBaseDecorationC(color2, 0,0,20,20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/namewhite.png",width: 100,)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        );
      },
    );
  }
  Future<void> showTaskUpdated(context,code,det) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(

                height: 300,
                width: 500,

                decoration: boxDecoration(Colors.white, 20),
                child: Column(
                  children: [
                    Expanded(child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset("assets/gifs/done.gif",width: 120,),
                          gapHC(5),
                          tc1("#$code", color2, 15),
                          tcn1('Task Updated !!!', color2, 20),
                          lineC(0.5, greyLight),
                          gapHC(5),
                          tcn1('Thank you for reaching out to us and raising a support ticket.  We appreciate your patience and understanding as we work to resolve your issue.', color3, 10)

                        ],
                      ),
                    )),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: boxBaseDecorationC(color2, 0,0,20,20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/namewhite.png",width: 100,)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        );
      },
    );
  }

  Future<void> showClientSaves(context,code,name,mode) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(

                height: 300,
                width: 500,

                decoration: boxDecoration(Colors.white, 20),
                child: Column(
                  children: [
                    Expanded(child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset("assets/gifs/done.gif",width: 120,),
                          gapHC(5),
                          tc1("#$code", color2, 15),
                          tcn1("$name", color2, 15),
                          gapHC(5),
                          mode == "EDIT"?
                          tcn1('Client Details Updated !!!', color2, 20):
                          tcn1('New Client Created !!!', color2, 20),
                          lineC(0.5, greyLight),
                          gapHC(5),
                        ],
                      ),
                    )),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: boxBaseDecorationC(color2, 0,0,20,20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/namewhite.png",width: 100,)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        );
      },
    );
  }
  Future<void> showSuccess(context,message,key) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(

                height: 300,
                width: 500,

                decoration: boxDecoration(Colors.white, 20),
                child: Column(
                  children: [
                    Expanded(child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Image.asset("assets/gifs/done.gif",width: 120,),
                          gapHC(5),
                          tc1(key, color2, 15),
                          gapHC(5),
                          tcn1(message, color2, 20),
                          lineC(0.5, greyLight),
                          gapHC(5),
                        ],
                      ),
                    )),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: boxBaseDecorationC(color2, 0,0,20,20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/namewhite.png",width: 100,)
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        );
      },
    );
  }

  fnShow() {
    // showDialog<void>(
    //   context: context,
    //   barrierDismissible: false, // user must tap button!
    //   barrierColor: Colors.transparent,
    //   builder: (BuildContext context) {
    //     return const CupertinoActivityIndicator(
    //       animating: true,
    //       radius: 50,
    //     );
    //   },
    // );
    Get.dialog(
      barrierDismissible: false, // user must tap button!
      barrierColor: Colors.transparent,
       const AlertDialog (
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: CupertinoActivityIndicator(
          animating: true,
          radius: 50,
        ),
      ),
    );
  }
  closeAlert(){
    Get.back();
  }

  Future<void> show_(context,child,headName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        Size size = MediaQuery.of(context).size;
        return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                height: 500,
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                      child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              child
                            ],
                          )
                      ),
                    )
                  ],
                )

            )
        );
      },
    );
  }


}