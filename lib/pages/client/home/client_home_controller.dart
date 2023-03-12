import 'package:app_delivery/providers/push_notifications_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientHomeController extends GetxController {
  var indexTab = 0.obs;
  final PushNotificationsProvider _pushNotificationsProvider =
      PushNotificationsProvider();
  final User _user = User.fromJson(GetStorage().read('user') ?? {});

  ClientHomeController() {
    saveToken();
  }

  void saveToken() {
    if (_user.id != null) {
      _pushNotificationsProvider.saveToken(_user.id!);
    }
  }

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
