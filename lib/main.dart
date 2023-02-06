import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:tires_app_web/models/Messages/Messages.dart';
import 'package:tires_app_web/models/Order.dart';
import 'package:tires_app_web/models/Orders/Orders.dart';
import 'package:tires_app_web/models/Product.dart';
import 'package:tires_app_web/models/Products/Products.dart';
import 'package:tires_app_web/models/User/User.dart';
import 'package:tires_app_web/providers/auth_provider.dart';
import 'package:tires_app_web/providers/balance_provider.dart';
import 'package:tires_app_web/providers/cart_provider.dart';
import 'package:tires_app_web/providers/products_provider.dart';
import 'package:tires_app_web/screens/SplashScreen.dart';
import 'package:tires_app_web/services/firebase_notification_handler.dart';
import 'package:tires_app_web/services/notification_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_backroundHandler);
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyBNsWU6g_Rtvctqs7VEzCx3FATJdHlpvxk',
      appId: '1:446932448926:web:384716a49e7c78be0b6d8f',
      messagingSenderId: '446932448926',
      projectId: 'agromash-message',
      storageBucket: "agromash-message.appspot.com",
    ),
  );
  await dotenv.load(fileName: "lib/.env");
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductsAdapter());
  Hive.registerAdapter(OrdersAdapter());
  Hive.registerAdapter(MessagesAdapter());

  await Hive.openBox<User>('users');
  await Hive.openBox<Product>('products');
  await Hive.openBox<Orders>('orders');
  await Hive.openBox<Messages>('messages');

  final CartProvider cartProvider = CartProvider();
  final ProductProvider productProvider = ProductProvider();
  final AuthProvider authProvider = AuthProvider();

  authProvider.getStatus();
  productProvider.getSynchronization(null);
  cartProvider.checkOrders();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => authProvider),
    ChangeNotifierProvider(create: (_) => cartProvider),
    ChangeNotifierProvider(create: (_) => productProvider),
    ChangeNotifierProvider(create: (_) => BalanceProvider()),
  ], child: SplashScreen()));
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: 'AIzaSyBNsWU6g_Rtvctqs7VEzCx3FATJdHlpvxk',
//       appId: '1:446932448926:web:384716a49e7c78be0b6d8f',
//       messagingSenderId: '446932448926',
//       projectId: 'agromash-message',
//       storageBucket: "agromash-message.appspot.com",
//     ),
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Animation',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: PushNotificationApp(),
//     );
//   }
// }

// /// Entry point for the example application.
// class PushNotificationApp extends StatefulWidget {
//   static const routeName = "/firebase-push";

//   @override
//   _PushNotificationAppState createState() => _PushNotificationAppState();
// }

// class _PushNotificationAppState extends State<PushNotificationApp> {
//   @override
//   void initState() {
//     getPermission();
//     messageListener(context);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       // Initialize FlutterFire
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         // Check for errors
//         if (snapshot.hasError) {
//           return Center(
//             child: Text(snapshot.error.toString()),
//           );
//         }
//         // Once complete, show your application
//         if (snapshot.connectionState == ConnectionState.done) {
//           print('android firebase initiated');
//           return NotificationPage();
//         }
//         // Otherwise, show something whilst waiting for initialization to complete
//         return Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }

//   Future<void> getPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;

//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );

//     print('User granted permission: ${settings.authorizationStatus}');
//   }

//   void messageListener(BuildContext context) {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');

//       if (message.notification != null) {
//         print(
//             'Message also contained a notification: ${message.notification!.body}');
//         showDialog(
//             context: context,
//             builder: ((BuildContext context) {
//               return DynamicDialog(
//                   title: message.notification!.title,
//                   body: message.notification!.body);
//             }));
//       }
//     });
//   }
// }

// class NotificationPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _Application();
// }

// class _Application extends State<NotificationPage> {
//   late String _token;
//   late Stream<String> _tokenStream;
//   int notificationCount = 0;

//   void setToken(String? token) {
//     print('FCM TokenToken: $token');
//     setState(() {
//       _token = token!;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     //get token
//     FirebaseMessaging.instance.getToken().then(setToken);
//     _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
//     _tokenStream.listen(setToken);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Firebase push notification'),
//         ),
//         body: Container(
//           child: Center(
//             child: Card(
//               margin: EdgeInsets.all(10),
//               elevation: 10,
//               child: ListTile(
//                 title: Center(
//                   child: OutlinedButton.icon(
//                     label: Text('Push Notification',
//                         style: TextStyle(
//                             color: Colors.blueAccent,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16)),
//                     onPressed: () {
//                       sendPushMessageToWeb();
//                     },
//                     icon: Icon(Icons.notifications),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }

//   //send notification
//   sendPushMessageToWeb() async {
//     if (_token == null) {
//       print('Unable to send FCM message, no token exists.');
//       return;
//     }
//     try {
//       await http
//           .post(
//             Uri.parse('https://fcm.googleapis.com/fcm/send'),
//             headers: <String, String>{
//               'Content-Type': 'application/json',
//               'Authorization': 'key=YOUR SERVER KEY'
//             },
//             body: json.encode({
//               'to': _token,
//               'message': {
//                 'token': _token,
//               },
//               "notification": {
//                 "title": "Push Notification",
//                 "body": "Firebase  push notification"
//               }
//             }),
//           )
//           .then((value) => print(value.body));
//       print('FCM request for web sent!');
//     } catch (e) {
//       print(e);
//     }
//   }
// }

// //push notification dialog for foreground
// class DynamicDialog extends StatefulWidget {
//   final title;
//   final body;
//   DynamicDialog({this.title, this.body});
//   @override
//   _DynamicDialogState createState() => _DynamicDialogState();
// }

// class _DynamicDialogState extends State<DynamicDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(widget.title),
//       actions: <Widget>[
//         OutlinedButton.icon(
//             label: Text('Close'),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.close))
//       ],
//       content: Text(widget.body),
//     );
//   }
// }
