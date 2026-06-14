import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import 'desktop_navbar.dart';
import 'desktop_banner.dart';
import 'desktop_kategori_topup.dart';
import 'desktop_product_section.dart';

class DesktopHome extends StatefulWidget {
  final String username;
  final String userIdentifier;
  const DesktopHome({super.key, required this.username, required this.userIdentifier});

  @override
  State<DesktopHome> createState() => _DesktopHomeState();
}

class _DesktopHomeState extends State<DesktopHome> {
  int _productKey = 0;

  void _refreshProducts() {
    setState(() => _productKey++);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        icon: Image.asset(
          'assets/images/chat_icon.png',
          width: 20,
          height: 20,
          errorBuilder: (_, __, ___) => const Icon(Icons.chat_bubble_outline,
              color: AppColors.primaryGreen),
        ),
        label: const Text(
          'Chat',
          style: TextStyle(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: DesktopNavbar(
              username: widget.username,
              userIdentifier: widget.userIdentifier,
              onProductAdded: _refreshProducts,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DesktopBanner(),
                        const SizedBox(height: 16),
                        const DesktopKategoriTopup(),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: DesktopProductSection(
                            key: ValueKey(_productKey),
                            username: widget.username,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
