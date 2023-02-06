import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tires_app_web/providers/auth_provider.dart';
import 'package:tires_app_web/providers/cart_provider.dart';
import 'package:tires_app_web/providers/products_provider.dart';
import 'package:tires_app_web/screens/MainScreen.dart';
import 'package:tires_app_web/screens/auth/LoginScreen.dart';
import 'package:tires_app_web/services/background_fetch.dart';
import 'package:tires_app_web/services/firebase_notification_handler.dart';
import 'package:tires_app_web/widgets/notifications.dart';
// import 'package:workmanager/workmanager.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({Key? key}) : super(key: key);

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  late String _token;
  late Stream<String> _tokenStream;
  int notificationCount = 0;

  void setToken(String? token) {
    print('FCM TokenToken: $token');
    setState(() {
      _token = token!;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    getPermission();
    messageListener(context);
    // Workmanager().initialize(
    //   callbackDispatcher,
    //   isInDebugMode: false,
    // );

    // Workmanager().registerPeriodicTask("1", getProducts,
    //     frequency: const Duration(minutes: 30));

    // Workmanager().registerPeriodicTask(
    //   "2",
    //   dropUser,
    //   frequency: const Duration(minutes: 30),
    // );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    Future.delayed(Duration.zero, () {
      if (authProvider.hasConnect == false) {}
    });
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: authProvider.isAuth ? MainScreen() : LoginScreen());
  }
}

Future<void> getPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
}

void messageListener(BuildContext context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print(
          'Message also contained a notification: ${message.notification!.body}');
      showDialog(
          context: context,
          builder: ((BuildContext context) {
            return DynamicDialog(
                title: message.notification!.title,
                body: message.notification!.body);
          }));
      Provider.of<ProductProvider>(context).getSynchronization(context);
      Provider.of<CartProvider>(context).checkOrders();
    }
  });
}

class DynamicDialog extends StatefulWidget {
  final title;
  final body;
  DynamicDialog({this.title, this.body});
  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: [],
      content: Text(widget.body),
    );
  }
}
