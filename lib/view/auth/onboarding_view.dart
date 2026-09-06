import 'package:flutter/material.dart';
import 'package:study_side/view/auth/welcome_view.dart';
import 'package:study_side/theme/app_theme.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {

  final PageController pageController = PageController();

  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/WhatsApp Image 2026-08-28 at 6.07.45 PM (2).jpeg',
      'title': 'Find Your Room Study',
      'description': 'Join students who are studying the same subject as you.',
    },
    {
      'image': 'assets/images/WhatsApp Image 2026-08-28 at 6.07.45 PM.jpeg',
      'title': 'Focus together',
      'description': 'Study side by side without distractions or video calls.',
    },
    {
      'image': 'assets/images/WhatsApp Image 2026-08-28 at 6.07.45 PM (1).jpeg',
      'title': 'Build your streak',
      'description': 'Track your study time and reach your goals every week.',
    },
  ];

  void nextPage() {

    if (currentPage < pages.length - 1) {

      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

    } else {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeView(),
                      ),
                    );
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: pageController,

                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },

                itemCount: pages.length,

                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Image.asset(
                          pages[index]['image']!,
                          height: 240,
                        ),

                        const SizedBox(height: 36),

                        Text(
                          pages[index]['title']!,
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          pages[index]['description']!,
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textGrey,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                    (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),

                    width: currentPage == index ? 24 : 8,
                    height: 8,

                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? AppColors.primary
                          : AppColors.border,

                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: nextPage,
                  child: Text(
                    currentPage == pages.length - 1 ? 'Get Started' : 'Next',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}