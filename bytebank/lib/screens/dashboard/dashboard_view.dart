import 'package:bytebank/components/container.dart';
import 'package:bytebank/models/name.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard/dashboard_feature_item.dart';
import 'package:bytebank/screens/dashboard/dashboard_i18n.dart';
import 'package:bytebank/screens/name.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatelessWidget {
  final DashboardViewLazyI18N _i18n;

  const DashboardView(this._i18n);

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      appBar: AppBar(
        //misturando um blocbuilder(que é um observer de eventos) com UI
        title: BlocBuilder<NameCubit, String>(
            builder: (context, state) => Text('Welcome $state')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('images/bytebank_logo.png'),
          ),
          SingleChildScrollView(
            child: Container(
              height: 108,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    children: [
                      FeatureItem(
                        _i18n.transfer,
                        Icons.monetization_on,
                        onClick: () => _showContactList(context),
                      ),
                      FeatureItem(
                        _i18n.transfer_feed,
                        Icons.description,
                        onClick: () => _showTransactionList(context),
                      ),
                      FeatureItem(
                        _i18n.change_name,
                        Icons.person_outline,
                        onClick: () => _showChangeName(context),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactList(BuildContext blocContext) {
    push(blocContext, ContactsListContainer());
  }

  void _showTransactionList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionsList()),
    );
  }

  void _showChangeName(BuildContext blocContext) {
    Navigator.push(
      blocContext,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<NameCubit>(blocContext),
          child: NameContainer(),
        ),
      ),
    );
  }
}