import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const DiliPortfolio());
}

class DiliPortfolio extends StatelessWidget {
  const DiliPortfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dilini\'s Portfolio',
      debugShowCheckedModeBanner: false,
      home: const PortfolioHome(),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _sunBrightnessController;
  late final Animation<double> _sunBrightness;
  late Timer _themeTimer;

  bool get isMorning {
    final hour = DateTime.now().hour;
    return hour >= 6 && hour < 18;
  }

  @override
  void initState() {
    super.initState();
    // Animate sun brightness
    _sunBrightnessController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _sunBrightness = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _sunBrightnessController, curve: Curves.easeInOut));
    // Update theme periodically
    _themeTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _sunBrightnessController.dispose();
    _themeTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isMorning ? Colors.lightBlue[100]! : Colors.indigo[900]!;

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Stationary sun or moon with pulsing brightness
          Positioned(
            top: 50,
            left: 20,
            child: isMorning
                ? FadeTransition(opacity: _sunBrightness, child: _buildSun())
                : _buildMoon(),
          ),
          // Trees at bottom corners
          Positioned(
            bottom: 0,
            left: 20,
            child: SimpleTree(controller: _sunBrightnessController),
          ),
          Positioned(
            bottom: 0,
            right: 20,
            child: SimpleTree(controller: _sunBrightnessController),
          ),
          // Content overlay
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Dilini\'s Portfolio',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _sectionTitle('About Me'),
                  _sectionText(
                    "I'm a recent graduate from Dublin City University & ESIGELEC who underwent a double degree program in General engineering(ESIGELEC) and electronic and computer engineering at DCU. I was able to obtain the experience of working with a kernel module that ran on a arm64 system(android phone) to modify a feature in the CPU from my recent internship. Also, from the internship before that, I was able to design a PCB on Altium designer using a low-power microcontroller for a pulse-counter project. Plus, over there, I was tasked with setting up the ThingsBoard Cloud platform with devices to establish user-cases for data monitoring. Moreover, I was tasked with getting a demo app running for a robot called the Sanbot that was controlled by an android SDK(this was needed for an exhibition). Also, during my first ever internship, I had the pleasure of being part of many administrative tasks related to a vending machine company(like handling supplier information, management of checks, data entry, special token counting, answering phone calls, welcoming guests etc. )(BTW this is my first-ever website and it is about me HAHA) Thank you for reading it. Very much appreciated:)",
                  ),
                  const SizedBox(height: 40),
                  _sectionTitle('User Interfaces'),
                  // Description under User Interfaces
                  _sectionText('Here is sneak peak at the Flutter UI designs of the gamified fitness app I am making with friends. Tap a button to view each UI in detail.'),
                  const SizedBox(height: 20),
                  // Buttons to view each UI
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _uiButton(context, label: 'Welcome UI', asset: 'assets/welcome_s.png'),
                      _uiButton(context, label: 'Register UI', asset: 'assets/register_s.png'),
                      _uiButton(context, label: 'Login UI', asset: 'assets/login_s.png'),
                      _uiButton(context, label: 'Home UI', asset: 'assets/home_s.png'),
                      _uiButton(context, label: 'Profile UI', asset: 'assets/profile_s.png'),
                      _uiButton(context, label: 'Recipe UI', asset: 'assets/recipes_s.png'),
                      _uiButton(context, label: 'Fitness Tracker UI', asset: 'assets/fitness_tracker_s.png'),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _sectionTitle('Projects'),
                  _projectItem(
                    title: 'Low-Power MSP430 Dev Board',
                    link:
                        'https://github.com/DiliniMW/Reference-file-for-the-long-technical-internship-/blob/main/Low%20power%20dev%20board/low%20Power%20dev%20Board/Schematic%20Print/Schematic%20Prints.PDF',
                  ),
                  _projectItem(
                    title: 'Gamified fitness app (integrated with Firebase)',
                    link:
                        'https://github.com/DiliniMW/level-up-app',
                  ),
                  const SizedBox(height: 40),
                  _sectionTitle('Contact'),
                  _sectionText('Email me at dona.wijetunge@groupe-esigelec.org if you want to get in touch.'),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSun() {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.yellow,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.orangeAccent, blurRadius: 20, spreadRadius: 5),
        ],
      ),
    );
  }

  Widget _buildMoon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.grey.shade700, blurRadius: 10)],
      ),
    );
  }

  Widget _sectionTitle(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );

  Widget _sectionText(String text) => Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      );

  Widget _showcaseImage(String asset) => Image.asset(asset, width: 300, fit: BoxFit.cover);

  Widget _projectItem({required String title, required String link}) => Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          children: [
            Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(width: 10),
            InkWell(
                 onTap: () {
              // only works on web
              launchURL(link);},
              child: const Text(
                'View Repo',
                style: TextStyle(color: Colors.yellowAccent, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      );
}
void launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}
// Styled UI Button matching CustomButton design
Widget _uiButton(BuildContext context, {required String label, required String asset}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * 0.20,
    child: ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(title: Text(label)),
              backgroundColor: Colors.black,
              body: Center(child: Image.asset(asset)),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 115, 255),
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: const Color.fromARGB(255, 64, 109, 255),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Fredoka',
        ),
      ),
      child: Text(label),
    ),
  );
}

// Simple tree with swaying leaves
class SimpleTree extends StatelessWidget {
  final AnimationController controller;
  const SimpleTree({required this.controller, super.key});

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _SimpleTreePainter(controller),
        size: const Size(100, 200),
      );
}

class _SimpleTreePainter extends CustomPainter {
  final Animation<double> animation;
  _SimpleTreePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final trunkPaint = Paint()..color = Colors.brown;
    final leafPaint = Paint()..color = Colors.green;
    canvas.drawRect(
      Rect.fromLTWH(size.width / 2 - 10, size.height - 80, 20, 80), trunkPaint);
    final sway = (animation.value - 0.5) * 0.1;
    canvas.save();
    canvas.translate(size.width / 2, size.height - 80);
    canvas.rotate(sway);
    canvas.drawCircle(const Offset(0, -40), 50, leafPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter old) => true;
}
