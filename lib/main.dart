import 'package:app_delivery/pages/pages.dart';
import 'package:app_delivery/pages/roles/roles_page.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});

void main() async {
  //Persistir datos de la sesion del usuario
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    print('Sesion ${userSession.toJson()}');
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          disabledColor: Colors.grey[200],
          inputDecorationTheme: InputDecorationTheme(
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 43, 136, 134)),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 43, 136, 134)),
                  borderRadius: BorderRadius.circular(10)))),
      debugShowCheckedModeBanner: false,
      title: 'Delivery App Udemy',
      initialRoute: userSession.id != null
          ? userSession.roles!.length > 1
              ? '/roles'
              : '/client/products/list'
          : '/login',
      getPages: [
        GetPage(name: '/register', page: () => SignUpPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/roles', page: () => RolesPage()),
        GetPage(
            name: '/client/products/list',
            page: () => ClientProductsListPage()),
        GetPage(
            name: '/delivery/orders/list', page: () => DeliveryOrderListPage()),
        GetPage(
            name: '/restaurant/orders/list',
            page: () => RestaurantOrderListPage()),
      ],
      navigatorKey: Get.key,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
