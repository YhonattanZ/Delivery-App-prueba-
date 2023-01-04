import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProductListController extends GetxController {
  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil(
        '/login', (route) => false); //Elimina todo el historial de pantalla
  }
}
