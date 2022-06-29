import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/models/transaction.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../matchers/matcher.dart';
import '../mocks/mocks.dart';
import 'interactions.dart';

void main() {
  testWidgets('Should transfer to contact', (tester) async {
    final mockContactDAO = MockContactDAO();
    final mockTransactionWebClient = MockTransactionWebClient();
    await tester.pumpWidget(BytebankApp(
        transactionWebClient: mockTransactionWebClient,
        contactDAO: mockContactDAO));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final iago = Contact(0, 'Iago Serafim', 1112);
    when(mockContactDAO.findAll()).thenAnswer((invocation) async => [iago]);

    await clickOnTheTransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDAO.findAll()).called(1);

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == 'Iago Serafim' &&
            widget.contact.accountNumber == 1112;
      }
      return false;
    });
    expect(contactItem, findsOneWidget);
    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

    final contactName = find.text('Iago Serafim');
    expect(contactName, findsOneWidget);
    final contactAccountNumber = find.text('1112');
    expect(contactAccountNumber, findsOneWidget);

    final textFieldValue = find.byWidgetPredicate(
        (widget) => textFieldByLabelTextMatcher(widget, 'Value'));
    expect(textFieldValue, findsOneWidget);
    await tester.enterText(textFieldValue, '200');

    final transferButton = find.widgetWithText(ElevatedButton, 'Transfer');
    expect(transferButton, findsOneWidget);
    await tester.tap(transferButton);
    await tester.pumpAndSettle();

    final transactionAuthDialog = find.byType(TransactionAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    final textFieldPassword = find.byKey(transactionAuthDialogTextFieldPasswordKey);
    expect(textFieldPassword, findsOneWidget);
    await tester.enterText(textFieldPassword, '1000');

    final cancelButton = find.widgetWithText(ElevatedButton, 'Cancel');
    expect(cancelButton, findsOneWidget);
    final confirmButton = find.widgetWithText(ElevatedButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    when(mockTransactionWebClient.save(Transaction(null, 200, iago), '1000'))
        .thenAnswer((_) async => Transaction(null, 200, iago));

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    final successDialog = find.byType(SuccessDialog);
    expect(successDialog, findsOneWidget);

    final successButton = find.widgetWithText(FlatButton, 'Ok');
    expect(successButton, findsOneWidget);
    await tester.tap(successButton);
    await tester.pumpAndSettle();

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);
  });
}
