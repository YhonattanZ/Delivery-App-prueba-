import 'package:app_delivery/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsProvider {
  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  void initPushNotification() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  void onMessageListener() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {}
    });
    //APP EN PRIMER PLANO
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      RemoteNotification? notification = remoteMessage.notification;
      AndroidNotification? android = remoteMessage.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        _plugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(_channel.id, _channel.name,
                    icon: "launch_background")));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('ON MESSAGE OPENED APP');
    });
  }

  void saveToken(String idUser) async {
    String? token = await FirebaseMessaging.instance.getToken();
    UsersProvider _users = UsersProvider();
    if (token != null) {
      await _users.updateNotificationToken(idUser, token);
    }
  }
}
