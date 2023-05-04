# FCM Push Notification

## Create project in Firebase
- Set up a Firebase project in the [Firebase Console](https://console.firebase.google.com/)
- Add your Android and/or iOS apps to the Firebase project and download the google-services.json and/or GoogleService-Info.plist files for each app.

## Firebase Configuration 

For help getting started with FCM Push Notification in Flutter visit the below link to configure Firebase in Flutter project.
[Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup?platform=android)

1) Install Firebase CLI in mac
   Run following command
   `curl -sL https://firebase.tools | bash`

2) Log into Firebase using your Google account by running the following command:
   `firebase login`

3) Install the FlutterFire CLI by running the following command from any directory:
   `dart pub global activate flutterfire_cli`

   **Note:** If "zsh: command not found: dart" [add flutter sdk path in .zshrc file](https://stackoverflow.com/a/63982667)

4) From your Flutter project directory, run the following command to start the app configuration workflow:
   `flutterfire configure`

   **Note:** If "zsh: command not found: flutterfire" [add this in .zshrc file](https://stackoverflow.com/a/73266852)

   After the configuration successfully completed, you can fine the Firebase configuration file in "lib/firebase_options.dart".

5) Add the below dependencies
   `flutter pub add firebase_core`
   `flutter pub add firebase_messaging`
   `flutter pub add flutter_local_notifications`

## Send Push Notification from Postman
Add the below part in the body and use POST method for 'https://fcm.googleapis.com/fcm/send' URL
```
{
  "to": "<device_Token>",
  "data": {
    "title": "App Testing",
    "body": "First Notification",
    "type": "1",
    "click_action": "Hellowww",
  },
  "android": {
    "priority": "high"
  },
  "notification": {
    "title": "Noti_title",
    "body": "Noti_body",
    "sound": "default"
  }
}
```

### In Header add the below
Authorization: key=<Firebase server key>
Content-Type: application/json

To get device_token use below code
`FirebaseMessaging.instance.getToken()`

To get Firebase Server key, you need to follow these steps:
- Go to the Firebase console and select your project.
- Click on the gear icon in the top left corner and select "Project settings".
- In the "Project settings" page, click on the "Cloud Messaging" tab.
- In the "Project credentials" section, locate the "Server key" and copy the value.