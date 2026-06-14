import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isMobile;

  const ProductCard({
    super.key,
    required this.product,
    this.isMobile = false,
  });

  String _formatPrice(double price) {
    final formatted = price.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
    return 'Rp$formatted';
  }

  Widget _imageFallback() => Container(
        color: AppColors.background,
        child: const Center(
          child: Icon(Icons.image_outlined,
              size: 40, color: AppColors.textLight),
        ),
      );

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------
    // STYLING DAN KONTEN GAMBAR PRODUK
    // ------------------------------------------------------------
    Widget productImage = Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: isMobile ? null : double.infinity,
          child: product.imagePath.startsWith('http')
              ? Image.network(product.imagePath, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback())
              : Image.asset(product.imagePath, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback()),
        ),

        // DISKON BADGE: Teks diset ke tengah menggunakan Alignment.center
        if (product.discountPercent != null)
          Positioned(
            top: 0,
            left: isMobile ? null : 0,
            right: isMobile ? 0 : null,
            child: Container(
              width: isMobile ? 36 : null,
              height: isMobile ? 20 : null,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.discountRed,
                borderRadius: BorderRadius.only(
                  topLeft: isMobile ? Radius.zero : const Radius.circular(8),
                  topRight: isMobile ? const Radius.circular(8) : Radius.zero,
                  bottomLeft: isMobile ? const Radius.circular(8) : Radius.zero,
                  bottomRight:
                      isMobile ? Radius.zero : const Radius.circular(8),
                ),
              ),
              child: Text(
                '${product.discountPercent}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // GRATIS ONGKIR BADGE
        if (isMobile && product.isGratisOngkir)
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              padding: isMobile
                  ? const EdgeInsets.symmetric(horizontal: 14, vertical: 4)
                  : const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius: BorderRadius.only(topRight: Radius.circular(4)),
              ),
              child: Text(
                'GRATIS\nONGKIR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 8.5 : 9,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ),
          ),
      ],
    );

    // ------------------------------------------------------------
    // STYLING DAN KONTEN DETAIL INFO PRODUK
    // ------------------------------------------------------------
    Widget productInfo = Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nama / Judul Produk
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                // LOGO MALL BARU: Gabungan Kotak Ungu Ceklis + Kotak Hitam Teks Mall
                if (isMobile && product.isMall)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1. Kotak Ungu Ceklis
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Color(0xFF7B2D8B),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(3),
                                bottomLeft: Radius.circular(3),
                              ),
                            ),
                            child: const Icon(Icons.check,
                                size: 9, color: Colors.white),
                          ),
                          // 2. Kotak Hitam "Mall"
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(3),
                                bottomRight: Radius.circular(3),
                              ),
                            ),
                            child: const Text(
                              'Mall',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Teks Judul Produk
                TextSpan(
                  text: product.name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDark,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // HARGA PRODUK
          Row(
            children: [
              if (!isMobile && product.isPinkPrice)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xffFFEBF0),
                    border: Border.all(color: AppColors.pink, width: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/voucher_icon.png',
                        width: 16,
                        height: 16,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.local_offer,
                            size: 10,
                            color: AppColors.pink),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatPrice(product.price),
                        style: const TextStyle(
                          color: AppColors.pink,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Flexible(
                  child: Text(
                    _formatPrice(product.price),
                    overflow: TextOverflow.ellipsis,
                    style: isMobile
                        ? const TextStyle(
                            color: AppColors.pink,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          )
                        : AppTextStyles.price.copyWith(fontSize: 13),
                  ),
                ),
              if (isMobile) ...[
                const SizedBox(width: 3),
                Image.asset(
                  'assets/icons/voucher_icon.png',
                  width: 13,
                  height: 13,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.confirmation_number,
                    color: AppColors.pink,
                    size: 12,
                  ),
                ),
              ],
            ],
          ),

          // Mobile Only: Voucher Pembeli Baru & Teks Bisa COD
          if (isMobile) ...[
            Row(
              children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFEBF0),
                      border: Border.all(color: const Color(0xFFE91E63), width: 0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/voucher_icon.png',
                        width: 9,
                        height: 9,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.confirmation_number,
                            color: AppColors.pink,
                            size: 9),
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        'Pembeli Baru',
                        style: TextStyle(
                            color: AppColors.pink,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                if (product.isBisaCOD)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'Bisa COD',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 8,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
          ],

          // Bonus text
          if (isMobile ? product.bonusText != null : product.bonusTextWeb != null) ...[
            if (isMobile)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.bonusOrange, width: 0.5),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  product.bonusText!,
                  style: const TextStyle(
                      color: AppColors.bonusOrange, fontSize: 9.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              Text(
                product.bonusTextWeb ?? '',
                style: const TextStyle(
                    color: AppColors.bonusOrange, fontSize: 9.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 2),
          ],
          // Rating & sold
          Row(
            children: [
              const Icon(Icons.star, size: 11, color: Colors.amber),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  '${product.rating} · ${product.soldCount} terjual',
                  style: AppTextStyles.small.copyWith(fontSize: 9.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),

          // Location
          if (product.location.isNotEmpty) ...[
            Row(
              children: [
                if (product.isLokal) ...[
                  Image.asset(
                    'assets/icons/location_icon.png',
                    width: 12,
                    height: 12,
                    errorBuilder: (_, __, ___) => const Icon(Icons.location_on,
                        size: 11, color: Color(0xFFFFAA00)),
                  ),
                  const SizedBox(width: 3),
                ],
                Expanded(
                  child: Text(
                    product.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.small.copyWith(fontSize: 9.5, color: AppColors.textMedium),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),
          ],

          // Store name / Mall
          if (product.storeName != null && product.storeName!.isNotEmpty) ...[
            Row(
              children: [
                if (!isMobile && product.isMall) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B2D8B),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Icon(Icons.check, size: 10, color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    product.storeName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.small.copyWith(fontSize: 9.5),
                  ),
                ),
              ],
            ),
          ],

        ],
      ),
    );

    // ------------------------------------------------------------
    // STRUKTUR LAYOUT (WEB VS MOBILE)
    // ------------------------------------------------------------
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: isMobile
          ? SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(aspectRatio: 1, child: productImage),
                  productInfo,
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 52, child: productImage),
                Expanded(flex: 48, child: productInfo),
              ],
            ),
    );
  }
}
