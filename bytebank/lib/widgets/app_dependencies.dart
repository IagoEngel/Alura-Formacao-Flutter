import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:flutter/material.dart';

class AppDependencies extends InheritedWidget {
  final ContactDAO contactDAO;
  final TransactionWebClient transactionWebClient;

  AppDependencies({
    @required this.contactDAO,
    @required this.transactionWebClient,
    @required Widget child,
  }) : super(child: child);

  static AppDependencies of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppDependencies>();

  @override
  bool updateShouldNotify(covariant AppDependencies oldWidget) {
    return contactDAO != oldWidget.contactDAO ||
        transactionWebClient != oldWidget.transactionWebClient;
  }
}
