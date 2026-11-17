import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_3/main.dart';

void main() {
  testWidgets('successful login opens the home page', (tester) async {
    await tester.pumpWidget(const NusanetApp());
    await tester.pumpAndSettle();

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '81234567890');
    await tester.enterText(fields.at(1), '123456');
    await tester.tap(find.text('Masuk'));
    await tester.pump(const Duration(milliseconds: 950));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('PULSA'), findsOneWidget);

    await tester.tap(find.text('Packages'));
    await tester.pumpAndSettle();
    expect(find.text('Beli Paket Internet'), findsOneWidget);

    await tester.tap(find.text('Promo'));
    await tester.pumpAndSettle();
    expect(find.text('Promo & Penawaran Spesial'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('Pengaturan Akun'), findsOneWidget);
  });

  testWidgets('login page opens the registration form', (tester) async {
    await tester.pumpWidget(const NusanetApp());
    await tester.pumpAndSettle();

    expect(find.text('Masuk ke Nusanet'), findsOneWidget);

    final registerLink = find.text('Daftar di sini');
    await tester.ensureVisible(registerLink);
    await tester.tap(registerLink);
    await tester.pumpAndSettle();

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Nama Lengkap'), findsOneWidget);
  });
}
