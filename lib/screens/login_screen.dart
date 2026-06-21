import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../service/api_service.dart';
import '../service/session_service.dart';
import '../service/notification_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneEmailController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  Future<void> _handleNext() async {
    final input = _phoneEmailController.text.trim();
    if (input.isEmpty) {
      setState(() => _errorText = 'Nomor HP atau Email tidak boleh kosong');
      return;
    }
    setState(() {
      _errorText = null;
      _isLoading = true;
    });
    try {
      final res = await ApiService.login(input, input);
      if (mounted) {
        if (res['status'] == 'success') {
          await SessionService.save(input);
          if (!kIsWeb) await NotificationService.registerToken(input);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home', arguments: input);
          }
        } else {
          setState(() => _errorText = 'User tidak ditemukan');
        }
      }
    } catch (e) {
      if (mounted) setState(() => _errorText = 'Koneksi gagal');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login dengan Google (simulasi)')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _handleTikTok() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login dengan TikTok (simulasi)')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _handleScanQR() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Scan Kode QR (simulasi)')),
    );
  }

  @override
  void dispose() {
    _phoneEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header logo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'tokomedia',
                style: AppTextStyles.logoText.copyWith(fontSize: 28),
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Body
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final areaW = constraints.maxWidth;
                final areaH = constraints.maxHeight;

                // Ukuran gambar
                const imgW = 280.0;
                const imgH = 420.0;

                // Posisi tengah vertikal
                final imgTop = (areaH - imgH) / 2;

                // Titik tengah horizontal layar
                final centerX = areaW / 2;

                // Lebar form
                const formW = 320.0;

                // Gap sangat kecil (hampir menyatu)
                const gap = -20.0;

                // Gambar kiri: ujung kanannya very close ke form
                final leftImgLeft = centerX - formW / 2 - gap - imgW;

                // Gambar kanan: ujung kirinya very close ke form
                final rightImgLeft = centerX + formW / 2 + gap;

                return Stack(
                  children: [
                    // Gambar kiri (login_1.png)
                    Positioned(
                      left: leftImgLeft,
                      top: imgTop,
                      width: imgW,
                      height: imgH,
                      child: Image.asset(
                        'assets/images/login_1.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.centerRight,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),

                    // Gambar kanan (login_2.png)
                    Positioned(
                      left: rightImgLeft,
                      top: imgTop,
                      width: imgW,
                      height: imgH,
                      child: Image.asset(
                        'assets/images/login_2.png',
                        fit: BoxFit.contain,
                        alignment: Alignment.centerLeft,
                        errorBuilder: (_, __, ___) => const SizedBox(),
                      ),
                    ),

                    // Form login — tepat di tengah
                    Center(child: _buildLoginForm()),
                  ],
                );
              },
            ),
          ),

          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Masuk ke Tokomedia',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  'Daftar',
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Input nomor HP / email
          TextField(
            controller: _phoneEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Nomor HP atau Email',
              hintStyle:
                  const TextStyle(color: AppColors.textLight, fontSize: 14),
              errorText: _errorText,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: AppColors.primaryGreen, width: 1.5),
              ),
            ),
            onSubmitted: (_) => _handleNext(),
          ),
          const SizedBox(height: 6),
          const Text(
            'Contoh: 08123456789',
            style: TextStyle(fontSize: 11, color: AppColors.textLight),
          ),
          const SizedBox(height: 8),

          // Butuh bantuan
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                'Butuh bantuan?',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Tombol Selanjutnya
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDDE3F0),
                foregroundColor: AppColors.textMedium,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Selanjutnya',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 18),

          // Divider atau masuk dengan
          Row(
            children: const [
              Expanded(child: Divider(color: AppColors.border)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text('atau masuk dengan',
                    style: TextStyle(fontSize: 11, color: AppColors.textLight)),
              ),
              Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          const SizedBox(height: 14),

          // Scan Kode QR
          _buildSocialButton(
            onTap: _handleScanQR,
            icon: Icons.qr_code_scanner,
            label: 'Scan Kode QR',
          ),
          const SizedBox(height: 10),

          // Google
          _buildSocialButton(
            onTap: _handleGoogle,
            imagePath: 'assets/icons/google_icon.png',
            label: 'Google',
            fallbackIcon: Icons.g_mobiledata,
            fallbackColor: Colors.red,
          ),
          const SizedBox(height: 10),

          // TikTok
          _buildSocialButton(
            onTap: _handleTikTok,
            imagePath: 'assets/icons/tiktok_icon.png',
            label: 'Masuk dengan TikTok',
            fallbackIcon: Icons.music_note,
            fallbackColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    String? imagePath,
    IconData? icon,
    IconData? fallbackIcon,
    Color? fallbackColor,
    required String label,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, size: 20, color: AppColors.textDark)
            else if (imagePath != null)
              Image.asset(
                imagePath,
                width: 20,
                height: 20,
                errorBuilder: (_, __, ___) =>
                    Icon(fallbackIcon, size: 20, color: fallbackColor),
              ),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('© 2009-2026, PT Tokomedia',
              style: TextStyle(fontSize: 12, color: AppColors.textLight)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('|', style: TextStyle(color: AppColors.border)),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero, minimumSize: Size.zero),
            child: const Text('Bantuan',
                style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
