

import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {

  static final Global _instance = Global._internal();

  // passes the instantiation to the _instance object
  factory Global() => _instance;

  //initialize variables in here
  Global._internal() {
    _wstrToken = '';
    _wstrCompany = '';
    _wstrYearcode = '';
    _wstrUserCd = '';
    _wstrUserName = '';
    _wstrDeivceId = '';
    _wstrDeviceName = '';
    _wstrIp = '';
    _wstrVersionName = '';
    _wstrBrnCode = '';
    _wstrLoginDate = "";
    _wstrLoginYn = "";
    _wstrBaseUrl = "";
    _wstrHeadFont = 15.0;
    _wstrSubFont = 12.0;
    _wstrIconSize = 18.0;
    _wstrSubIconSize = 15.0;
    _wstrCompanyName = '';
    _wstrDarkMode = false;
    _wstrClientId = "";
    _wstrMainClientId = "";
    _wstrCompanyShort = "";

    _wstrFromLink = "";
    _wstrLModule =  "";
    _wstrLCompanyCode =  "";
    _wstrLCompanyName =  "";
    _wstrLCompanyID =  "";
    _wstrLUserCd =  "";
    _wstrLKey = "";

    _wstrUserRole = "";
    _wstrUserRoleDescp = "";
    _wstrUserDepartment = "";
    _wstrUserDepartmentDescp = "";
  }
  var _wstrToken  = '';
  var _wstrCompany = '';
  var _wstrCompanyShort = '';
  var _wstrCompanyName = '';
  var _wstrBrnCode = '';
  var _wstrDeivceId = '';
  var _wstrDeviceName = '';
  var _wstrYearcode = '';
  var _wstrUserCd = '';
  var _wstrUserName = '';
  var _wstrIp = '';
  var _wstrDeviceIP;
  var _wstrContext;
  var _wstrVersionName = '';

  var _wstrLoginDate = "";
  var _wstrLoginYn = "";
  var _wstrBaseUrl = "";

  var _wstrClientId = "";
  var _wstrMainClientId = "";

  var _wstrClientName = "";
  var _wstrMainClientName = "";

  var _wstrUserRole = "";
  var _wstrUserRoleDescp = "";
  var _wstrUserDepartment = "";
  var _wstrUserDepartmentDescp = "";


  //From Link
  var _wstrFromLink = "";
  var _wstrLModule =  "";
  var _wstrLCompanyCode =  "";
  var _wstrLCompanyName =  "";
  var _wstrLCompanyID =  "";
  var _wstrLUserCd =  "";
  var _wstrLKey = "";

  //FONT_SIZE
  var _wstrHeadFont = 15.0;
  var _wstrSubFont = 12.0;
  var _wstrIconSize = 18.0;
  var _wstrSubIconSize = 13.0;
  var _wstrDarkMode =  false;

  get wstrUserRole => _wstrUserRole;

  set wstrUserRole(value) {
    _wstrUserRole = value;
  }

  get wstrLKey => _wstrLKey;

  set wstrLKey(value) {
    _wstrLKey = value;
  }


  get wstrFromLink => _wstrFromLink;

  set wstrFromLink(value) {
    _wstrFromLink = value;
  }

  get wstrCompanyShort => _wstrCompanyShort;

  set wstrCompanyShort(value) {
    _wstrCompanyShort = value;
  }

  get wstrClientName => _wstrClientName;

  set wstrClientName(value) {
    _wstrClientName = value;
  }

  get wstrClientId => _wstrClientId;

  set wstrClientId(value) {
    _wstrClientId = value;
  }

  get wstrDarkMode => _wstrDarkMode;

  set wstrDarkMode(value) {
    _wstrDarkMode = value;
  }

  get wstrCompanyName => _wstrCompanyName;

  set wstrCompanyName(value) {
    _wstrCompanyName = value;
  }

  get wstrSubIconSize => _wstrSubIconSize;

  set wstrSubIconSize(value) {
    _wstrSubIconSize = value;
  }

  get wstrHeadFont => _wstrHeadFont;

  set wstrHeadFont(value) {
    _wstrHeadFont = value;
  }

  get wstrBaseUrl => _wstrBaseUrl;

  set wstrBaseUrl(value) {
    _wstrBaseUrl = value;
  }

  get wstrLoginDate => _wstrLoginDate;

  set wstrLoginDate(value) {
    _wstrLoginDate = value;
  }

  get wstrBrnCode => _wstrBrnCode;

  set wstrBrnCode(value) {
    _wstrBrnCode = value;
  }

  get wstrVersionName => _wstrVersionName;

  set wstrVersionName(value) {
    _wstrVersionName = value;
  }

  get wstrDeviceIP => _wstrDeviceIP;

  set wstrDeviceIP(value) {
    _wstrDeviceIP = value;
  }

  get wstrIp => _wstrIp;

  set wstrIp(value) {
    _wstrIp = value;
  }

  get wstrToken => _wstrToken;

  set wstrToken(value) {
    _wstrToken = value;
  }

  get wstrDeivceId => _wstrDeivceId;

  set wstrDeivceId(value) {
    _wstrDeivceId = value;
  }

  get wstrDeviceName => _wstrDeviceName;


  set wstrDeviceName(value) {
    _wstrDeviceName = value;
  }


  set wstrUserName(value) {
    _wstrUserName = value;
  }

  set wstrUserCd(value) {
    _wstrUserCd = value;
  }

  set wstrYearcode(value) {
    _wstrYearcode = value;
  }

  set wstrCompany(value) {
    _wstrCompany = value;
  }

  get wstrCompany => _wstrCompany;

  get wstrYearcode => _wstrYearcode;

  get wstrUserCd => _wstrUserCd;

  get wstrUserName => _wstrUserName;



  get wstrContext => _wstrContext;

  set wstrContext(value) {
    _wstrContext = value;
  }

  get wstrLoginYn => _wstrLoginYn;

  set wstrLoginYn(value) {
    _wstrLoginYn = value;
  }

  get wstrSubFont => _wstrSubFont;

  set wstrSubFont(value) {
    _wstrSubFont = value;
  }

  get wstrIconSize => _wstrIconSize;

  set wstrIconSize(value) {
    _wstrIconSize = value;
  }


  //===============================================================global fn========================

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool fnValCheck(value){
    if(value == null){
      return false;
    }else{
      if(value.length > 0){
        return true;
      }else{
        return false;
      }
    }
  }
  fnGrep(array,code,value){
    if(array == null){

    }else{
      if(array.length > 0){

      }else{
      }
    }
  }
  mfnDbl(dbl){
    var lstrDbl = 0.0;

    try {
      lstrDbl =  double.parse((dbl??'0.0').toString());
    }
    catch(e){
      lstrDbl= 0.00;
    }
    return lstrDbl;
  }
  mfnInt(dbl){
    var lstrInt = 0;
    try {
      lstrInt =  int.parse((dbl??'0.0').toString());
    }
    catch(e){
      lstrInt= 0;
    }
    return lstrInt;
  }
  mfnJson(arr){
    var tempArray;
    if(fnValCheck(arr)){
      String tempString = jsonEncode(arr);
      tempArray  =  jsonDecode(tempString);
    }
    return tempArray;
  }
  mfnCurr(amount){
    var lstrDbl = 0.0;

    try {
      lstrDbl =  double.parse((amount??'0.0').toString());
    }
    catch(e){
      lstrDbl= 0.00;
    }
    var amt = NumberFormat.simpleCurrency(name:"").format(lstrDbl);
    return amt;

  }

  get wstrMainClientId => _wstrMainClientId;

  set wstrMainClientId(value) {
    _wstrMainClientId = value;
  }

  get wstrMainClientName => _wstrMainClientName;

  set wstrMainClientName(value) {
    _wstrMainClientName = value;
  }

  get wstrLModule => _wstrLModule;

  set wstrLModule(value) {
    _wstrLModule = value;
  }

  get wstrLCompanyCode => _wstrLCompanyCode;

  set wstrLCompanyCode(value) {
    _wstrLCompanyCode = value;
  }

  get wstrLCompanyName => _wstrLCompanyName;

  set wstrLCompanyName(value) {
    _wstrLCompanyName = value;
  }

  get wstrLCompanyID => _wstrLCompanyID;

  set wstrLCompanyID(value) {
    _wstrLCompanyID = value;
  }

  get wstrLUserCd => _wstrLUserCd;

  set wstrLUserCd(value) {
    _wstrLUserCd = value;
  }

  get wstrUserRoleDescp => _wstrUserRoleDescp;

  set wstrUserRoleDescp(value) {
    _wstrUserRoleDescp = value;
  }

  get wstrUserDepartment => _wstrUserDepartment;

  set wstrUserDepartment(value) {
    _wstrUserDepartment = value;
  }

  get wstrUserDepartmentDescp => _wstrUserDepartmentDescp;

  set wstrUserDepartmentDescp(value) {
    _wstrUserDepartmentDescp = value;
  }



}