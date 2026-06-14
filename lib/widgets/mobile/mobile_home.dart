import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'mobile_navbar.dart';
import 'mobile_banner.dart';
import 'mobile_quick_access.dart';
import 'mobile_exklusif_section.dart';
import 'mobile_product_section.dart';
import 'mobile_bottom_nav.dart';

class MobileHome extends StatelessWidget {
  final String username;
  final String userIdentifier;
  const MobileHome({super.key, required this.username, required this.userIdentifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MobileNavbar(username: username),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MobileBanner(),
            const SizedBox(height: 4),
            const MobileQuickAccess(),
            const SizedBox(height: 8),
            const MobileExklusifSection(),
            const SizedBox(height: 8),
            Container(
              color: AppColors.white,
              child: MobileProductSection(username: username),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: MobileBottomNav(username: username, userIdentifier: userIdentifier),
    );
  }
}
