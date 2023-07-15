import 'package:flutter/material.dart';
import 'package:mydiary_app/auth/login_or_register.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});
  static const String route = "OnboardScreen";

  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  PageController? _pageController;
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to MyApp',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'image': 'assets/images/onboard1.png',
    },
    {
      'title': 'Explore Amazing Features',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'image': 'assets/images/onboard2.png',
    },
    {
      'title': 'Get Started',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      'image': 'assets/images/onboard3.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, bottom: 40, left: 20, right: 20),
          child: Column(
            children: [
              buildLogo(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _onboardingData.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return buildOnboardingPage(index);
                  },
                ),
              ),
              buildIndicator(),
              const SizedBox(height: 70),
              buildGetStartedButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOnboardingPage(int index) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            _onboardingData[index]['image']!,
          ),
          const SizedBox(height: 30),
          Text(
            _onboardingData[index]['title']!,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _onboardingData[index]['description']!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLogo() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Image.asset('assets/images/logo.png')]);
  }

  Widget buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingData.length,
        (index) => buildIndicatorDot(index),
      ),
    );
  }

  Widget buildIndicatorDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? const Color.fromARGB(255, 29, 39, 49)
            : Colors.grey,
      ),
    );
  }

  Widget buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, LoginOrRegister.route);
          // Handle "Get Started" button press
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 29, 39, 49),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
