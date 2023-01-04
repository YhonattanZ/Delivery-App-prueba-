import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RolesController extends GetxController {
//Ya que la informacion se encuentra en el usuario, debemos instanciarlo primero
  User user = User.fromJson(GetStorage().read('user') ?? {});

  void goToPageRol(RolesUsuario roles) {
    Get.offNamedUntil(roles.route ?? '', (route) => false);
  }
}
