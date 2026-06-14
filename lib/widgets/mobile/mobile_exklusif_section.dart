import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class MobileExklusifSection extends StatelessWidget {
  const MobileExklusifSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Bagi 3 kolom secara rata dikurangi total margin/padding antar card
    final cardWidth = (screenWidth - 40) / 3;

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Eksklusif Pengguna Baru!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 224, 224, 224)),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chevron_right,
                    size: 22, color: AppColors.textMedium),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Menggunakan IntrinsicHeight agar semua kartu di dalam Row tingginya dipaksa sama rata
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Voucher Card
                _buildVoucherCard(
                    cardWidth: cardWidth, screenWidth: screenWidth),
                const SizedBox(width: 8),

                // 2. Produk 1 dengan badge Pembeli Baru
                _buildProductCard(
                    width: cardWidth,
                    imagePath: 'assets/images/new_user_product_1.png',
                    price: 'Rp55.000',
                    badge: 'Pembeli Baru',
                    screenWidth: screenWidth),
                const SizedBox(width: 8),

                // 3. Produk 2
                _buildProductCard(
                    width: cardWidth,
                    imagePath: 'assets/images/new_user_product_2.png',
                    price: 'Rp49.332',
                    screenWidth: screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(
      {required double cardWidth, required double screenWidth}) {
    // Skema warna tema pink tua eksklusif
    const Color deepPinkColor = Color(0xFFE91E63);
    const Color lightPinkBgColor = Color(0xFFFFF0F5);
    const Color pinkBorderColor = Color(0xFFFFB3D0);

    // Koordinat pengali notch lengkungan (0.72)
    const double notchRatio = 0.72;

    return SizedBox(
      width: cardWidth,
      // Hapus hardcoded cardHeight agar widget ini fleksibel mengikuti tinggi IntrinsicHeight
      child: Stack(
        children: [
          // Background Painter Kartu Voucher beserta lengkungannya
          Positioned.fill(
            child: CustomPaint(
              painter: _VoucherCardPainter(
                bgColor: lightPinkBgColor,
                borderColor: pinkBorderColor,
                notchRatio: notchRatio,
              ),
            ),
          ),

          // Susunan Konten Voucher (Atas & Bawah)
          Column(
            children: [
              // Bagian Atas: Info Diskon (Mengisi area sebelum garis putus-putus)
              Expanded(
                flex: (notchRatio * 100).toInt(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Diskon 20%',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: deepPinkColor,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.032,
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Rp',
                              style: TextStyle(
                                color: deepPinkColor,
                                fontSize: screenWidth * 0.026,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: '10',
                              style: TextStyle(
                                color: deepPinkColor,
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.075,
                                height: 1.0,
                              ),
                            ),
                            TextSpan(
                              text: 'rb',
                              style: TextStyle(
                                color: deepPinkColor,
                                fontSize: screenWidth * 0.028,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Min. belanja Rp50rb',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textLight,
                          fontSize: screenWidth * 0.020,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Garis Putus-Putus Horizontal (Ditempatkan presisi memotong bagian tengah lingkaran)
              CustomPaint(
                size: Size(cardWidth, 1),
                painter: _DashedHorizontalPainter(color: pinkBorderColor),
              ),

              // Bagian Bawah: Tombol Klaim (Mengisi sisa area setelah garis putus-putus)
              Expanded(
                flex: ((1.0 - notchRatio) * 100).toInt(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deepPinkColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        minimumSize: Size(cardWidth * 0.85, 22),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        'Klaim',
                        style: TextStyle(
                          fontSize: screenWidth * 0.028,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  Widget _buildProductCard({
    required double width,
    required String imagePath,
    required String price,
    String? badge,
    String? discount,
    required double screenWidth,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                child: Image.asset(
                  imagePath,
                  width: width,
                  height: width * 1.1,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: width,
                    height: width * 1.1,
                    decoration: const BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8))),
                    child: const Icon(Icons.image_outlined,
                        color: AppColors.textLight),
                  ),
                ),
              ),
              if (discount != null)
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: const BoxDecoration(
                        color: AppColors.discountRed,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(4))),
                    child: Text(discount,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.028,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(price,
              style: TextStyle(
                  color: AppColors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.034)),
          const SizedBox(height: 4),
          // Bagian badge pembeli baru / placeholder transparan agar tinggi kolom layout tetap seimbang
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
                color: badge != null
                    ? const Color(0xFFFFEBF5)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: badge != null
                        ? const Color(0xFFFFB3D0)
                        : Colors.transparent)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badge != null) ...[
                  Image.asset(
                    'assets/icons/voucher_icon.png',
                    width: 10,
                    height: 10,
                    errorBuilder: (_, __, ___) => const Icon(Icons.local_offer,
                        size: 10, color: AppColors.pink),
                  ),
                  const SizedBox(width: 3),
                ],
                Flexible(
                    child: Text(badge ?? '',
                        style: TextStyle(
                            color: badge != null
                                ? AppColors.pink
                                : Colors.transparent,
                            fontSize: screenWidth * 0.024),
                        overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoucherCardPainter extends CustomPainter {
  final Color bgColor;
  final Color borderColor;
  final double notchRatio;

  _VoucherCardPainter({
    required this.bgColor,
    required this.borderColor,
    required this.notchRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = bgColor;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final radius = 8.0;
    final notchRadius = 6.0;
    final notchY = size.height * notchRatio;

    final path = Path();
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(Offset(size.width, radius),
        radius: Radius.circular(radius));
    path.lineTo(size.width, notchY - notchRadius);

    path.arcToPoint(
      Offset(size.width, notchY + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(size.width, size.height - radius);
    path.arcToPoint(Offset(size.width - radius, size.height),
        radius: Radius.circular(radius));
    path.lineTo(radius, size.height);
    path.arcToPoint(Offset(0, size.height - radius),
        radius: Radius.circular(radius));
    path.lineTo(0, notchY + notchRadius);

    path.arcToPoint(
      Offset(0, notchY - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );
    path.lineTo(0, radius);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
    path.close();

    canvas.drawPath(path, bgPaint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(_VoucherCardPainter oldDelegate) =>
      oldDelegate.bgColor != bgColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.notchRatio != notchRatio;
}

class _DashedHorizontalPainter extends CustomPainter {
  final Color color;

  _DashedHorizontalPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;

    double startX = 6.0;
    final endX = size.width - 6.0;
    const dashWidth = 3.5;
    const dashSpace = 3.0;

    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(_DashedHorizontalPainter oldDelegate) =>
      oldDelegate.color != color;
}
