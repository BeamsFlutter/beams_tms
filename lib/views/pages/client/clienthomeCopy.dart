


// Widget wSearchPopupChoice(mode){
//   Widget rtnWidget  =  Container();
//   if(mode  == "COMPANY"){
//     rtnWidget = SearchPopup(
//       lstrColumnList: [{"COLUMN":"NAME","CAPTION":"Company"}],
//       lstrData: lstrCompanyList,
//       callback: (val){
//         dprint(val);
//         if(mounted){
//           setState(() {
//             lstrTCompany = val["NAME"];
//             lstrTCompanyCode = val["COMPANY_CODE"];
//             lstrTCompanyId = val["CLIENT_ID"];
//             lstrTModule = "";
//           });
//         }
//       },);
//   }else  if(mode  == "PROJECT"){
//     var selectedData = g.mfnJson(lstrModuleList);
//     selectedData.retainWhere((i){
//       return i["CLIENT_ID"] == lstrTCompanyId ;
//     });
//     rtnWidget = SearchPopup(
//       lstrColumnList: [{"COLUMN":"MODULE","CAPTION":"Module"}],
//       lstrData: selectedData,
//       callback: (val){
//         dprint(val);
//         if(mounted){
//           setState(() {
//             lstrTModule = val["MODULE"];
//           });
//         }
//       },);
//   }
//   return rtnWidget;
// }