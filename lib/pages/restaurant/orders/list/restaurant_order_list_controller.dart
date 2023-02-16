import 'package:app_delivery/providers/orders_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:get/get.dart';

class RestaurantOrderListController extends GetxController {
  final OrdersProvider _ordersProvider = OrdersProvider();
  List<String> status =
      <String>['PAGADO', 'DESPACHADO', 'EN CAMINO', 'ENTREGADO'].obs;

  Future<List<Order>> getOrders(String status) async {
    return await _ordersProvider.findByStatus(status);
  }

  void goToOrderDetail(Order order) {
    Get.toNamed('/restaurant/orders/detail',
        arguments: {'order': order.toMap()});
  }
}
