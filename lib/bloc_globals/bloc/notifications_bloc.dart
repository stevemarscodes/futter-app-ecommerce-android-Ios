import 'package:australti_ecommerce_app/responses/orderStoresProduct.dart';
import 'package:flutter/material.dart';

class NotificationsBLoC with ChangeNotifier {
  List<Order> notificationsList = [];

  @override
  void dispose() {
    disposeImages();
    super.dispose();
  }

  void disposeImages() {}
}

final notificationsList = NotificationsBLoC();
