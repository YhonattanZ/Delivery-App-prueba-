import 'package:app_delivery/providers/orders_provider.dart';
import 'package:app_delivery/providers/user_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ClientOrdersDetailController extends GetxController {
  Order order = Order.fromMap(Get.arguments['order']);
  var idDelivery = ''.obs;
  var total = 0.0.obs;
  UsersProvider _usersProvider = UsersProvider();
  OrdersProvider _ordersProvider = OrdersProvider();

  List<User> users = <User>[].obs;
  ClientOrdersDetailController() {
    getTotal();
  }

  void goToDeliveryMap() {
    Get.toNamed('/client/orders/map', arguments: {'order': order.toMap()});
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in order.products!) {
      total.value = total.value + (product.quantity! * product.price!);
    }
  }
}
