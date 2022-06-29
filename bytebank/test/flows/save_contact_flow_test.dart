import 'package:bytebank/main.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/mocks.dart';
import 'interactions.dart';

void main() {
  MockContactDAO mockContactDAO;

  setUp(()async{
    mockContactDAO = MockContactDAO();
  });

  testWidgets('Salvar contato', (tester) async {
    await tester.pumpWidget(BytebankApp(contactDAO: mockContactDAO));

    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    await clickOnTheTransferFeatureItem(tester);
    await tester.pumpAndSettle();

    final contactsList = find.byType(ContactsList);
    expect(contactsList, findsOneWidget);

    verify(mockContactDAO.findAll()).called(1);

    await clickOnTheFabNew(tester);
    await tester.pumpAndSettle();

    final contactForm = find.byType(ContactForm);
    expect(contactForm, findsOneWidget);

    await fillTextFieldWithTextLabel(tester, text: 'Iago', labelText: 'Full name');

    await fillTextFieldWithTextLabel(tester, text: '1001', labelText: 'Accocunt number');

    await clickOntheElevatedButtonWithText(tester, 'Create');
    await tester.pumpAndSettle();

    verify(mockContactDAO.save(Contact(0, 'Iago', 1001)));

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack, findsOneWidget);

    verify(mockContactDAO.findAll());
  });
}
