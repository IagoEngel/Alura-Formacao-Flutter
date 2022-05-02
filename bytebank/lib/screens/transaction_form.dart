import 'dart:async';

import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transaction_webclient.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final TransactionWebClient _webClient = TransactionWebClient();
  final String _transactionId = Uuid().v4();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                child: Progress(
                  message: 'Sending...',
                ),
                visible: _sending,
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(_transactionId, value, widget.contact);
                      showDialog(
                        context: context,
                        builder: (contextDialog) {
                          return TransactionAuthDialog(
                            onConfirm: (String password) {
                              _save(transactionCreated, password, context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(Transaction transactionCreated, String password,
      BuildContext context) async {
    setState(() {
      _sending = true;
    });
    final Transaction transaction =
        await _webClient.save(transactionCreated, password).catchError(
      (e) {
        if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
          FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
          FirebaseCrashlytics.instance
              .setCustomKey('http_body', transactionCreated.toString());
          FirebaseCrashlytics.instance.recordError(e.message, null);
        }

        _showFailureMessage(context, message: e.message);
      },
      test: (e) => e is HttpException,
    ).catchError(
      (e) {
        if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
          FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
          FirebaseCrashlytics.instance.setCustomKey('http_code', e.statusCode);
          FirebaseCrashlytics.instance
              .setCustomKey('http_body', transactionCreated.toString());
          FirebaseCrashlytics.instance.recordError(e.message, null);
        }

        _showFailureMessage(context,
            message: 'timeout submitting the transaction');
      },
      test: (e) => e is TimeoutException,
    ).catchError(
      (e) {
        if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled) {
          FirebaseCrashlytics.instance.setCustomKey('exception', e.toString());
          FirebaseCrashlytics.instance
              .setCustomKey('http_body', transactionCreated.toString());
          FirebaseCrashlytics.instance.recordError(e.message, null);
        }

        _showFailureMessage(context);
      },
    ).whenComplete(() {
      setState(() {
        _sending = false;
      });
    });

    _showSucessfulMessage(transaction, context);
  }

  Future _showSucessfulMessage(
      Transaction transaction, BuildContext context) async {
    if (transaction != null) {
      await showDialog(
        context: context,
        builder: (contextDialog) {
          return SuccessDialog('sucessul transaction');
        },
      );
      Navigator.pop(context);
    }
  }

  void _showFailureMessage(BuildContext context,
      {String message = 'Unknown error'}) {
    showDialog(
      context: context,
      builder: (_) => NetworkGiffyDialog(
        image: Image.asset('images/error.gif'),
        title: Text('OPS',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
        description: Text(
          message,
          textAlign: TextAlign.center,
        ),
        entryAnimation: EntryAnimation.TOP,
        onOkButtonPressed: () {},
      ),
    );

    // showToast(message, gravity: Toast.BOTTOM);

    // final snackBar = SnackBar(content: Text(message));
    // _scaffoldKey.currentState.showSnackBar(snackBar);

    // showDialog(
    //   context: context,
    //   builder: (contextDialog) {
    //     return FailureDialog(message);
    //   },
    // );
  }

  void showToast(String msg, {int duration = 5, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
