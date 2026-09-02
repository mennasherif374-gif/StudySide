import 'package:flutter/material.dart';
import 'package:study_side/view/welcome_view.dart';

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

            Align(
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
                    color: Colors.grey,
                    fontSize: 16,
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
                    padding: const EdgeInsets.all(30),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Image.asset(
                          pages[index]['image']!,
                          height: 250,
                        ),

                        const SizedBox(height: 40),

                        Text(
                          pages[index]['title']!,
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          pages[index]['description']!,
                          textAlign: TextAlign.center,

                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
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
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),

                    width: currentPage == index ? 25 : 8,
                    height: 8,

                    decoration: BoxDecoration(
                      color: currentPage == index
                          ? Color(0xFF6677CC)
                          : Colors.grey.shade300,

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
                width: 200,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6677CC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: nextPage,

                  child: Text(
                    currentPage == pages.length - 1
                        ? 'Next'
                        : 'Next',
                    style:
                    TextStyle(
                      color: Colors.white
                    )
                    ,
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