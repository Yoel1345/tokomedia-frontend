import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class MobileNavbar extends StatefulWidget implements PreferredSizeWidget {
  final String username;
  const MobileNavbar({super.key, required this.username});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  State<MobileNavbar> createState() => _MobileNavbarState();
}

class _MobileNavbarState extends State<MobileNavbar> {
  final TextEditingController _searchController = TextEditingController();

  void _handleSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mencari: $query'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      titleSpacing: 12,
      title: Row(
        children: [
          // Search bar dengan teks Cari di kanan
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _handleSearch,
                    child: const Icon(Icons.search,
                        size: 18, color: AppColors.textLight),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'topi',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w500,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _handleSearch(),
                    ),
                  ),
                  // Teks Cari di dalam search bar
                  GestureDetector(
                    onTap: _handleSearch,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Text(
                        'Cari',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Chat icon — placeholder gambar
          Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                'assets/icons/chat_nav_icon.png',
                width: 32,
                height: 32,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.chat_bubble_outline,
                  size: 28,
                  color: AppColors.textDark,
                ),
              ),
              Positioned(
                top: -3,
                right: -3,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    color: AppColors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // Cart icon
          const Icon(
            Icons.shopping_cart_outlined,
            size: 28,
            color: AppColors.textDark,
          ),
        ],
      ),
    );
  }
}
