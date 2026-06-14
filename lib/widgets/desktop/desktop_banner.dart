import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class DesktopBanner extends StatefulWidget {
  const DesktopBanner({super.key});

  @override
  State<DesktopBanner> createState() => _DesktopBannerState();
}

class _DesktopBannerState extends State<DesktopBanner> {
  int _currentIndex = 0;
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemCount: 3,
            itemBuilder: (context, index) {
              return _buildBannerSlide(index);
            },
          ),
          // Dot indicators
          Positioned(
            bottom: 12,
            left: 16,
            child: Row(
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.only(right: 4),
                  width: _currentIndex == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color:
                        _currentIndex == index ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          // Lihat Promo button
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.textDark.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Lihat Promo Lainnya',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSlide(int index) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        'assets/images/banner_${index + 1}.png',
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB8E994), Color(0xFFD4EDBD)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('NYAM!',
                      style: TextStyle(
                          color: AppColors.accentGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    index == 0
                        ? 'Berbagi di Hari Qurban'
                        : index == 1
                            ? 'Promo Spesial Hari Ini'
                            : 'Flash Sale Terbatas',
                    style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Diskon s.d. 50%',
                      style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
