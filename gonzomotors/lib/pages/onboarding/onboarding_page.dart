import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/route/route_names.dart';
import '../../gen/colors.gen.dart';
import 'package:go_router/go_router.dart';

class OnBoard {
  final String image, title, description;
  OnBoard({required this.image, required this.title, required this.description});
}

final List<OnBoard> demoData = [
  OnBoard(
    image: "assets/icons/onboarding1.png",
    title: "Great deals await you",
    description: "Unlock exclusive offers and find the best deals on your dream car",
  ),
  OnBoard(
    image: "assets/icons/onboarding2.png",
    title: "Fast & Secure",
    description: "Browse, compare and buy with confidence in a few taps",
  ),
];

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late final PageController _pageController;
  int _pageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // авто-скролл
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || demoData.isEmpty) return;
      final next = (_pageIndex + 1) % demoData.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: demoData.length,
              onPageChanged: (i) => setState(() => _pageIndex = i),
              itemBuilder: (_, i) => Image.asset(
                demoData[i].image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.10),
                    Colors.black.withOpacity(0.20),
                    Colors.black.withOpacity(0.45),
                    Colors.black.withOpacity(0.65),
                  ],
                  stops: const [0.0, 0.35, 0.70, 1.0],
                ),
              ),
            ),
          ),


          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    demoData[_pageIndex].title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    demoData[_pageIndex].description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      demoData.length,
                          (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: _DotIndicator(
                          isActive: i == _pageIndex,
                          activeColor: ColorName.accentInfo,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "By proceeding you agree to our Privacy Policy",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Кнопка
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        context.goNamed(RouteNames.verification);
                      },
                      child: const Text(
                        "Login / Registration",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  const _DotIndicator({
    required this.isActive,
    required this.activeColor,
  });

  final bool isActive;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.white,
        border: isActive ? null : Border.all(color: activeColor),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
