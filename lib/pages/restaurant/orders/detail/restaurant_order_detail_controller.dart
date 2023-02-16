import 'package:app_delivery/providers/orders_provider.dart';
import 'package:app_delivery/providers/user_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class RestaurantOrdersDetailController extends GetxController {
  Order order = Order.fromMap(Get.arguments['order']);
  var idDelivery = ''.obs;
  var total = 0.0.obs;
  UsersProvider _usersProvider = UsersProvider();
  OrdersProvider _ordersProvider = OrdersProvider();

  List<User> users = <User>[].obs;
  RestaurantOrdersDetailController() {
    getTotal();
    getDeliveryMen();
  }

  void updateOrder() async {
    if (idDelivery.value != '') {
      //Selecciono el repartidor
      order.idDelivery = idDelivery.value;
      ResponseApi responseApi = await _ordersProvider.updateToDispatched(order);
      Fluttertoast.showToast(
          msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      if (responseApi.success == true) {
        update();
        Get.offNamedUntil('/restaurant/home', (route) => false);
      } else if (responseApi.success == false) {
        Get.snackbar('Peticion fallida', responseApi.message ?? '');
      }
    } else {
      Get.snackbar('Petición fallida', 'Debes seleccionar un repartidor');
    }
  }

  void getDeliveryMen() async {
    var result = await _usersProvider.findDeliveryMen();
    users.clear();
    users.addAll(result);
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in order.products!) {
      total.value = total.value + (product.quantity! * product.price!);
    }
  }
}
