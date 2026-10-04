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

    await tester.tap(find.text(r'$ cd ./fitgif'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('fitgif_render.output // FEATURED BUILD'), findsOneWidget);
    expect(find.text('01 // SIGN-UP FLOW'), findsOneWidget);
    expect(find.text('04 // WELCOME SCREEN'), findsOneWidget);
  });
}
