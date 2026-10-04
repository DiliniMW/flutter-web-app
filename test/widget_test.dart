import 'package:dili_portfolio/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('terminal portfolio switches panes', (tester) async {
    await tester.pumpWidget(const DiliPortfolio());
    expect(find.text('DILINI.EXE'), findsOneWidget);
    expect(find.text('DILINI'), findsOneWidget);
    await tester.tap(find.text(r'$ cat about.md'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('[01]  ABOUT_ME.md'), findsOneWidget);
    expect(find.textContaining('ARM64 Android kernel module'), findsOneWidget);
  });
}
