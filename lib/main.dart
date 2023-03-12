import 'package:app_delivery/pages/pages.dart';
import 'package:app_delivery/pages/roles/roles_page.dart';
import 'package:app_delivery/providers/push_notifications_provider.dart';
import 'package:app_delivery/src/models/models.dart';
import 'package:app_delivery/utils/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {});
PushNotificationsProvider _pushNotificationsProvider =
    PushNotificationsProvider();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await setupFlutterNotifications();
  //showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('RECIBIENDO PUSH NOTIFICATIONS ${message.messageId}');
}

void main() async {
  //Persistir datos de la sesion del usuario
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _pushNotificationsProvider.initPushNotification();
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
    _pushNotificationsProvider.onMessageListener();
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
              : '/client/home'
          : '/login',
      getPages: [
        GetPage(name: '/register', page: () => const SignUpPage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/roles', page: () => const RolesPage()),
        //Rutas Rol Restaurant
        GetPage(
            name: '/restaurant/orders/list',
            page: () => const RestaurantOrderListPage()),
        GetPage(
            name: '/restaurant/home', page: () => const RestaurantHomePage()),
        GetPage(
            name: '/restaurant/orders/detail',
            page: () => RestaurantOrderDetailPage()),
        //Rutas Rol Delivery
        GetPage(name: '/delivery/home', page: () => const DeliveryHomePage()),
        GetPage(
            name: '/delivery/orders/list',
            page: () => const DeliveryOrderListPage()),
        GetPage(
            name: '/delivery/orders/detail',
            page: () => DeliveryOrderDetailPage()),
        GetPage(
            name: '/delivery/orders/map', page: () => DeliveryOrdersMapPage()),
        //Rutas Rol Cliente
        GetPage(name: '/client/home', page: () => const ClientHomePage()),
        GetPage(
            name: '/client/profile/info',
            page: () => const ClientProfileInfoPage()),
        GetPage(
            name: '/client/update/info',
            page: () => const ClientProfileUpdatePage()),
        GetPage(
            name: '/client/products/list',
            page: () => ClientProductsListPage()),
        GetPage(
            name: '/client/address/create',
            page: () => ClientAddressCreatePage()),
        GetPage(
            name: '/client/address/list', page: () => ClientAddressListPage()),
        GetPage(
            name: '/client/address/map', page: () => ClientAddressMapPage()),
        GetPage(
            name: '/client/orders/create', page: () => ClientOrderCreatePage()),
        GetPage(
            name: '/client/orders/detail', page: () => ClientOrderDetailPage()),
        GetPage(name: '/client/orders/map', page: () => ClientOrdersMapPage()),
        GetPage(
            name: '/client/payments/create',
            page: () => ClientPaymentsCreatePage()),
        GetPage(
            name: '/client/payments/installments',
            page: () => ClientPaymentsInstallmentsPage()),
        GetPage(
            name: '/client/payments/status',
            page: () => ClientPaymentStatusPage()),
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
