import 'package:app_delivery/pages/client/home/client_home_controller.dart';
import 'package:app_delivery/pages/pages.dart';
import 'package:app_delivery/widgets/custom_animated_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

//Pantalla por defecto para los usuarios, rol cliente

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

ClientHomeController homeCtrl = Get.put(ClientHomeController());

class _ClientHomePageState extends State<ClientHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _bottomBar(),
        body: Obx(() => IndexedStack(index: homeCtrl.indexTab.value, children: [
              ClientProductsListPage(),
              const ClientOrderListPage(),
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
      selectedIndex: homeCtrl.indexTab.value,
      onItemSelected: (index) => homeCtrl.changeTab(index),
      items: [
        BottomNavyBarItem(
            icon: const Icon(Icons.home),
            title: const Text('Productos'),
            activeColor: Colors.white,
            inactiveColor: Colors.black),
        BottomNavyBarItem(
            icon: const Icon(FontAwesomeIcons.list),
            title: const Text('Mis pedidos'),
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
