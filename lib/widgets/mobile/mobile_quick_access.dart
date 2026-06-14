import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class MobileQuickAccess extends StatelessWidget {
  const MobileQuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickButtons = [
      {
        'label': 'Bonus',
        'color': const Color(0xFFFFF3E0),
        'iconColor': const Color(0xFFFF8C00),
        'icon': Icons.card_giftcard
      },
      {
        'label': 'Aktifkan',
        'color': const Color(0xFFE3F2FD),
        'iconColor': const Color(0xFF1976D2),
        'icon': Icons.flash_on
      },
      {
        'label': 'Cek Kupon',
        'color': const Color(0xFFFFEBEE),
        'iconColor': AppColors.red,
        'icon': Icons.local_offer
      },
      {
        'label': 'Ja...',
        'color': const Color(0xFFE8F5E9),
        'iconColor': AppColors.primaryGreen,
        'icon': Icons.location_on
      },
    ];

    final List<Map<String, dynamic>> categoryIcons = [
      {
        'label': 'Mulai\nLangganan',
        'icon': Icons.add_circle_outline,
        'color': const Color(0xFF42B549)
      },
      {
        'label': 'Top-Up &\nTagihan',
        'icon': Icons.smartphone,
        'color': const Color(0xFF1E88E5)
      },
      {
        'label': 'Mall',
        'icon': Icons.check_circle,
        'color': const Color(0xFF7B2D8B)
      },
      {
        'label': 'Beli\nLokal',
        'icon': Icons.shopping_bag,
        'color': AppColors.red
      },
      {
        'label': 'Fashion',
        'icon': Icons.checkroom,
        'color': const Color(0xFFE91E63)
      },
      {
        'label': 'Beauty',
        'icon': Icons.face_retouching_natural,
        'color': AppColors.pink
      },
    ];

    return Column(
      children: [
        // Quick buttons row
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: quickButtons.map((btn) {
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    decoration: BoxDecoration(
                      color: btn['color'] as Color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/quick_${quickButtons.indexOf(btn)}.png',
                          width: 20,
                          height: 20,
                          errorBuilder: (_, __, ___) => Icon(
                            btn['icon'] as IconData,
                            size: 18,
                            color: btn['iconColor'] as Color,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            btn['label'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Category icons row — semua item sama tinggi
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: categoryIcons.map((cat) {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.background,
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/cat_mobile_${categoryIcons.indexOf(cat)}.png',
                          width: 36,
                          height: 36,
                          errorBuilder: (_, __, ___) => Icon(
                            cat['icon'] as IconData,
                            size: 32,
                            color: cat['color'] as Color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      cat['label'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDark,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
