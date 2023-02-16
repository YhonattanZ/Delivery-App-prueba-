import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProfileInfoController extends GetxController {
  var user = User.fromJson(GetStorage().read('user')).obs;

  void signOut() {
    GetStorage().remove('user');
    GetStorage().remove('shopping_bag');
    GetStorage().remove('address');
    Get.offNamedUntil(
        '/login', (route) => false); //Elimina todo el historial de pantalla
  }

  void updatedatos() {
    Get.toNamed(
        '/client/update/info'); //Va hacia la ruta y la deja guardada en historial
  }
}
