import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RestaurantHomeController extends GetxController {
  var indexTab = 0.obs;

//Cambiar la pestana de info del bottomNavBar
  void changeTab(int index) {
    indexTab.value = index;
  }

// Remover la informacion del usuario/ Cerrar sesion
  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil(
        '/login', (route) => false); //Elimina todo el historial de pantalla
  }
}
