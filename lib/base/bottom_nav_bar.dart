import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/material.dart';
import '/base/screens/home/home_screen.dart';
import '/base/screens/log/progress_log_screen.dart';
import '/base/screens/profile/profile_screen.dart';
import '/base/screens/search/search_screen.dart';
import '/controllers/bottom_nav_controller.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});
  
  //dependency injection part
  final BottomNavController controller = Get.put(BottomNavController());

  // list is iterated using list index
  final appScreens = [
    const HomeScreen(),
    const SearchScreen(),
    const LogsScreen(),
    const ProfileScreen()
  ];
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
        return Scaffold(
        backgroundColor: theme.canvasColor,
        body: appScreens[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(

          currentIndex: controller.selectedIndex.value,

          onTap: controller.onItemTapped,

          selectedItemColor: theme.primaryColorLight,

          unselectedItemColor: theme.primaryColorLight,

          showSelectedLabels: false,

          iconSize: 26,

          items: const [

            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_home_filled),
                label: 'Home'),

            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_search_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_search_filled),
                label: 'Search'),

            BottomNavigationBarItem(
                icon: Icon(Icons.collections_bookmark_outlined),
                activeIcon: Icon(Icons.collections_bookmark_rounded),
                label: 'Tickets'),

            BottomNavigationBarItem(
                icon: Icon(FluentSystemIcons.ic_fluent_person_regular),
                activeIcon: Icon(FluentSystemIcons.ic_fluent_person_filled),
                label: 'Profile'),
          ],
        ));
    });
  }
}
