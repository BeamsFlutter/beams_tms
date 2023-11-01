import 'dart:convert';

import 'package:bams_tms/controller/services/appExceptions.dart';
import 'package:bams_tms/controller/services/baseController.dart';
import 'package:bams_tms/views/components/common/common.dart';

import 'apiManager.dart';

class ApiCall with BaseController {
  //============================================LOGIN
  Future<dynamic> apiClientLogin(usercd, password) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'USERNAME': usercd,
      'PASSWORD': password,
    });
    dprint('api/client_login');
    dprint(request);
    var response = await ApiManager()
        .post('api/client_login', request)
        .catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiClientDirectLogin(key) async {
    dprint('api/application_login');
    dprint(key);
    var response = await ApiManager()
        .postLink('api/application_login/?code=' + key)
        .catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiUserLogin(user, password) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "USERNAME": user,
      "PASSWORD": password,
    });
    dprint('api/user_login');
    dprint(request);
    var response =
        await ApiManager().post('api/user_login', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }

  Future<dynamic> apiGetCompany() async {
    var response =
        await ApiManager().postLink('api/GetCompanyYear').catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint('api/GetCompanyYear');
    dprint(response);

    if (response == null) return;

    return response;
  }

  //============================================LOOKUP
  Future<dynamic> LookupSearch(
      lstrTable, lstrColumn, lstrPage, lstrPageSize, lstrFilter) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable": lstrTable,
      "lstrSearchColumn": lstrColumn,
      "lstrPage": lstrPage,
      "lstrLimit": lstrPageSize,
      "lstrFilter": lstrFilter,
    });
    dprint('api/lookupSearch');
    dprint(request);

    var response = await ApiManager()
        .post('api/lookupSearch', request)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }

  Future<dynamic> LookupValidate(lstrTable, lstrFilter) async {
    var request = jsonEncode(
        <dynamic, dynamic>{"lstrTable": lstrTable, "lstrFilter": lstrFilter});
    dprint('api/lookupValidate');
    dprint(request);
    var response = await ApiManager()
        .post('api/lookupValidate', request)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }

  Future<dynamic> apiLookupValidate(lstrTable, key, value) async {
    var lstrFilter = [
      {'Column': key, 'Operator': '=', 'Value': value, 'JoinType': 'AND'}
    ];
    var request = jsonEncode(
        <dynamic, dynamic>{"lstrTable": lstrTable, "lstrFilter": lstrFilter});
    dprint('api/lookupValidate');
    dprint(request);
    var response = await ApiManager()
        .post('api/lookupValidate', request)
        .catchError((error) {
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
  }

  //CALL BASED ON COMPANY
  Future<dynamic> apiLookupValidateSch(lstrTable, key, value, company) async {
    var lstrFilter = [
      {'Column': key, 'Operator': '=', 'Value': value, 'JoinType': 'AND'}
    ];
    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable": lstrTable,
      "lstrFilter": lstrFilter,
      "COMPANY": company
    });
    var response = await ApiManager()
        .post('api/lookupValidate_sch', request)
        .catchError((error) {
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
  }

  Future<dynamic> apiLookupSearch(lstrTable, lstrColumn, lstrPage, lstrPageSize,
      lstrFilter, company) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable": lstrTable,
      "lstrSearchColumn": lstrColumn,
      "lstrPage": lstrPage,
      "lstrLimit": lstrPageSize,
      "lstrFilter": lstrFilter,
      "COMPANY": company,
    });
    dprint('api/lookupSearch_sch');
    dprint(request);

    var response = await ApiManager()
        .post('api/lookupSearch_sch', request)
        .catchError((error) {
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }

  Future<dynamic> LookupValidateSch(lstrTable, lstrFilter, company) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable": lstrTable,
      "lstrFilter": lstrFilter,
      "COMPANY": company
    });

    var response = await ApiManager()
        .post('api/lookupValidate_sch', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
  }

  //============================================COMMON
  Future<dynamic> apiDeleteAttachment(docno, doctype, srno, path) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
      'SRNO': srno,
      'PATH': path,
    });
    dprint('api/deleteattachment');
    dprint(request);
    var response = await ApiManager()
        .post('api/deleteattachment', request)
        .catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });

    if (response == null) return;

    return response;
  }

  Future<dynamic> apiViewLog(docno, doctype) async {
    dprint('${'api/getlog?DOCNO=' + docno}&DOCTYPE=' + doctype);
    var response = await ApiManager()
        .postLink('${'api/getlog?DOCNO=' + docno}&DOCTYPE=' + doctype)
        .catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  //============================================Home
  Future<dynamic> apiGetCompanyModule() async {
    dprint('api/company_module');
    var response =
        await ApiManager().postLink('api/company_module').catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  //============================================TASK

  Future<dynamic> apiGetTaskMasters() async {
    dprint('api/get_task_masters');
    var response =
        await ApiManager().postLink('api/get_task_masters').catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiSaveTask(task, checklist, platform, mode, userList) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'TASK': task,
      'TASK_CHECKLIST': checklist,
      'TASK_PLATFORM': platform,
      'USERCODE_LIST': userList, //{'COL_VAL':userCode}
      'MODE': mode,
      'ASSIGN_DEADLINE': "",
      'MAX_TIME_MINUT': "",
    });
    dprint('api/savetask');
    dprint(request);
    var response =
        await ApiManager().post('api/savetask', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiGetTask(
      docno,
      doctype,
      from,
      to,
      mainClientId,
      clientYn,
      page,
      sortCol,
      sortDir,
      search,
      client,
      task,
      issue,
      clientType,
      status,
      userList,
      priorityList,
      overdueYn,
      moduleList,
      profileYN,
      assgnFrom,
      assgnTo,
      department) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
      'DATE_FROM': from,
      'DATE_TO': to,
      'MAIN_CLIENT_ID': mainClientId,
      'CREATEUSER_CLIENT_YN': clientYn,
      'PAGE': page,
      'SORT_COL': sortCol,
      'SORT_DIR': sortDir, //ASC ,DESC
      'SEARCH': search,
      'CLIENT_ID_LIST': client, //[{'COL_VAL':''}]
      'TASK_TYPE_LIST': task,
      'ISSUE_TYPE_LIST': issue,
      'CLIENT_TYPE_LIST': clientType,
      'STATUS_LIST': status,
      'USERCODE_LIST': userList,
      'PRIORITY_LIST': priorityList,
      'MODULE_LIST': moduleList,
      'OVERDUE_YN': overdueYn,
      'PROFILE_YN': profileYN,
      'ASSIGN_FROM': assgnFrom,
      'ASSIGN_TO': assgnTo,
      'DEP_LIST': department,
    });
    dprint('api/tasklist');
    dprint(request);
    var response =
        await ApiManager().post('api/tasklist', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiGetTaskDet(mainClientId, docno, doctype) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'MAIN_CLIENT_ID': mainClientId,
      'DOCNO': docno,
      'DOCTYPE': doctype,
    });
    dprint('api/viewtask');
    dprint(request);
    var response =
        await ApiManager().post('api/viewtask', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiDeleteTask(docno, doctype) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
    });
    dprint('api/deletetask');
    dprint(request);
    var response =
        await ApiManager().post('api/deletetask', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiUpdateTask(docno, doctype, status, issue, priority) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
      'STATUS': status,
      'ISSUE_TYPE': issue,
      'PRIORITY': priority,
    });
    dprint('api/updatetask');
    dprint(request);
    var response =
        await ApiManager().post('api/updatetask', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiAddTaskComment(docno, doctype, comment) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
      'COMMENT': comment,
    });
    dprint('api/addcomment');
    dprint(request);
    var response =
        await ApiManager().post('api/addcomment', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  //============================================TASK ACTIONS

  Future<dynamic> apiStartTask(docno, doctype) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
    });
    dprint('api/starttask');
    dprint(request);
    var response =
        await ApiManager().post('api/starttask', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiResumeTask(docno, doctype) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
    });
    dprint('api/resumetask');
    dprint(request);
    var response =
        await ApiManager().post('api/resumetask', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiHoldTask(docno, doctype, note) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
      'NOTE': note ?? "",
    });
    dprint('api/holdtask');
    dprint(request);
    var response =
        await ApiManager().post('api/holdtask', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiMoveTask(docno, doctype, userList, department, tsfNote,
      asgnDeadline, workMin) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
      'TSF_NOTE': tsfNote,
      'USERCODE_LIST': userList, //{'COL_VAL':userCode}
      'DEPARTMENT_CODE': department,
      'ASSIGN_DEADLINE': asgnDeadline,
      'MAX_TIME_MINUT': workMin,
    });
    dprint('api/movetask');
    dprint(request);
    var response =
        await ApiManager().post('api/movetask', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiFinishTask(docno, doctype, note) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docno,
      'DOCTYPE': doctype,
      'TSF_NOTE': note,
    });
    dprint('api/finishtask');
    dprint(request);
    var response =
        await ApiManager().post('api/finishtask', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

//============================================ACTIVATION
  Future<dynamic> apiSaveMainCompany(companyId, companyName, mode) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'MAIN_COMPANY_NAME': companyName,
      "MODE": mode,
      "DOCNO": companyId
    });
    dprint('api/savemainclient');
    dprint(request);
    var response = await ApiManager()
        .post('api/savemainclient', request)
        .catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiSaveProduct(id, name, note, mode) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "NAME": name,
      "DESCP": note,
      "LOGO": "",
      "MODULE": "",
      "MODE": mode,
      "PRODUCT_ID": id
    });
    dprint('api/saveproduct');
    dprint(request);
    var response =
        await ApiManager().post('api/saveproduct', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiGetPendingActivation(search, type) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "DATE_FROM": null,
      "DATE_TO": null,
      "SEARCH": search,
      "TYPE_LIST": type // [{"COL_VAL":"D"}]
    });
    dprint('api/activationlist');
    dprint(request);
    var response = await ApiManager()
        .post('api/activationlist', request)
        .catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiActivate(main, client, product) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_CLIENT_ID": main,
      "CLIENT_ID": client,
      "ACTIVATION_STATUS": "A",
      "CLIENT_PRODUCTS": product
    });
    dprint('api/saveclientproduct');
    dprint(request);
    var response = await ApiManager()
        .post('api/saveclientproduct', request)
        .catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiAllNotification(page) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "PAGE": page,
    });
    dprint('api/allnotification');
    dprint(request);
    var response = await ApiManager()
        .post('api/allnotification', request)
        .catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

  Future<dynamic> apiReadNotify(id) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "ID": id,
    });
    dprint('api/readnotify');
    dprint(request);
    var response =
        await ApiManager().post('api/readnotify', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }

//============================================TASK REPORT

  Future<dynamic> apiTaskReport(
      mode, startDate, endDate, keyVal, userCd, profileYN) async {
    var request = jsonEncode(<dynamic, dynamic>{
      "TYPE_LIST": keyVal, //[{'COL_VAL':'', 'KEY_VAL':''// }]
      "MODE": mode,
      "STARTDATE": startDate,
      "ENDDATE": endDate,
      'USER_CD': userCd,
      'PROFILE_YN': profileYN,
    });
    dprint('api/taskreport');
    dprint(request);
    var response =
        await ApiManager().post('api/taskreport', request).catchError((error) {
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;
  }
}
