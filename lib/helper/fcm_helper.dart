import 'dart:io';
import 'dart:math';

import 'package:demo_push_notification/model/push_data.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../model/push_notification.dart';

class FCMHelper {
  FCMHelper._();

  static final FCMHelper _fcmHelper = FCMHelper._();

  factory FCMHelper() {
    return _fcmHelper;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /*Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint("_firebaseMessagingBackgroundHandler message: ${message.data}");
    if (Platform.isAndroid) {
      PushNotification pushNotification = PushNotification.fromJson(message);
      debugPrint(
          "_firebaseMessagingBackgroundHandler pushNotification.data: ${pushNotification
              .data}");
      if (pushNotification.data != null) {
        debugPrint('showNotification');
        showNotification(pushNotification.data!, Random().nextInt(100));
      } else {
        debugPrint('_firebaseMessagingBackgroundHandler pushNotification.data is NULL');
      }
    }
  }*/

  // For show the notification when App is in FG.
  // Make sure you added proper name for icon. If it is not proper then notification will not come when app in Fg.
  static const AndroidNotificationDetails _androidNotificationDetails =
  AndroidNotificationDetails(
    '1',
    'FCM Push',
    channelDescription:
    "This channel is responsible for all the local notifications",
    ticker: 'ticker',
    icon: "mipmap/ic_launcher",
    playSound: true,
    autoCancel: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  static const DarwinNotificationDetails _iOSNotificationDetails =
  DarwinNotificationDetails();

  NotificationDetails notificationDetails = const NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iOSNotificationDetails,
  );

  // For handle notification click when app is in FG.
  static var initializationSettingsAndroid =
  const AndroidInitializationSettings('mipmap/ic_launcher');

  static var initializationSettingsIOS = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: false,
    requestAlertPermission: true,
  );

  static var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  init() async {
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    debugPrint("token: ${await FirebaseMessaging.instance.getToken()}");

    // called when app is in FG and Push notification come
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("FirebaseMessaging.onMessage message: ${message.data}");
      if (Platform.isAndroid) {
        PushNotification pushNotification = PushNotification.fromJson(message);
        debugPrint(
            "FirebaseMessaging.onMessage pushNotification.data: ${pushNotification
                .data}");
        if (pushNotification.data != null) {
          debugPrint('showNotification');
          showNotification(pushNotification.data!, Random().nextInt(100));
        } else {
          debugPrint('pushNotification.data is NULL');
        }
      }
    });

    // called when a user presses a notification message and our app comes from BG to FG.
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint(
          "FirebaseMessaging.onMessageOpenedApp message: ${message.data}");
      PushNotification pushNotification = PushNotification.fromJson(message);
      if (pushNotification.data != null) {
        takeAction(pushNotification.data?.dataRedirect);
      }
    });

    // called when a user presses a notification message and our app comes from killed to FG
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      debugPrint("FirebaseMessaging.getInitialMessage: ${message?.data}");

      if (message != null) {
        PushNotification pushNotification = PushNotification.fromJson(message);
        if (pushNotification.data != null) {
          takeAction(pushNotification.data?.dataRedirect);
        }
      }
    });
  }

  // For show the notification when App is in FG. In BG and Killed state no need to call.
  // Firebase automatically show in those case.
  Future<void> showNotification(PushData pushNotificationData, int id) async {
    debugPrint('id: $id');
    debugPrint('dataTitle: ${pushNotificationData.dataTitle}');
    debugPrint('dataBody: ${pushNotificationData.dataBody}');

    await flutterLocalNotificationsPlugin.show(
        id,
        pushNotificationData.dataTitle,
        pushNotificationData.dataBody,
        notificationDetails,
        payload: pushNotificationData.dataRedirect);

    debugPrint('showNotification completed');

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onTapNotification,
        onDidReceiveBackgroundNotificationResponse: onTapNotification,
    );
  }

  //Called when notification clicked in FG
  onTapNotification(NotificationResponse notificationResponse) {
    debugPrint('onTapNotification payload: ${notificationResponse.payload}');
    takeAction(notificationResponse.payload);
  }

  // Take action on Notification click
  takeAction(String? extraString) {
    debugPrint("Take Action: $extraString");
  }
}