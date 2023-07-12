


import 'package:bams_tms/controller/services/appExceptions.dart';
import 'package:bams_tms/views/components/common/common.dart';
import 'package:get/get.dart';
class BaseController {
  void  handleError(error) {
    if (error is BadRequestException) {
      var message = error.message;
      dprint(message);
      Get.off(() =>  Error());

    } else if (error is FetchDataException) {
      var message = error.message;
      dprint(message);

    } else if (error is ApiNotRespondingException) {
      var message = error.message;
      dprint(message);
      Get.off(() =>  Error());
    }
  }
}