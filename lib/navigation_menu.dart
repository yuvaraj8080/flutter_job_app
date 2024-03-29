import 'package:flutter/material.dart';
import 'package:flutter_job_app/features/components/screens/jobs_screen.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'features/components/screens/search_companies.dart';
import 'features/personalization/screens/setting/setting.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(bottomNavigationBar: Obx(
          () => NavigationBar(
              height: 60,
              elevation: 0,
              selectedIndex: controller.selectedIndex.value,
              onDestinationSelected: (index) =>
                  controller.selectedIndex.value = index,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                NavigationDestination(icon: Icon(Icons.search_sharp), label: "Search"),
                // NavigationDestination(icon: Icon(Iconsax.heart), label: "Wishlist"),
                NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
              ]),
        ),
        body: Obx(() => controller.screens[controller.selectedIndex.value]));
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const JobScreen(),
    const SearchCompany(),
    // const FovouriteScreen(),
    const SettingScreen()
  ];
}
