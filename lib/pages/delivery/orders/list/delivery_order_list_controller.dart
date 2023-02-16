import 'package:app_delivery/providers/orders_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DeliveryOrderListController extends GetxController {
  final OrdersProvider _ordersProvider = OrdersProvider();
  List<String> status = <String>['DESPACHADO', 'EN CAMINO', 'ENTREGADO'].obs;

  User _user = User.fromJson(GetStorage().read('user') ?? {});
  Future<List<Order>> getOrders(String status) async {
    return await _ordersProvider.findByDeliveryAndStatus(
        _user.id ?? '0', status);
  }

  void goToOrderDetail(Order order) {
    Get.toNamed('/delivery/orders/detail', arguments: {'order': order.toMap()});
  }
}
