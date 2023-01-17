import 'package:app_delivery/pages/pages.dart';
import 'package:app_delivery/pages/restaurant/categories/create/restaurant_create_categories.dart';
import 'package:app_delivery/pages/restaurant/home/restaurant_home_controller.dart';
import 'package:app_delivery/widgets/custom_animated_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

//Pantalla por defecto para los usuarios, rol cliente
RestaurantHomeController restaurantCtrl = Get.put(RestaurantHomeController());

class RestaurantHomePage extends StatelessWidget {
  const RestaurantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(
            () => IndexedStack(index: restaurantCtrl.indexTab.value, children: [
                  const RestaurantOrderListPage(),
                  const RestaurantCategoriesCreatePage(),
                  const RestaurantProductCreatePage(),
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
      selectedIndex: restaurantCtrl.indexTab.value,
      onItemSelected: (index) => restaurantCtrl.changeTab(index),
      items: [
        BottomNavyBarItem(
            icon: const Icon(Icons.list),
            title: const Text('Pedidos'),
            activeColor: Colors.white,
            inactiveColor: Colors.black),
        BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.book),
            title: const Text('Categorias'),
            activeColor: Colors.white,
            inactiveColor: Colors.black),
        BottomNavyBarItem(
            icon: const Icon(Icons.restaurant),
            title: const Text('Productos'),
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
