import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../screens/add_product_screen.dart';
import '../../screens/profile_screen.dart';

class DesktopNavbar extends StatelessWidget {
  final String username;
  final String userIdentifier;
  final VoidCallback? onProductAdded;
  const DesktopNavbar({super.key, required this.username, required this.userIdentifier, this.onProductAdded});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Apakah Anda yakin ingin logout?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMedium,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: AppColors.textMedium,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              // Logo
              Text(
                'tokomedia',
                style: AppTextStyles.logoText.copyWith(fontSize: 22),
              ),
              const SizedBox(width: 20),
              // Kategori
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Text(
                      'Kategori',
                      style: TextStyle(
                        color: AppColors.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Search bar
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 12),
                      Icon(Icons.search, color: AppColors.textLight, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Cari di Tokomedia',
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Cart icon
              const Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 24, color: AppColors.textDark),
                ],
              ),
              const SizedBox(width: 16),
              // Notification
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_outlined,
                      size: 24, color: AppColors.textDark),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('1',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Icon(Icons.mail_outline,
                  size: 24, color: AppColors.textDark),
              const SizedBox(width: 20),
              // Toko
              Row(
                children: [
                  Image.asset(
                    'assets/images/toko_icon.png',
                    width: 28,
                    height: 28,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.storefront_outlined,
                      size: 18,
                      color: AppColors.textMedium,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Toko',
                      style:
                          TextStyle(fontSize: 13, color: AppColors.textDark)),
                ],
              ),
              const SizedBox(width: 16),
              // User avatar dengan dropdown logout
              PopupMenuButton(
                offset: const Offset(0, 40),
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/profile_yoel.png',
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 16,
                            color: AppColors.textMedium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(username,
                        style:
                            const TextStyle(fontSize: 13, color: AppColors.textDark)),
                  ],
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: const Text('Tambah Product',
                        style: TextStyle(color: AppColors.textDark)),
                    onTap: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddProductScreen(userIdentifier: userIdentifier),
                        ),
                      );
                      if (result == true) onProductAdded?.call();
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Produk Saya',
                        style: TextStyle(color: AppColors.textDark)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                            userIdentifier: userIdentifier,
                            username: username,
                          ),
                        ),
                      );
                    },
                  ),
                  PopupMenuItem(
                    child: const Text('Logout',
                        style: TextStyle(color: AppColors.red)),
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Address row
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.location_on_outlined,
                  size: 14, color: AppColors.textMedium),
              SizedBox(width: 4),
              Text(
                'Pilih Alamat Pengirimanmu',
                style: TextStyle(fontSize: 12, color: AppColors.textMedium),
              ),
              Icon(Icons.keyboard_arrow_down,
                  size: 16, color: AppColors.textMedium),
            ],
          ),
        ],
      ),
    );
  }
}
