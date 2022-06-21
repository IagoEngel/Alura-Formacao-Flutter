import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/transactions_list.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: LayoutBuilder(
        builder: (context, viewportConstraints) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('images/bytebank_logo.png'),
                ),
                Container(
                  height: 108,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        children: [
                          FeatureItem(
                            'Transfer',
                            Icons.monetization_on,
                            onClick: () => _showContactList(context),
                          ),
                          FeatureItem(
                            'Transaction Feed',
                            Icons.description,
                            onClick: () => _showTransactionList(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showContactList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ContactsList()),
    );
  }

  void _showTransactionList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionsList()),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Function onClick;

  const FeatureItem(
    this.name,
    this.icon, {
    @required this.onClick,
  })  : assert(icon != null),
        assert(onClick != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: () {
            onClick();
          },
          child: Container(
            padding: EdgeInsets.all(8.0),
            width: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
