import 'package:bytebank/components/localization/eager_localization.dart';
import 'package:bytebank/components/localization/i18n_message.dart';
import 'package:flutter/cupertino.dart';

class DashboardViewLazyI18N {  
  final I18NMessages _messages;

  DashboardViewLazyI18N(this._messages);

  String get transfer => _messages.get("transfer");

  String get transfer_feed => _messages.get("transaction_feed");

  String get change_name => _messages.get("change_name");

}

class DashboardViewI18N extends ViewI18N{
  DashboardViewI18N(BuildContext context): super(context);

  String get transfer => localize({"pt-br":"Transferir", "en": "Transfer"});

  String get transfer_feed => localize({"pt-br": "Transações", "en": "Transaction feed"});

  String get change_name => localize({"pt-br":"Mudar nome", "en": "Change name"});
}