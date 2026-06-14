import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_constants.dart';
import '../models/product_model.dart';
import '../service/api_service.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;
  final String userIdentifier;
  const EditProductScreen({super.key, required this.product, required this.userIdentifier});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtl;
  late final TextEditingController _priceCtl;
  late final TextEditingController _origPriceCtl;
  late final TextEditingController _discountCtl;
  late final TextEditingController _locationCtl;
  late final TextEditingController _storeCtl;
  late final TextEditingController _soldCountCtl;
  late final TextEditingController _bonusCtl;
  late final TextEditingController _bonusWebCtl;
  late final TextEditingController _ratingCtl;

  XFile? _imageXFile;
  bool _isLoading = false;
  bool _isMall = false;
  bool _isBisaCOD = false;
  bool _isGratisOngkir = false;
  bool _isPinkPrice = false;
  bool _isLokal = false;
  bool _autoRating = true;
  bool _autoSold = true;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtl = TextEditingController(text: p.name);
    _priceCtl = TextEditingController(text: p.price.toStringAsFixed(0));
    _origPriceCtl = TextEditingController(text: p.originalPrice?.toStringAsFixed(0) ?? '');
    _discountCtl = TextEditingController(text: p.discountPercent?.toString() ?? '');
    _locationCtl = TextEditingController(text: p.location);
    _storeCtl = TextEditingController(text: p.storeName ?? '');
    _soldCountCtl = TextEditingController(text: p.soldCount);
    _bonusCtl = TextEditingController(text: p.bonusText ?? '');
    _bonusWebCtl = TextEditingController(text: p.bonusTextWeb ?? '');
    _ratingCtl = TextEditingController(text: p.rating.toStringAsFixed(1));
    _isMall = p.isMall;
    _isBisaCOD = p.isBisaCOD;
    _isGratisOngkir = p.isGratisOngkir;
    _isPinkPrice = p.isPinkPrice;
    _isLokal = p.isLokal;
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _priceCtl.dispose();
    _origPriceCtl.dispose();
    _discountCtl.dispose();
    _locationCtl.dispose();
    _storeCtl.dispose();
    _soldCountCtl.dispose();
    _bonusCtl.dispose();
    _bonusWebCtl.dispose();
    _ratingCtl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (picked != null) setState(() => _imageXFile = picked);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final fields = <String, String>{
      'user_identifier': widget.userIdentifier,
      'name': _nameCtl.text.trim(),
      'price': _priceCtl.text.replaceAll('.', ''),
      'original_price': _origPriceCtl.text.replaceAll('.', ''),
      'discount_percent': _discountCtl.text.trim(),
      'rating': _autoRating ? '5.0' : _ratingCtl.text.trim(),
      'sold_count': _autoSold ? '0' : _soldCountCtl.text.trim(),
      'location': _locationCtl.text.trim(),
      'store_name': _storeCtl.text.trim(),
      'bonus_text': _bonusCtl.text.trim(),
      'bonus_text_web': _bonusWebCtl.text.trim(),
      'is_mall': _isMall ? '1' : '0',
      'is_bisa_cod': _isBisaCOD ? '1' : '0',
      'is_gratis_ongkir': _isGratisOngkir ? '1' : '0',
      'is_pink_price': _isPinkPrice ? '1' : '0',
      'is_lokal': _isLokal ? '1' : '0',
    };

    try {
      final res = await ApiService.updateProduct(widget.product.id, fields, _imageXFile);
      if (mounted) {
        if (res['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produk berhasil diedit')));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Gagal')));
        }
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal terhubung ke server')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
        title: const Text('Edit Produk', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: _imageXFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: kIsWeb
                                ? Image.network(_imageXFile!.path, fit: BoxFit.cover, width: double.infinity, height: 180)
                                : Image.file(File(_imageXFile!.path), fit: BoxFit.cover, width: double.infinity, height: 180),
                          )
                        : widget.product.imagePath.startsWith('http')
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(widget.product.imagePath, fit: BoxFit.cover, width: double.infinity, height: 180,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 48, color: AppColors.textLight)),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.textLight),
                                  SizedBox(height: 8),
                                  Text('Tap untuk ganti gambar', style: TextStyle(color: AppColors.textMedium)),
                                ],
                              ),
                  ),
                ),
                const SizedBox(height: 20),
                _field('Nama Produk', _nameCtl),
                const SizedBox(height: 16),
                _field('Harga Jual (Rp)', _priceCtl, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _field('Harga Sebelum Diskon', _origPriceCtl, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _field('Diskon %', _discountCtl)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('Bonus Text (Mobile)', _bonusCtl)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('Bonus Text (Web)', _bonusWebCtl)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _field('Lokasi / Kota', _locationCtl)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('Nama Toko', _storeCtl)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _field('Sold Count', _soldCountCtl)),
                    const SizedBox(width: 12),
                    Expanded(child: _field('Rating', _ratingCtl, keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 20),
                _switch('Mall', _isMall, (v) => setState(() => _isMall = v)),
                _switch('Bisa COD', _isBisaCOD, (v) => setState(() => _isBisaCOD = v)),
                _switch('Gratis Ongkir', _isGratisOngkir, (v) => setState(() => _isGratisOngkir = v)),
                _switch('Harga Pink', _isPinkPrice, (v) => setState(() => _isPinkPrice = v)),
                _switch('Lokal', _isLokal, (v) => setState(() => _isLokal = v)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Simpan Perubahan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMedium, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5)),
      ),
    );
  }

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textDark))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }
}
