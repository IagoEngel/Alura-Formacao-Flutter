import 'package:flutter/material.dart';

const Key transactionAuthDialogTextFieldPasswordKey = Key('transactionAuthDialogTextFieldPassword');

class TransactionAuthDialog extends StatefulWidget {
  final Function(String password) onConfirm;

  TransactionAuthDialog({@required this.onConfirm});

  @override
  _TransactionAuthDialogState createState() => _TransactionAuthDialogState();
}

class _TransactionAuthDialogState extends State<TransactionAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Authentication'),
      content: TextField(
        key: transactionAuthDialogTextFieldPasswordKey,
        controller: _passwordController,
        obscureText: true,
        maxLength: 4,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 64, letterSpacing: 24),
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onConfirm(_passwordController.text);
            Navigator.pop(context);
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
