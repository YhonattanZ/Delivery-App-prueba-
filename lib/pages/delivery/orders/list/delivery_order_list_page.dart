import 'package:app_delivery/pages/delivery/orders/list/delivery_order_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryOrderListPage extends StatefulWidget {
  const DeliveryOrderListPage({super.key});

  @override
  State<DeliveryOrderListPage> createState() => _DeliveryOrderListPageState();
}

DeliveryOrderListController deliveryCtrl =
    Get.put(DeliveryOrderListController());

class _DeliveryOrderListPageState extends State<DeliveryOrderListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Delivery Orders List')),
    );
  }
}
