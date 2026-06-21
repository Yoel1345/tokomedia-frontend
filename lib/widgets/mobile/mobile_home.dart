import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'mobile_navbar.dart';
import 'mobile_banner.dart';
import 'mobile_quick_access.dart';
import 'mobile_exklusif_section.dart';
import 'mobile_product_section.dart';
import 'mobile_bottom_nav.dart';

class MobileHome extends StatefulWidget {
  final String username;
  final String userIdentifier;
  const MobileHome({super.key, required this.username, required this.userIdentifier});

  @override
  State<MobileHome> createState() => _MobileHomeState();
}

class _MobileHomeState extends State<MobileHome> {
  final GlobalKey<MobileProductSectionState> _productSectionKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MobileNavbar(username: widget.username),
      body: RefreshIndicator(
        onRefresh: () => _productSectionKey.currentState?.refresh() ?? Future.value(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                child: MobileProductSection(username: widget.username, key: _productSectionKey),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MobileBottomNav(username: widget.username, userIdentifier: widget.userIdentifier),
    );
  }
}
