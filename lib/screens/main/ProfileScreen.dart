// ignore_for_file: file_names

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:tires_app_web/constants/colors.dart';
import 'package:tires_app_web/providers/auth_provider.dart';
import 'package:tires_app_web/providers/cart_provider.dart';
import 'package:tires_app_web/routes/router.dart';
import 'package:tires_app_web/services/languages.dart';
import 'package:tires_app_web/widgets/notifications.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isObsured = true;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final CartProvider cartProvider = Provider.of<CartProvider>(context);

    _controller.text = authProvider.user.password;
    _controller2.text = authProvider.user.name;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: appColor,
          title: Image.asset(
            "assets/whiteLogo.png",
            height: 40,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(
                        authProvider.user.name[authProvider.user.name.length -
                            (authProvider.user.name.length)],
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextField(
                            readOnly: true,
                            controller: _controller2,
                            onChanged: (e) {},
                            cursorColor: textColorDark,
                            decoration: InputDecoration(
                                focusColor: appColor,
                                labelStyle:
                                    const TextStyle(color: textColorDark),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: textColorDark),
                                    borderRadius: BorderRadius.circular(2)),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                label: Text(
                                    langs[authProvider.langIndex]['login'])),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: TextField(
                            controller: _controller,
                            onChanged: (e) {},
                            readOnly: true,
                            cursorColor: textColorDark,
                            obscureText: isObsured,
                            decoration: InputDecoration(
                              focusColor: appColor,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isObsured
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: textColorDark,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isObsured = !isObsured;
                                  });
                                },
                              ),
                              labelStyle: const TextStyle(color: textColorDark),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: textColorDark),
                                  borderRadius: BorderRadius.circular(2)),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              label: Text(
                                  langs[authProvider.langIndex]['password']),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.router.push(const OrdersRoute());
                      },
                      child: Text(
                        langs[authProvider.langIndex]['myOrders'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        authProvider.user.act_sverki
                            ? context.router.push(const CollationActRoute())
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      child: Text(
                        langs[authProvider.langIndex]['akt_sverki'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        authProvider.user.act_sverki_detail
                            ? context.router
                                .push(const CollationActDetailRoute())
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      child: Text(
                        langs[authProvider.langIndex]['akt_sverki_detail'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        authProvider.user.bonus
                            ? context.router.push(const AccountBonusRoute())
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      child: Text(
                        langs[authProvider.langIndex]['account_bonus'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        authProvider.user.deficit
                            ? context.router.push(const DeficitRoute())
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      child: Text(
                        langs[authProvider.langIndex]['deficit_list'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        authProvider.user.subdivision_access
                            ? authProvider.showAllSubdivision(context)
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      child: Text(
                        langs[authProvider.langIndex]['subdivision'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await cartProvider.checkRate();
                        authProvider.showAlert(
                            context,
                            "Курс валюты: " +
                                cartProvider.course_rate.toString(),
                            AlertType.success);
                      },
                      child: Text(
                        langs[authProvider.langIndex]['exchange'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.router.push(OpinionRoute());
                      },
                      child: Text(
                        langs[authProvider.langIndex]['review'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await cartProvider.checkBalance(authProvider.user);
                        authProvider.user.balance
                            ? authProvider.showAlert(
                                context,
                                cartProvider.balance.toString(),
                                AlertType.success)
                            : authProvider.showAlert(
                                context, "Доступ запрещен", AlertType.error);
                      },
                      child: Text(
                        langs[authProvider.langIndex]['balance'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.router.push(ChangeLanguageRoute());
                      },
                      child: Text(
                        langs[authProvider.langIndex]['changeLangText'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.router.push(SettingsRoute());
                      },
                      child: Text(
                        langs[authProvider.langIndex]["settings"],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await context.read<AuthProvider>().logout(context);
                      },
                      child: Text(
                        langs[authProvider.langIndex]["logout"],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
