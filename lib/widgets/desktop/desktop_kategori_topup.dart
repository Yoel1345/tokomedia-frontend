import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class DesktopKategoriTopup extends StatefulWidget {
  const DesktopKategoriTopup({super.key});

  @override
  State<DesktopKategoriTopup> createState() => _DesktopKategoriTopupState();
}

class _DesktopKategoriTopupState extends State<DesktopKategoriTopup> {
  int _selectedTab = 0;
  final TextEditingController _phoneController = TextEditingController();
  String? _selectedNominal;

  final List<Map<String, dynamic>> _nominalOptions = [
    {
      'label': 'Pulsa',
      'values': [
        '5.000',
        '10.000',
        '15.000',
        '20.000',
        '25.000',
        '50.000',
        '100.000'
      ]
    },
    {
      'label': 'Paket Data',
      'values': ['1GB', '2GB', '3GB', '5GB', '8GB', '12GB', '25GB']
    },
    {
      'label': 'Listrik PLN',
      'values': [
        '20.000',
        '50.000',
        '100.000',
        '200.000',
        '500.000',
        '1.000.000'
      ]
    },
    {
      'label': 'Roaming',
      'values': ['1 Hari', '3 Hari', '7 Hari', '14 Hari', '30 Hari']
    },
  ];

  void _handleBeli() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nomor telepon terlebih dahulu')),
      );
      return;
    }
    if (_selectedNominal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih nominal terlebih dahulu')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Top Up ${_topupTabs[_selectedTab]} $_selectedNominal ke ${_phoneController.text} berhasil!'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
    _phoneController.clear();
    setState(() => _selectedNominal = null);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  final List<String> _topupTabs = [
    'Pulsa',
    'Paket Data',
    'Listrik PLN',
    'Roaming'
  ];

  final List<Map<String, dynamic>> _kategoriItems = [
    {'label': 'Kategori', 'icon': Icons.grid_view},
    {'label': 'Handphone & Tablet', 'icon': Icons.smartphone},
    {'label': 'Top-Up & Tagihan', 'icon': Icons.receipt_long},
    {'label': 'Elektronik', 'icon': Icons.headphones},
    {'label': 'Perawatan Hewan', 'icon': Icons.pets},
    {'label': 'Keuangan', 'icon': Icons.account_balance_wallet},
    {'label': 'Komputer & Laptop', 'icon': Icons.laptop},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Kategori Populer
              Expanded(
                flex: 55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kategori Populer',
                        style: AppTextStyles.heading),
                    const SizedBox(height: 12),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Yuk, belanja di Tokomedia',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                  const SizedBox(height: 2),
                                  const Text(
                                      'Barang lengkap dari beragam kategori',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 11)),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('Cek Sekarang',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              'assets/images/mascot.png',
                              height: 130,
                              width: 170,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.storefront,
                                  color: Colors.white54,
                                  size: 48),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Right: Top Up & Tagihan
              Expanded(
                flex: 45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('Top Up & Tagihan', style: AppTextStyles.heading),
                        SizedBox(width: 8),
                        Text('Lihat Semua', style: AppTextStyles.smallGreen),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ..._topupTabs.asMap().entries.map((entry) {
                          final isSelected = _selectedTab == entry.key;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _selectedTab = entry.key;
                                _selectedNominal = null;
                              }),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: isSelected
                                          ? AppColors.primaryGreen
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  entry.value,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.primaryGreen
                                        : AppColors.textMedium,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                        const Icon(Icons.more_vert,
                            size: 18, color: AppColors.textLight),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nomor Telepon',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMedium)),
                              const SizedBox(height: 4),
                              Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _phoneController.text.isNotEmpty
                                        ? AppColors.primaryGreen
                                        : AppColors.border,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (_) => setState(() {}),
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                    hintText: 'Masukan Nomor',
                                    hintStyle: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textLight),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 10),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nominal',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMedium)),
                              const SizedBox(height: 4),
                              // ← tinggi nominal (38)
                              Container(
                                height: 38,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.border),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedNominal,
                                    hint: const Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text('Pilih Nominal',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textLight)),
                                    ),
                                    isExpanded: true,
                                    icon: const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(Icons.keyboard_arrow_down,
                                          size: 16,
                                          color: AppColors.textMedium),
                                    ),
                                    items: (_nominalOptions[_selectedTab]
                                            ['values'] as List<String>)
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: Text(value,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.textDark)),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) => setState(
                                        () => _selectedNominal = value),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Tombol Beli — sejajar bawah
                        SizedBox(
                          height: 38,
                          child: ElevatedButton(
                            onPressed: _phoneController.text.isNotEmpty &&
                                    _selectedNominal != null
                                ? _handleBeli
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _phoneController.text.isNotEmpty &&
                                          _selectedNominal != null
                                      ? AppColors.primaryGreen
                                      : AppColors.border,
                              foregroundColor:
                                  _phoneController.text.isNotEmpty &&
                                          _selectedNominal != null
                                      ? Colors.white
                                      : AppColors.textLight,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              minimumSize: Size.zero,
                            ),
                            child: const Text('Beli',
                                style: TextStyle(fontSize: 13)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Category chips
          Row(
            children: _kategoriItems.map((item) {
              final isLast =
                  _kategoriItems.indexOf(item) == _kategoriItems.length - 1;
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: isLast ? 0 : 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/icons/cat_${_kategoriItems.indexOf(item)}.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (_, __, ___) => Icon(
                          item['icon'] as IconData,
                          size: 18,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          item['label'],
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textDark),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
