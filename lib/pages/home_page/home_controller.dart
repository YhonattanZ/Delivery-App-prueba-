import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {});

  HomeController() {
    print('Usuario logado: ${user.toJson()}');
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil(
        '/login', (route) => false); //Elimina todo el historial de pantalla
  }
}
