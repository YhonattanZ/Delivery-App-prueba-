import 'package:app_delivery/providers/orders_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientOrderListController extends GetxController {
  final OrdersProvider _ordersProvider = OrdersProvider();
  List<String> status =
      <String>['PAGADO', 'DESPACHADO', 'EN CAMINO', 'ENTREGADO'].obs;

  User _user = User.fromJson(GetStorage().read('user') ?? {});
  Future<List<Order>> getOrders(String status) async {
    return await _ordersProvider.findByClientAndStatus(_user.id ?? '0', status);
  }

  void goToOrderDetail(Order order) {
    Get.toNamed('/client/orders/detail', arguments: {'order': order.toMap()});
  }
}
