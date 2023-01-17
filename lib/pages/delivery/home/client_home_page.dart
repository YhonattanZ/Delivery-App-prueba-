import 'package:app_delivery/pages/client/home/client_home_controller.dart';
import 'package:app_delivery/pages/pages.dart';
import 'package:app_delivery/pages/restaurant/categories/create/restaurant_create_categories.dart';
import 'package:app_delivery/widgets/custom_animated_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

//Pantalla por defecto para los usuarios, rol cliente
ClientHomeController clientCtrl = Get.put(ClientHomeController());

class ClientHomePage extends StatelessWidget {
  const ClientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(() =>
            IndexedStack(index: clientCtrl.indexTab.value, children: const [
              RestaurantCategoriesCreatePage(),
              RestaurantOrderListPage(),
              DeliveryOrderListPage(),
              ClientProfileInfoPage()
            ])));
  }
}

Widget _bottomBar() {
  return Obx(
    () => CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: const Color.fromARGB(255, 43, 136, 134),
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: clientCtrl.indexTab.value,
      onItemSelected: (index) => clientCtrl.changeTab(index),
      items: [
        BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Pedidos'),
            activeColor: Colors.white,
            inactiveColor: Colors.black),
        BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.list),
            title: const Text('Crear categoria'),
            activeColor: Colors.white,
            inactiveColor: Colors.black),
        BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.list),
            title: const Text('Crear producto'),
            activeColor: Colors.white,
            inactiveColor: Colors.black),
        BottomNavyBarItem(
            icon: const Icon(Icons.person),
            title: const Text('Mi perfil'),
            activeColor: Colors.white,
            inactiveColor: Colors.black),
      ],
    ),
  );
}
