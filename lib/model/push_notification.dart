import 'package:demo_push_notification/model/push_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotification {
  PushNotification({this.title, this.body, required this.data});

  String? title;
  String? body;
  PushData? data;

  PushNotification.fromJson(RemoteMessage message) {
    title = message.notification?.title;
    body = message.notification?.body;
    data = message.data.isNotEmpty ? PushData.fromJson(message.data) : null;
  }
}
