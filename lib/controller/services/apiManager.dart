
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bams_tms/controller/global/globalValues.dart';
import 'package:bams_tms/controller/services/appExceptions.dart';
import 'package:bams_tms/views/components/alertDialog/alertDialog.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class ApiManager {
  //var baseUrl = "http://laptop-vi4dgus9:2023/"; //lap
  //var baseUrl = "http://192.168.0.126:2023/"; //lap
  var baseUrl = "http://beamsdts-001-site1.atempurl.com/api/"; //lap

  var company = Global().wstrCompany;
  var yearcode = Global().wstrYearcode;
  var token = Global().wstrToken;
  var wstrIp = Global().wstrIp;
  var wstrContext =  Global().wstrContext;

  //==================================================================GET
  Future<dynamic> get(String api) async {
    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await http.get(uri);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }
  //==================================================================POST
  Future<dynamic> post(String api, dynamic body) async {
    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    var uri = Uri.parse(baseUrl + api);
    var payload = body;
    try {
      var response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'COMPANY' : company,
            'YEARCODE' : yearcode,
            'Authorization': 'Bearer $token'
          },
          body: payload);
      return _processResponse(response);
    } on SocketException {

      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }
  Future<dynamic> postLink(String api) async {
    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'COMPANY' : company,
            'YEARCODE' : yearcode,
            'Authorization': 'Bearer $token'
          },);
      return _processResponse(response);
    } on SocketException {

      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }
  Future<dynamic> postLoading(String api, dynamic body,var isLoad) async {

    try{
      if(isLoad =='S'){
        PageDialog().fnShow();
      }
    }catch(e){
      dprint(e);
    }

    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    var uri = Uri.parse(baseUrl + api);
    var payload = body;
    try {
      var response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'COMPANY' : company,
            'YEARCODE' : yearcode,
            'Authorization': 'Bearer $token'
          },
          body: payload);

      try{
        if(isLoad =='S'){
          PageDialog().closeAlert();
        }
      }catch(e){
        dprint(e);
      }
      return _processResponse(response);

    } on SocketException {
      if(isLoad =='S'){
        PageDialog().closeAlert();
      }
      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      if(isLoad =='S'){
        PageDialog().closeAlert();
      }
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }

  }
  //==================================================================COMMON
  Future<dynamic> mfnGetToken() async{

    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    Map<String, dynamic> body = {
      'userName': 'user@beamserp.com',
      'Password': '123456',
      'grant_type': 'password'
    };

    var uri = Uri.parse(baseUrl+'/token');
    try {
      var response = await http.post(
          uri,
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Access-Control-Allow-Origin": "*", // Required for CORS support to work
            "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "POST, OPTIONS"
          },
          body: body,
          encoding: Encoding.getByName("utf-8")
      );

      return _processResponse(response);
    } on SocketException {

      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }

  }
  Future<dynamic> mfnGetTokenTest(baseUrlIP) async{

    Map<String, dynamic> body = {
      'userName': 'user@beamserp.com',
      'Password': '123456',
      'grant_type': 'password'
    };
    var uri = Uri.parse(baseUrlIP+'/token');
    try {
      var response = await http.post(
          uri,
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Access-Control-Allow-Origin": "*", // Required for CORS support to work
            "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "POST, OPTIONS"
          },
          body: body,
          encoding: Encoding.getByName("utf-8")
      );
      return _processResponse(response);
    } on SocketException {

      throw FetchDataException('No Internet connection', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }

  }
  //==================================================================Attachment
  Future<dynamic> mfnAttachment(List filesArray,docno,doctype) async {
    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    var uri = Uri.parse(baseUrl + 'api/UploadFiles');
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers.addAll({ 'Content-Type': 'application/json; charset=UTF-8',
      'COMPANY' : company,
      'YEARCODE' : yearcode,
      'DataSession' : "",
      'Authorization': 'Bearer $token'});
    //multipartFile = new http.MultipartFile("imagefile", stream, length, filename: basename(imageFile.path));
    //List<MultipartFile> newList ;
    request.fields['COMPANY'] = company;
    request.fields['DOCNO'] = docno;
    request.fields['DOCTYPE'] = doctype;
    var fileDescpStr ='';
     for (int i = 0; i < filesArray.length; i++) {
       File imageFile = filesArray[i];
       fileDescpStr = fileDescpStr+"{'FILE_DESCP':'"+i.toString()+"'},";
     }
     fileDescpStr= "["+fileDescpStr+"]";

    for (int i = 0; i < filesArray.length; i++) {
      File imageFile = filesArray[i];
      var stream =
      http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile =  http.MultipartFile("imagefile", stream, length,
          filename: basename(imageFile.path));
      request.files.add(multipartFile);
    }
    dprint(fileDescpStr.toString());
    request.fields['FILE_DESCP'] = fileDescpStr.toString();
    var response = await request.send();
    if (response.statusCode == 200) {
      dprint("Image Uploaded");
      //var rtnValue = "";
      final rtnValue = await response.stream.bytesToString();
      dprint(rtnValue);
      return rtnValue.replaceAll('"', "");

    } else {
      dprint("Upload Failed");
    }
    response.stream.transform(utf8.decoder).listen((value) {
      dprint(value);
    });
  }
  //==================================================================firebase
  sendNotificationToUser(token) async {
    //Our API Key
    var serverKey = "AAAAW1HFjuI:APA91bGgZJ2r5MFWozacZmoz4t9L7wLmQtN-ah6xXjKmEXnAZWaiVFw58h_2a4fr3zM0Zqgr88Fwh2fLLHN7A7N2Ng1UFlH9By2GCj5RvMxhwXxoPFI9n1h1BnR-UOkZx4miX7xkR4vI";

    //Get our Admin token from Firesetore DB
    // var token = 'ddBDKUR6SdaWhguVEQDiCh:APA91bHBD71J8eT0T-5_zTDJnii5Q5U2CAcSuR9sgDZIFcmuXiNHuHS-bgKM0M14y__M_ZTAgi8StV0QKxD9oHMlaRuU-MTgDOsossNXWgVNgpRuA2kSl7Sibz7r7s-m3u23HBz3iESl';

    //Create Message with Notification Payload
    String constructFCMPayload(String token) {

      return jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': "TEST",
            'title':"TITLE TMS",
          },
          'data': <String, dynamic>{
            'name': "HAKEEM",
            'time': "",
            'service': "",
            'status': "",
            'id': "100"
          },
          'to': token
        },
      );
    }




    if (token.isEmpty) {
      return log('Unable to send FCM message, no token exists.');
    }

    try {
      //Send  Message
      http.Response response =
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: constructFCMPayload(token));

      log("status: ${response.statusCode} | Message Sent Successfully!");
    } catch (e) {
      log("error push notification $e");
    }
  }
  //==================================================================RESPONSE
  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        return responseJson;
        break;
      case 201:
        var responseJson = jsonDecode(response.body);
        return responseJson;
        break;
      case 204:
        var responseJson = jsonDecode(response.body);
        return responseJson;
        break;
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 403:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      default:
        throw FetchDataException('BE100', response.request!.url.toString());
    }
  }

}