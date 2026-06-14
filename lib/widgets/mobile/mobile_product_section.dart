import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/product_model.dart';
import '../../service/api_service.dart';
import '../shared/product_card.dart';

class MobileProductSection extends StatefulWidget {
  final String username;
  const MobileProductSection({super.key, required this.username});

  @override
  State<MobileProductSection> createState() => _MobileProductSectionState();
}

class _MobileProductSectionState extends State<MobileProductSection> {
  int _selectedTab = 0;
  final ScrollController _tabScrollController = ScrollController();
  late final List<String> _tabs = ['For ${widget.username}', 'Mall', 'Elektronik', 'Handphone'];
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
  void dispose() {
    _tabScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColors.white,
          child: SingleChildScrollView(
            controller: _tabScrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                final isSelected = _selectedTab == entry.key;
                final isMallTab = entry.value == 'Mall';
                return GestureDetector(
                  onTap: () => setState(() => _selectedTab = entry.key),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: isMallTab
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF7B2D8B),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(3), bottomLeft: Radius.circular(3)),
                                ),
                                child: const Icon(Icons.check, size: 10, color: Colors.white),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(3), bottomRight: Radius.circular(3)),
                                ),
                                child: const Text('Mall', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, height: 1.0)),
                              ),
                            ],
                          )
                        : Text(entry.value, style: TextStyle(
                            color: isSelected ? AppColors.primaryGreen : AppColors.textDark,
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          )),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        if (_isLoading)
          const Padding(padding: EdgeInsets.all(32), child: Center(child: CircularProgressIndicator()))
        else if (_products.isEmpty)
          const Padding(
            padding: EdgeInsets.all(48),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.textLight),
                  SizedBox(height: 8),
                  Text('Belum ada produk', style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
                ],
              ),
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) => ProductCard(product: _products[index], isMobile: true),
          ),
      ],
    );
  }
}
