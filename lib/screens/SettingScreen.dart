import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tires_app_web/providers/auth_provider.dart';
import 'package:tires_app_web/providers/cart_provider.dart';
import 'package:tires_app_web/routes/router.dart';
import 'package:tires_app_web/services/languages.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(langs[authProvider.langIndex]['settings']),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                cartProvider.deleteData();
              },
              child: Text(
                langs[authProvider.langIndex]['delete_all'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
          ],
        ),
      )),
    );
  }
}
