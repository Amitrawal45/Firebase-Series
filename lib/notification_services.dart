import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> BackgroundHandler(RemoteMessage remoteMessage) async {
  print("${remoteMessage.notification!.title}");
}

class Notification_Services {
  static Future<void> initialize() async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.requestPermission();

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(BackgroundHandler);

      FirebaseMessaging.onMessage.listen((message) {
        print("${message.notification!.title}");
      });

      print("Message Authorized");
    }
  }
}
