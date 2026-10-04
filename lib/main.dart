import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const DiliPortfolio());

const ink = Color(0xff07110e),
    panel = Color(0xff0b1713),
    panel2 = Color(0xff10221c);
const green = Color(0xff69f0ae),
    amber = Color(0xffffcb6b),
    muted = Color(0xff88a198),
    line = Color(0xff244238);

class DiliPortfolio extends StatelessWidget {
  const DiliPortfolio({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Dilini // Portfolio',
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: ink,
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'monospace'),
    ),
    home: const PortfolioHome(),
  );
}

enum Section { home, about, fitgif, projects, interfaces, contact }

extension SectionData on Section {
  String get command => switch (this) {
    Section.home => 'whoami',
    Section.about => 'cat about.md',
    Section.fitgif => 'cd ./fitgif',
    Section.projects => 'ls ./projects',
    Section.interfaces => 'open ./ui',
    Section.contact => 'ping dilini',
  };
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});
  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  Section section = Section.home;
  String typed = '';
  Timer? timer;
  late final AnimationController cursor;
  static const intro =
      'Integration & test engineer. Flutter builder. Systems thinker.';

  @override
  void initState() {
    super.initState();
    cursor = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);
    var i = 0;
    timer = Timer.periodic(const Duration(milliseconds: 42), (t) {
      if (!mounted || i == intro.length) return t.cancel();
      setState(() => typed += intro[i++]);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    cursor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: panel,
            border: Border.all(color: line),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 30)],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              WindowBar(section),
              Expanded(
                child: LayoutBuilder(
                  builder:
                      (_, c) =>
                          c.maxWidth < 760
                              ? Column(
                                children: [
                                  MobileNav(section, select),
                                  Expanded(
                                    child: Content(section, typed, cursor),
                                  ),
                                ],
                              )
                              : Row(
                                children: [
                                  SizedBox(
                                    width: 235,
                                    child: Sidebar(section, select),
                                  ),
                                  const VerticalDivider(width: 1, color: line),
                                  Expanded(
                                    child: Content(section, typed, cursor),
                                  ),
                                ],
                              ),
                ),
              ),
              StatusBar(section),
            ],
          ),
        ),
      ),
    ),
  );

  void select(Section value) => setState(() => section = value);
}

class WindowBar extends StatelessWidget {
  const WindowBar(this.section, {super.key});
  final Section section;
  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: const BoxDecoration(
      color: panel2,
      border: Border(bottom: BorderSide(color: line)),
    ),
    child: Row(
      children: [
        for (final color in const [
          Color(0xffff5f56),
          Color(0xffffbd2e),
          Color(0xff27c93f),
        ]) ...[
          Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
        ],
        const Spacer(),
        Flexible(
          child: Text(
            'dilini@portfolio:~/${section.name}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: muted, fontSize: 12),
          ),
        ),
        const Spacer(),
        const Text('UTF-8', style: TextStyle(color: muted, fontSize: 11)),
      ],
    ),
  );
}

class Sidebar extends StatelessWidget {
  const Sidebar(this.section, this.select, {super.key});
  final Section section;
  final ValueChanged<Section> select;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xff091410),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          const Text(
            'DILINI.EXE',
            style: TextStyle(
              color: green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const Text(
            'portfolio shell v2.0',
            style: TextStyle(color: muted, fontSize: 11),
          ),
          const SizedBox(height: 28),
          const Text(
            'COMMANDS',
            style: TextStyle(color: muted, fontSize: 10, letterSpacing: 2),
          ),
          const SizedBox(height: 8),
          for (final s in Section.values)
            NavItem(s, s == section, () => select(s)),
          const Spacer(),
          const Row(
            children: [
              Icon(Icons.circle, size: 8, color: green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'available for work',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: muted, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class NavItem extends StatelessWidget {
  const NavItem(this.item, this.selected, this.tap, {super.key});
  final Section item;
  final bool selected;
  final VoidCallback tap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: InkWell(
      onTap: tap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? green.withValues(alpha: .1) : null,
          border: Border(
            left: BorderSide(
              color: selected ? green : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          '\$ ${item.command}',
          style: TextStyle(color: selected ? green : muted, fontSize: 12),
        ),
      ),
    ),
  );
}

class MobileNav extends StatelessWidget {
  const MobileNav(this.section, this.select, {super.key});
  final Section section;
  final ValueChanged<Section> select;
  @override
  Widget build(BuildContext context) => Container(
    height: 55,
    decoration: const BoxDecoration(
      color: Color(0xff091410),
      border: Border(bottom: BorderSide(color: line)),
    ),
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(8),
      children: [
        for (final s in Section.values)
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: OutlinedButton(
              onPressed: () => select(s),
              style: OutlinedButton.styleFrom(
                foregroundColor: s == section ? green : muted,
                side: BorderSide(color: s == section ? green : line),
              ),
              child: Text('./${s.name}', style: const TextStyle(fontSize: 11)),
            ),
          ),
      ],
    ),
  );
}

class Content extends StatelessWidget {
  const Content(this.section, this.typed, this.cursor, {super.key});
  final Section section;
  final String typed;
  final Animation<double> cursor;
  @override
  Widget build(BuildContext context) => SelectionArea(
    child: AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      child: SingleChildScrollView(
        key: ValueKey(section),
        padding: const EdgeInsets.all(24),
        child: switch (section) {
          Section.home => HomePane(typed, cursor),
          Section.about => const AboutPane(),
          Section.fitgif => const FitGifPane(),
          Section.projects => const ProjectsPane(),
          Section.interfaces => const InterfacesPane(),
          Section.contact => const ContactPane(),
        },
      ),
    ),
  );
}

class CommandHeader extends StatelessWidget {
  const CommandHeader(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'dilini@portfolio:~\$ $text',
        style: const TextStyle(color: green, fontSize: 13),
      ),
      const SizedBox(height: 7),
      const Divider(color: line),
      const SizedBox(height: 20),
    ],
  );
}

class HomePane extends StatelessWidget {
  const HomePane(this.typed, this.cursor, {super.key});
  final String typed;
  final Animation<double> cursor;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CommandHeader('whoami --verbose'),
      const Text(
        'HELLO, I\'M',
        style: TextStyle(color: muted, letterSpacing: 3, fontSize: 12),
      ),
      const SizedBox(height: 8),
      const Text(
        'DILINI',
        style: TextStyle(
          color: green,
          fontSize: 56,
          height: .95,
          fontWeight: FontWeight.bold,
          letterSpacing: 4,
        ),
      ),
      const Text(
        'WIJETUNGE',
        style: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      const SizedBox(height: 22),
      Row(
        children: [
          Flexible(
            child: Text(
              typed,
              style: const TextStyle(color: amber, fontSize: 16),
            ),
          ),
          FadeTransition(
            opacity: cursor,
            child: Container(
              width: 9,
              height: 19,
              margin: const EdgeInsets.only(left: 3),
              color: green,
            ),
          ),
        ],
      ),
      const SizedBox(height: 32),
      const Wrap(
        spacing: 9,
        runSpacing: 9,
        children: [
          Tag('FLUTTER'),
          Tag('FIREBASE'),
          Tag('EMBEDDED'),
          Tag('CLOUD'),
          Tag('PRODUCT ENGINEERING'),
        ],
      ),
      const SizedBox(height: 32),
      const TerminalBox(
        'session.log',
        Column(
          children: [
            LogLine('education', 'DCU + ESIGELEC double degree'),
            LogLine('role', 'Junior Integration & Test Engineer @ danalto'),
            LogLine('focus', 'embedded systems + mobile products'),
            LogLine('status', 'ready to build', color: green),
          ],
        ),
      ),
    ],
  );
}

class AboutPane extends StatelessWidget {
  const AboutPane({super.key});
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CommandHeader('cat about.md'),
      PaneTitle('[01]  ABOUT_ME.md'),
      SizedBox(height: 18),
      Body(
        'I am an integration and test engineer with a general-engineering background spanning embedded systems, mobile development, system validation and product requirements.',
      ),
      SizedBox(height: 14),
      Body(
        'I enjoy working between technical and business needs: understanding how a system should behave, translating that into clear requirements, and testing whether the delivered firmware and software work as intended.',
      ),
      SizedBox(height: 22),
      TerminalBox(
        'current_role.json',
        Column(
          children: [
            LogLine('company', 'danalto'),
            LogLine('position', 'Junior Integration & Test Engineer'),
            LogLine('since', 'August 2025'),
            LogLine('work', 'system testing for firmware and software'),
            LogLine('scope', 'requirements + high-level platform design'),
          ],
        ),
      ),
      SizedBox(height: 18),
      TerminalBox(
        'background.json',
        Column(
          children: [
            LogLine('ARM', 'device performance analysis / ARM64 kernel'),
            LogLine('SLTMobitel', 'PCB design / IoT / Android robotics'),
            LogLine('education', 'DCU + ESIGELEC double degree'),
            LogLine('result', 'MEng first-class honours (1.1)', color: green),
            LogLine('languages', 'English / French / Sinhala'),
          ],
        ),
      ),
      SizedBox(height: 24),
      Text(
        '> TOOLBOX',
        style: TextStyle(color: green, fontSize: 12, letterSpacing: 1.5),
      ),
      SizedBox(height: 12),
      Wrap(
        spacing: 9,
        runSpacing: 9,
        children: [
          Tag('DART / FLUTTER'),
          Tag('C / JAVA / PYTHON'),
          Tag('FIREBASE'),
          Tag('GIT / GITHUB / GITLAB'),
          Tag('DOCKER / ANSIBLE'),
          Tag('THINGSBOARD'),
          Tag('ANDROID'),
          Tag('FIRMWARE TESTING'),
          Tag('FIGMA'),
        ],
      ),
    ],
  );
}

class FitGifPane extends StatelessWidget {
  const FitGifPane({super.key});
  static const demos = [
    (
      'SIGN-UP FLOW',
      'Account creation and onboarding',
      'https://1drv.ms/v/c/7b0e173588eaad1f/IQDf8Jk4cIRGR4NNEtoOcnkbAUGj5jPY25zAGrdDCHSOUoc',
    ),
    (
      'SPLASH SCREEN',
      'Animated application launch',
      'https://1drv.ms/v/c/7b0e173588eaad1f/IQAD81_iXieUQJpSQragZ8OpAdLc4u0U-4SnWv_Mc5LHp_c',
    ),
    (
      'RANKING REVEAL',
      'Parchment leaderboard animation',
      'https://1drv.ms/v/c/7b0e173588eaad1f/IQCCEJe3U0dTS4KD_Y1Ig9RWAU49v3MEh07WcC1EriQQ6ZU',
    ),
    (
      'WELCOME SCREEN',
      'First-run product experience',
      'https://1drv.ms/v/c/7b0e173588eaad1f/IQAi58NDVS37QapqamjqFE3IAakk6f0EMc-c4hZcx6yBizk',
    ),
  ];
  static const data = [
    (
      '01',
      'PRODUCTION MINDSET',
      'Engineered real user journeys, edge cases, account flows, workout tracking, exports and monetisation.',
    ),
    (
      '02',
      'FLOW-BY-FLOW TESTING',
      'Validated screens, services, permissions, exports and notifications as individual flows.',
    ),
    (
      '03',
      'LOG-DRIVEN DEBUGGING',
      'Turned unclear runtime failures into specific, testable engineering tasks.',
    ),
    (
      '04',
      'CLOUD INFRASTRUCTURE',
      'Connected authentication, storage, backend services, credits and subscriptions.',
    ),
    (
      '05',
      'USER-FIRST REQUIREMENTS',
      'Designed for what users expect, what can fail and what must remain clear.',
    ),
    (
      '06',
      'CODEX COLLABORATION',
      'Used focused questions, logs and assumption checks to ship working changes.',
    ),
  ];
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CommandHeader('tree ~/fitgif'),
      const PaneTitle('[02]  FITGIF // CASE STUDY'),
      const SizedBox(height: 8),
      const Body(
        'A Flutter fitness app developed from concept toward a production-ready product, one verified flow at a time.',
      ),
      const SizedBox(height: 24),
      const FeaturedGif(),
      const SizedBox(height: 28),
      const Text(
        '> FEATURE_DEMOS',
        style: TextStyle(color: green, fontSize: 12, letterSpacing: 1.5),
      ),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (_, c) {
          final w = c.maxWidth > 680 ? (c.maxWidth - 12) / 2 : c.maxWidth;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var i = 0; i < demos.length; i++)
                SizedBox(
                  width: w,
                  child: DemoCard(
                    number: '${i + 1}'.padLeft(2, '0'),
                    title: demos[i].$1,
                    description: demos[i].$2,
                    url: demos[i].$3,
                  ),
                ),
            ],
          );
        },
      ),
      const SizedBox(height: 30),
      const Text(
        '> ENGINEERING_LOG',
        style: TextStyle(color: green, fontSize: 12, letterSpacing: 1.5),
      ),
      const SizedBox(height: 12),
      LayoutBuilder(
        builder: (_, c) {
          final w = c.maxWidth > 720 ? (c.maxWidth - 12) / 2 : c.maxWidth;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final x in data)
                SizedBox(width: w, child: CaseCard(x.$1, x.$2, x.$3)),
            ],
          );
        },
      ),
    ],
  );
}

class ProjectsPane extends StatelessWidget {
  const ProjectsPane({super.key});
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CommandHeader('ls -la ./projects'),
      PaneTitle('[03]  PROJECT INDEX'),
      SizedBox(height: 18),
      ProjectRow(
        '01',
        'FitGIF',
        'Flutter · Firebase · Cloud',
        'https://github.com/DiliniMW/level-up-app',
      ),
      SizedBox(height: 12),
      ProjectRow(
        '02',
        'Low-Power MSP430 Dev Board',
        'Altium · Embedded · PCB',
        'https://github.com/DiliniMW/Reference-file-for-the-long-technical-internship-/blob/main/Low%20power%20dev%20board/low%20Power%20dev%20Board/Schematic%20Print/Schematic%20Prints.PDF',
      ),
    ],
  );
}

class InterfacesPane extends StatelessWidget {
  const InterfacesPane({super.key});
  static const data = [
    ('home.ui', 'assets/fitgif_home.png'),
    ('arcade.ui', 'assets/fitgif_arcade.png'),
    ('avatar.ui', 'assets/fitgif_avatar.png'),
    ('bluetooth.ui', 'assets/fitgif_bluetooth.png'),
    ('exercise_logger.ui', 'assets/fitgif_exercise_logger.png'),
    ('logged_exercise.ui', 'assets/fitgif_logged_exercise.png'),
    ('gif_creator.ui', 'assets/fitgif_gif_creator.png'),
    ('gif_wall.ui', 'assets/fitgif_gif_wall.png'),
    ('recipes.ui', 'assets/fitgif_recipes.png'),
    ('settings.ui', 'assets/fitgif_settings.png'),
  ];
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CommandHeader('find . -name "*.ui"'),
      const PaneTitle('[04]  UI ARCHIVE'),
      const SizedBox(height: 8),
      const Body(
        'Selected FitGIF screens. Click a file to inspect it in a preview pane.',
      ),
      const SizedBox(height: 20),
      LayoutBuilder(
        builder: (_, c) {
          final cols =
              c.maxWidth > 800
                  ? 3
                  : c.maxWidth > 480
                  ? 2
                  : 1;
          final w = (c.maxWidth - 12 * (cols - 1)) / cols;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final x in data)
                SizedBox(width: w, child: UiFile(x.$1, x.$2)),
            ],
          );
        },
      ),
    ],
  );
}

class ContactPane extends StatelessWidget {
  const ContactPane({super.key});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const CommandHeader('ping dilini --say-hello'),
      const PaneTitle('[05]  ESTABLISH A CONNECTION'),
      const SizedBox(height: 18),
      const Text(
        'Have a role, project or interesting problem?',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 10),
      const Body(
        'My inbox is open. Send a message and I will get back to you.',
      ),
      const SizedBox(height: 25),
      TerminalBox(
        'contact.sh',
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactLink(
              command: 'mail',
              label: 'dona.wijetunge@groupe-esigelec.org',
              url: 'mailto:dona.wijetunge@groupe-esigelec.org',
            ),
            ContactLink(
              command: 'open',
              label: 'linkedin.com/in/dona-dilini-wijetunge',
              url:
                  'https://www.linkedin.com/in/dona-dilini-wijetunge-410911233/',
            ),
            ContactLink(
              command: 'git',
              label: 'github.com/DiliniMW',
              url: 'https://github.com/DiliniMW',
            ),
          ],
        ),
      ),
    ],
  );
}

class ContactLink extends StatelessWidget {
  const ContactLink({
    required this.command,
    required this.label,
    required this.url,
    super.key,
  });
  final String command;
  final String label;
  final String url;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => launchURL(url),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Text(
            '\$ $command ',
            style: const TextStyle(color: muted, fontSize: 12),
          ),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: green, fontSize: 13),
            ),
          ),
          const Text('↗', style: TextStyle(color: amber)),
        ],
      ),
    ),
  );
}

class PaneTitle extends StatelessWidget {
  const PaneTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext c) => Text(
    text,
    style: const TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
  );
}

class Body extends StatelessWidget {
  const Body(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext c) => Text(
    text,
    style: const TextStyle(color: Color(0xffc5d4ce), fontSize: 15, height: 1.7),
  );
}

class Tag extends StatelessWidget {
  const Tag(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext c) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: panel2, border: Border.all(color: line)),
    child: Text('<$text/>', style: const TextStyle(color: muted, fontSize: 11)),
  );
}

class TerminalBox extends StatelessWidget {
  const TerminalBox(this.title, this.child, {super.key});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext c) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: ink,
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(9),
          decoration: const BoxDecoration(
            color: panel2,
            border: Border(bottom: BorderSide(color: line)),
          ),
          child: Text(
            title,
            style: const TextStyle(color: muted, fontSize: 11),
          ),
        ),
        Padding(padding: const EdgeInsets.all(14), child: child),
      ],
    ),
  );
}

class LogLine extends StatelessWidget {
  const LogLine(
    this.name,
    this.value, {
    this.color = const Color(0xffc5d4ce),
    super.key,
  });
  final String name, value;
  final Color color;
  @override
  Widget build(BuildContext c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '"$name":',
            style: const TextStyle(color: amber, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            '"$value"',
            style: TextStyle(color: color, fontSize: 12, height: 1.4),
          ),
        ),
      ],
    ),
  );
}

class CaseCard extends StatelessWidget {
  const CaseCard(this.no, this.title, this.text, {super.key});
  final String no, title, text;
  @override
  Widget build(BuildContext c) => Container(
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(color: panel2, border: Border.all(color: line)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '> module_$no',
          style: const TextStyle(color: green, fontSize: 11),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 7),
        Text(
          text,
          style: const TextStyle(color: muted, height: 1.5, fontSize: 13),
        ),
      ],
    ),
  );
}

class FeaturedGif extends StatelessWidget {
  const FeaturedGif({super.key});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: ink,
      border: Border.all(color: green.withValues(alpha: .65)),
      borderRadius: BorderRadius.circular(6),
      boxShadow: [
        BoxShadow(color: green.withValues(alpha: .08), blurRadius: 24),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            color: panel2,
            border: Border(bottom: BorderSide(color: line)),
          ),
          child: const Row(
            children: [
              Icon(Icons.auto_awesome, color: amber, size: 15),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'fitgif_render.output // FEATURED BUILD',
                  style: TextStyle(color: green, fontSize: 11),
                ),
              ),
              Text('LIVE', style: TextStyle(color: amber, fontSize: 10)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18),
          child: LayoutBuilder(
            builder:
                (_, c) =>
                    c.maxWidth > 620
                        ? const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: FeaturedGifImage()),
                            SizedBox(width: 24),
                            Expanded(child: FeaturedGifCopy()),
                          ],
                        )
                        : const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FeaturedGifImage(),
                            SizedBox(height: 18),
                            FeaturedGifCopy(),
                          ],
                        ),
          ),
        ),
      ],
    ),
  );
}

class FeaturedGifImage extends StatelessWidget {
  const FeaturedGifImage({super.key});
  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(maxHeight: 390),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.black,
      border: Border.all(color: line),
      borderRadius: BorderRadius.circular(3),
    ),
    child: Center(
      child: Image.asset('assets/fitgif_produced.gif', fit: BoxFit.contain),
    ),
  );
}

class FeaturedGifCopy extends StatelessWidget {
  const FeaturedGifCopy({super.key});
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'THE OUTPUT IS THE PRODUCT',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 12),
      Body(
        'FitGIF turns a completed workout into a shareable animated memory—giving progress a visual identity beyond numbers and charts.',
      ),
      SizedBox(height: 16),
      LogLine('format', 'animated GIF'),
      LogLine('source', 'completed workout'),
      LogLine('result', 'ready to save and share', color: green),
    ],
  );
}

class DemoCard extends StatelessWidget {
  const DemoCard({
    required this.number,
    required this.title,
    required this.description,
    required this.url,
    super.key,
  });
  final String number;
  final String title;
  final String description;
  final String url;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => launchURL(url),
    borderRadius: BorderRadius.circular(4),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: panel2,
        border: Border.all(color: line),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: green.withValues(alpha: .1),
              border: Border.all(color: green.withValues(alpha: .4)),
            ),
            child: const Icon(Icons.play_arrow_rounded, color: green, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$number // $title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const Icon(Icons.open_in_new, color: amber, size: 15),
        ],
      ),
    ),
  );
}

class ProjectRow extends StatelessWidget {
  const ProjectRow(this.no, this.title, this.tech, this.url, {super.key});
  final String no, title, tech, url;
  @override
  Widget build(BuildContext c) => InkWell(
    onTap: () => launchURL(url),
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: panel2, border: Border.all(color: line)),
      child: Row(
        children: [
          Text('drwx $no', style: const TextStyle(color: muted, fontSize: 11)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(tech, style: const TextStyle(color: muted, fontSize: 12)),
              ],
            ),
          ),
          const Text('OPEN ↗', style: TextStyle(color: green, fontSize: 11)),
        ],
      ),
    ),
  );
}

class UiFile extends StatelessWidget {
  const UiFile(this.name, this.asset, {super.key});
  final String name, asset;
  @override
  Widget build(BuildContext c) => InkWell(
    onTap:
        () => showDialog<void>(
          context: c,
          builder:
              (_) => Dialog(
                backgroundColor: panel,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430,
                    maxHeight: 720,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          'preview > $name',
                          style: const TextStyle(color: green),
                        ),
                      ),
                      const Divider(color: line),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(asset, fit: BoxFit.contain),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: panel2, border: Border.all(color: line)),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file_outlined, color: green, size: 17),
          const SizedBox(width: 9),
          Expanded(child: Text(name, style: const TextStyle(fontSize: 12))),
          const Text('open ↗', style: TextStyle(color: muted, fontSize: 10)),
        ],
      ),
    ),
  );
}

class StatusBar extends StatelessWidget {
  const StatusBar(this.section, {super.key});
  final Section section;
  @override
  Widget build(BuildContext c) => Container(
    height: 28,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    color: green,
    child: Row(
      children: [
        const Text(
          '● NORMAL',
          style: TextStyle(
            color: ink,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 18),
        Text(
          '~/${section.name}',
          style: const TextStyle(color: ink, fontSize: 10),
        ),
        const Spacer(),
        const Text(
          'DART • FLUTTER WEB',
          style: TextStyle(
            color: ink,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Future<void> launchURL(String value) async {
  final uri = Uri.parse(value);
  if (!await launchUrl(uri)) debugPrint('Could not launch $value');
}
