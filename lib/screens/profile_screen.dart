import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../service/api_service.dart';
import '../service/session_service.dart';
import '../models/product_model.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String userIdentifier;
  final String username;
  const ProfileScreen({super.key, required this.userIdentifier, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Product> _myProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMyProducts();
  }

  Future<void> _loadMyProducts() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiService.getProducts();
      if (res['status'] == 'success' && res['data'] != null) {
        final list = (res['data'] as List)
            .map((e) => Product.fromJson(e))
            .where((p) => p.userIdentifier == widget.userIdentifier)
            .toList();
        if (mounted) setState(() => _myProducts = list);
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Logout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            SizedBox(height: 12),
            Text('Apakah Anda yakin ingin logout?', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.textMedium, height: 1.5)),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal', style: TextStyle(color: AppColors.textMedium, fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await SessionService.clear();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red, foregroundColor: Colors.white, elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProduct(Product p) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text('Hapus "${p.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(ctx, true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final res = await ApiService.deleteProduct(p.id, widget.userIdentifier);
      if (res['status'] == 'success') {
        _loadMyProducts();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        title: const Text('Akun', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 36,
              backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
              child: Text(
                widget.username[0].toUpperCase(),
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
              ),
            ),
            const SizedBox(height: 12),
            Text(widget.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 8),
            Text(widget.userIdentifier, style: const TextStyle(fontSize: 13, color: AppColors.textMedium)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddProductScreen(userIdentifier: widget.userIdentifier)),
                  );
                  if (result == true) _loadMyProducts();
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Tambah Produk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Produk Saya (${_myProducts.length})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_myProducts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text('Belum ada produk', style: TextStyle(color: AppColors.textMedium))),
              )
            else
              ..._myProducts.map((p) => _productItem(p)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: AppColors.red),
                label: const Text('Logout', style: TextStyle(color: AppColors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productItem(Product p) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 56,
            height: 56,
            child: p.imagePath.startsWith('http')
                ? Image.network(p.imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image))
                : Image.asset(p.imagePath, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image)),
          ),
        ),
        title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)),
        subtitle: Text('Rp${p.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, color: AppColors.primaryGreen, fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20, color: AppColors.textMedium),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProductScreen(product: p, userIdentifier: widget.userIdentifier)),
                );
                if (result == true) _loadMyProducts();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.red),
              onPressed: () => _deleteProduct(p),
            ),
          ],
        ),
      ),
    );
  }
}
