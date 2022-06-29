import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../matchers/matcher.dart';

void main() {
  testWidgets('Verificar se a imagem dentro de Dashboard é renderizada',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final image = find.byType(Image);
    expect(image, findsOneWidget);
  });

  testWidgets(
      'Verificar se o Transfer FeatureItem dentro de Dashboard é renderizado',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    // final iconTransferFeatureItem = find.widgetWithIcon(FeatureItem, Icons.monetization_on);
    // expect(iconTransferFeatureItem, findsOneWidget);
    // final nameTransferFeatureItem = find.widgetWithText(FeatureItem, 'Transfer');
    // expect(nameTransferFeatureItem, findsOneWidget);
    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
    expect(transferFeatureItem, findsOneWidget);
  });

  testWidgets(
      'Verificar se o Transaction Feed FeatureItem dentro de Dashboard é renderizado',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final transactionFeedFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transaction Feed', Icons.description));
    expect(transactionFeedFeatureItem, findsOneWidget);
  });
}
