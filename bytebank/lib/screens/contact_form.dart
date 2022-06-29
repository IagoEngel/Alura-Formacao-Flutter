import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full name',
              ),
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: TextField(
                controller: _accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account number',
                ),
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  final String name = _nameController.text;
                  final int accountNumber = int.tryParse(_accountNumberController.text);

                  final Contact newContact = Contact(0, name, accountNumber);
                  _save(dependencies.contactDAO, newContact, context);
                },
                child: Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save(ContactDAO contactDAO, Contact newContact, BuildContext context) async {
    await contactDAO.save(newContact);
    Navigator.pop(context);
  }
}
