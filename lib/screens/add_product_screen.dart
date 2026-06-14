import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_constants.dart';
import '../main.dart';
import '../service/api_service.dart';

class AddProductScreen extends StatefulWidget {
  final String userIdentifier;
  const AddProductScreen({super.key, required this.userIdentifier});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _priceCtl = TextEditingController();
  final _origPriceCtl = TextEditingController();
  final _discountCtl = TextEditingController();
  final _locationCtl = TextEditingController();
  final _storeCtl = TextEditingController();
  final _soldCountCtl = TextEditingController();
  final _bonusCtl = TextEditingController();
  final _bonusWebCtl = TextEditingController();
  final _ratingCtl = TextEditingController();

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
      if (picked != null) {
        setState(() => _imageXFile = picked);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memilih gambar: $e')),
        );
      }
    }
  }

  void _autoCalcDiscount() {
    final price = double.tryParse(_priceCtl.text.replaceAll('.', '')) ?? 0;
    final orig = double.tryParse(_origPriceCtl.text.replaceAll('.', '')) ?? 0;
    if (price > 0 && orig > 0 && orig > price) {
      final disc = ((orig - price) / orig * 100).round();
      _discountCtl.text = disc.toString();
      if (disc > 0) setState(() => _isPinkPrice = true);
    }
  }

  String _formatRupiah(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '';
    final parsed = int.parse(digits);
    final formatted = parsed.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
    return formatted;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final priceStr = _priceCtl.text.replaceAll('.', '');
    final origStr = _origPriceCtl.text.replaceAll('.', '');

    final fields = <String, String>{
      'user_identifier': widget.userIdentifier,
      'name': _nameCtl.text.trim(),
      'price': priceStr,
      'original_price': origStr.isNotEmpty ? origStr : '',
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
      final res = await ApiService.addProduct(fields, _imageXFile);
      if (mounted) {
        if (res['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil ditambahkan')),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? 'Gagal menambahkan produk')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal terhubung ke server')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 768;
          return Column(
            children: [
              if (!isMobile)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text('tokomedia',
                        style: AppTextStyles.logoText.copyWith(fontSize: 28)),
                  ),
                ),
              if (!isMobile) const Divider(height: 1, color: Color(0xFFEEEEEE)),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 640),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(isMobile ? 16 : 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Icon(Icons.arrow_back, color: AppColors.textDark),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Tambah Produk',
                                style: TextStyle(
                                  fontSize: isMobile ? 18 : 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Image picker
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: _imageXFile != null
                                        ? ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: kIsWeb
                                                ? Image.network(_imageXFile!.path, fit: BoxFit.cover, width: double.infinity, height: 200)
                                                : Image.file(File(_imageXFile!.path), fit: BoxFit.cover, width: double.infinity, height: 200),
                                          )
                                        : const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.textLight),
                                              SizedBox(height: 8),
                                              Text('Tap untuk upload gambar produk', style: TextStyle(color: AppColors.textMedium)),
                                            ],
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _field('Nama Produk', _nameCtl, validator: (v) => v?.isEmpty ?? true ? 'Wajib diisi' : null),
                                const SizedBox(height: 16),
                                _field('Harga Jual (Rp)', _priceCtl, keyboardType: TextInputType.number, onChanged: (_) => _autoCalcDiscount()),
                                const SizedBox(height: 16),
                                _field('Harga Sebelum Diskon (Rp) - opsional', _origPriceCtl, keyboardType: TextInputType.number, onChanged: (_) => _autoCalcDiscount()),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(child: _field('Diskon %', _discountCtl, keyboardType: TextInputType.number)),
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
                                    Expanded(child: _radioDropdown('Rating', _autoRating, (v) => setState(() => _autoRating = v), _ratingCtl,
                                        hint: '5.0')),
                                    const SizedBox(width: 12),
                                    Expanded(child: _radioDropdown('Sold Count', _autoSold, (v) => setState(() => _autoSold = v), _soldCountCtl,
                                        hint: '0')),
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
                                        : const Text('Simpan Produk', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {TextInputType? keyboardType, bool readOnly = false, String? Function(String?)? validator, void Function(String)? onChanged}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onChanged: onChanged,
      validator: validator,
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
          Switch(value: value, onChanged: onChanged, activeColor: AppColors.primaryGreen),
        ],
      ),
    );
  }

  Widget _radioDropdown(String label, bool isAuto, ValueChanged<bool> onChanged, TextEditingController ctrl, {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMedium)),
            const Spacer(),
            GestureDetector(
              onTap: () => onChanged(true),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isAuto ? Icons.radio_button_checked : Icons.radio_button_off, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 4),
                  const Text('Auto', style: TextStyle(fontSize: 12, color: AppColors.textMedium)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onChanged(false),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(!isAuto ? Icons.radio_button_checked : Icons.radio_button_off, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 4),
                  const Text('Manual', style: TextStyle(fontSize: 12, color: AppColors.textMedium)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        TextField(
          controller: ctrl,
          enabled: !isAuto,
          readOnly: isAuto,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hint ?? '',
            hintStyle: const TextStyle(color: AppColors.textLight),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5)),
          ),
        ),
      ],
    );
  }
}
