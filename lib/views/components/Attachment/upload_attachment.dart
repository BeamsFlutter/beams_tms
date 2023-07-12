
import 'dart:io';
import 'dart:typed_data';
import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/apiManager.dart';
import 'package:bams_tms/main.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:bams_tms/views/styles/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';


class AttachmentUpload extends StatefulWidget {

  final String docno;
  final String doctype;
  final Function? fnCallBack;

  const AttachmentUpload({Key? key, required this.docno, required this.doctype, this.fnCallBack}) : super(key: key);

  @override
  State<AttachmentUpload> createState() => _AttachmentUploadState();
}

class _AttachmentUploadState extends State<AttachmentUpload> {

  //Global
  Global g = Global();

  late Future<dynamic> futureFiles;

  //Page Variables
  List<File> lstrFiles  =[];


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.5,
        child: Column(
          children: [
            Container(
              decoration: boxBaseDecoration(greyLight, 10),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Bounce(
                    onPressed: (){
                      fnAddFiles();
                    },
                    duration: const Duration(milliseconds: 110),
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: boxDecoration(subColor, 30),
                      child: const Icon(Icons.add,color: Colors.white,size: 15,),
                    ),
                  ),
                  gapWC(10),
                  Bounce(
                    onPressed: (){
                      fnUploadFile();
                    },
                    duration: const Duration(milliseconds: 110),
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: boxDecoration(bgColorDark, 30),
                      child: const Icon(Icons.upload,color: Colors.white,size: 15,),
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: viewAttachments())
          ],
        ),
    );
  }

  //========================================WIDGET

  Widget viewAttachments(){
     return lstrFiles.isNotEmpty? ScrollConfiguration(behavior: MyCustomScrollBehavior(),
         child: ListView.builder(
         physics: const AlwaysScrollableScrollPhysics(),
         itemCount: lstrFiles.length,
         itemBuilder: (context, index) {
           var file = lstrFiles[index];
           return Bounce(
             onPressed: (){

             },
             duration: const Duration(milliseconds: 110),
             child:  Container(
               decoration: boxBaseDecoration(blueLight, 0),
               padding: const EdgeInsets.all(10),
               margin: const EdgeInsets.only(bottom: 5,top: 5),
               child: Row(
                 children: [
                  Expanded(child:  tcn(file.toString(), bgColorDark, 12)),
                  GestureDetector(
                    onTap: (){
                      fnRemoveFile(file);
                    },
                    child: const Icon(Icons.close,color: subColor,size: 15,),
                  )
                 ],
               ),

             ),
           );
         })):SizedBox(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image,color: greyLight,size: 50,),
                  gapHC(10),
                  tcn('No attachment selected', greyLight, 15)
                ],
              ),
            ),
     );
  }

  //========================================PAGEFN

  fnAddFiles() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path.toString())).toList();
      print(files[0].toString());
      List<Uint8List> bytsArray =[] ;
      for(var e in files){
        Uint8List bytes  =  await e.readAsBytes();
        bytsArray.add(bytes);
      }
      //filesArray
      if(mounted){
        setState((){
          //lstrFiles = lstrFiles + files;
          for(var e in files){
            if(!lstrFiles.contains(e)){
              lstrFiles.add(e);
            }
          }
        });
      }

    } else {
      // User canceled the picker
    }
  }
  fnRemoveFile(file){
    if(mounted){
      setState((){
        lstrFiles.remove(file);
      });
    }
  }
  fnUploadFile(){
    if(lstrFiles.isEmpty){
      return ;
    }

    apiUploadFiles();
  }


 //========================================APICALL

  apiUploadFiles() {
    futureFiles =  ApiManager().mfnAttachment(lstrFiles, widget.docno, widget.doctype);
    futureFiles.then((value) => apiUploadFilesRes(value));
  }
  apiUploadFilesRes(value){
    Navigator.pop(context);
    widget.fnCallBack!(value);
  }
}
