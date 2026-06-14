import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/product_model.dart';
import '../../service/api_service.dart';
import '../shared/product_card.dart';

class DesktopProductSection extends StatefulWidget {
  final String username;
  const DesktopProductSection({super.key, required this.username});

  @override
  State<DesktopProductSection> createState() => _DesktopProductSectionState();
}

class _DesktopProductSectionState extends State<DesktopProductSection> {
  int _selectedTab = 0;
  late final List<String> _tabs = ['For ${widget.username}', 'Mall', 'Produk Incaranmu'];
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final res = await ApiService.getProducts();
      if (res['status'] == 'success' && res['data'] != null) {
        final list = (res['data'] as List).map((e) => Product.fromJson(e)).toList();
        if (mounted) setState(() => _products = list);
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: _tabs.asMap().entries.map((entry) {
              final isSelected = _selectedTab == entry.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedTab = entry.key),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: entry.key == 1
                      ? Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF7B2D8B),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.check, size: 10, color: Colors.white),
                                  SizedBox(width: 2),
                                  Text('Mall', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Text(entry.value, style: TextStyle(
                          color: isSelected ? AppColors.primaryGreen : AppColors.textMedium,
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        )),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (_isLoading)
          const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))
        else if (_products.isEmpty)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textLight),
                  SizedBox(height: 12),
                  Text('Belum ada produk', style: TextStyle(fontSize: 14, color: AppColors.textMedium)),
                  SizedBox(height: 4),
                  Text('Tambahkan produk melalui halaman Akun', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 0.62,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) => ProductCard(product: _products[index]),
          ),
      ],
    );
  }
}
