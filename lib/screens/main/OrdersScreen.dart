import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tires_app_web/constants/colors.dart';
import 'package:tires_app_web/providers/auth_provider.dart';
import 'package:tires_app_web/providers/cart_provider.dart';
import 'package:tires_app_web/providers/products_provider.dart';
import 'package:tires_app_web/services/languages.dart';
import 'package:tires_app_web/widgets/order_item_widget.dart';

import '../../models/Order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        centerTitle: true,
        title: Image.asset(
          "assets/whiteLogo.png",
          height: 40,
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await productProvider.getNotifications();
                cartProvider.checkOrders();
                setState(() {});
              },
              icon: const Icon(Icons.sync))
        ],
      ),
      body: Container(
        child: context.read<CartProvider>().orders.isEmpty
            ? Center(
                child: Text(langs[authProvider.langIndex]['orders-none']),
              )
            : Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: context.read<CartProvider>().orders.length,
                          itemBuilder: (ctx, index) {
                            final order =
                                context.read<CartProvider>().orders[index];
                            var statusOrder = order.status ==
                                    StatusOrder.newOrder.name
                                ? "Новый"
                                : order.status == StatusOrder.onTheWay.name
                                    ? "В пути"
                                    : order.status == StatusOrder.shipment.name
                                        ? "Отгрузка"
                                        : order.status ==
                                                StatusOrder.confirmed.name
                                            ? 'Подтвержден'
                                            : order.status ==
                                                    StatusOrder.unconfirmed.name
                                                ? "Не подтвержден"
                                                : "Отказано";

                            return OrderItem(
                                order: order, statusOrder: statusOrder);
                          }))
                ],
              ),
      ),
    );
  }
}
