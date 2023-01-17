import 'package:app_delivery/pages/restaurant/orders/list/restaurant_order_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantOrderListPage extends StatefulWidget {
  const RestaurantOrderListPage({super.key});

  @override
  State<RestaurantOrderListPage> createState() =>
      _RestaurantOrderListPageState();
}

RestaurantOrderListController restaurantlistCtrl =
    Get.put(RestaurantOrderListController());

class _RestaurantOrderListPageState extends State<RestaurantOrderListPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Restaurant Orders List')),
    );
  }
}
