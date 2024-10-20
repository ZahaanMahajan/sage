import 'package:flutter/material.dart';
import 'package:sage_app/core/constants/string_manager.dart';
import 'package:sage_app/core/models/user.dart';
import 'package:sage_app/features/home/screens/home_screen.dart';
import 'package:sage_app/features/anonymous_chat/screens/anonymous_chat.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int currentIndex = 0;
  final PageController pageController = PageController();

  void onTap(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var bottomNavScreens = <Widget>[
      const HomeScreen(),
      AnonymousChat(isStudent: UserSession.instance.profession == 'student'),
    ];

    var destinationItems = List.generate(
      2,
      (index) {
        String outlineIcon;
        String filledIcon;
        String label;

        switch (index) {
          case 0:
            outlineIcon = StringManager.homeOutlined;
            filledIcon = StringManager.homeFilled;
            label = "Home";
            break;
          case 1:
            outlineIcon = StringManager.messagedOutlined;
            filledIcon = StringManager.messageFilled;
            label = "Chat";
            break;
          default:
            throw Exception('Invalid index');
        }

        return NavigationDestination(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: Image.asset(
              currentIndex == index ? filledIcon : outlineIcon,
              height: currentIndex == index ? 34 : 26,
              width: currentIndex == index ? 34 : 26,
              color: currentIndex != index ? Colors.black : null,
            ),
          ),
          label: label,
        );
      },
    );

    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemCount: bottomNavScreens.length,
        itemBuilder: (context, index) {
          return bottomNavScreens[index];
        },
      ),
      bottomNavigationBar: NavigationBar(
        height: 50,
        elevation: 0,
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: destinationItems,
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
