import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../screens/profile_screen.dart';
import '../../screens/add_product_screen.dart';

class MobileBottomNav extends StatefulWidget {
  final String username;
  final String userIdentifier;
  final int initialIndex;
  const MobileBottomNav({super.key, required this.username, required this.userIdentifier, this.initialIndex = 0});

  @override
  State<MobileBottomNav> createState() => _MobileBottomNavState();
}

class _MobileBottomNavState extends State<MobileBottomNav> {
  late int _selectedIndex;

  final List<Map<String, dynamic>> _items = [
    {'label': 'Home', 'icon': 'assets/icons/nav_home.png'},
    {'label': 'Feed', 'icon': 'assets/icons/nav_feed.png'},
    {'label': 'Mall', 'icon': 'assets/icons/nav_mall.png'},
    {'label': 'Transaksi', 'icon': 'assets/icons/nav_transaksi.png'},
    {'label': 'Akun', 'icon': 'assets/icons/nav_akun.png'},
  ];

  final List<IconData> _fallbackIcons = [
    Icons.thumb_up_alt_outlined,
    Icons.smart_display_outlined,
    Icons.check_box_outlined,
    Icons.list_alt_outlined,
    Icons.person_outline,
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            userIdentifier: widget.userIdentifier,
            username: widget.username,
          ),
        ),
      );
    } else {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            children: _items.asMap().entries.map<Widget>((entry) {
              final isSelected = _selectedIndex == entry.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onItemTapped(entry.key),
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          entry.value['icon'] as String,
                          width: 24,
                          height: 24,
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.textMedium,
                          errorBuilder: (_, __, ___) => Icon(
                            _fallbackIcons[entry.key],
                            size: 24,
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.textMedium,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry.value['label'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? AppColors.primaryGreen
                                : AppColors.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
