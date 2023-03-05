import 'package:app_delivery/pages/client/payments/status/client_payments_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClientPaymentStatusPage extends StatelessWidget {
  ClientPaymentStatusPage({super.key});

  final ClientPaymentStatusControllers statusControllers =
      Get.put(ClientPaymentStatusControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
