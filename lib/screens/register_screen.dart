import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../service/api_service.dart';
import 'login_screen.dart';
import 'verify_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneEmailController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  Future<void> _handleDaftar() async {
    final input = _phoneEmailController.text.trim();
    if (input.isEmpty) {
      setState(() => _errorText = 'Nomor HP atau E-mail tidak boleh kosong');
      return;
    }
    setState(() {
      _errorText = null;
      _isLoading = true;
    });
    try {
      final res = await ApiService.register(input, input);
      if (mounted) {
        setState(() => _isLoading = false);
        if (res['status'] == 'success') {
          _showConfirmDialog(input, res['code'] as String);
        } else {
          setState(() => _errorText = res['message'] as String? ?? 'Gagal daftar');
        }
      }
    } catch (e) {
      if (mounted) setState(() => _errorText = 'Koneksi gagal');
    }
  }

  void _showConfirmDialog(String phone, String code) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              phone,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Pastikan Nomor HP yang kamu\nisi sudah benar untuk diverifikasi.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13, color: AppColors.textMedium, height: 1.5),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Ubah',
                      style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VerifyScreen(phoneOrEmail: phone, code: code, isEmail: phone.contains('@'))));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Ya, Benar',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Daftar dengan Google (simulasi)')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Kiri — ilustrasi
                      Expanded(
                        flex: 5,
                        child: _buildLeftIllustration(),
                      ),
                      const SizedBox(width: 60),
                      // Kanan — form register
                      Expanded(
                        flex: 4,
                        child: _buildRegisterForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildLeftIllustration() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Placeholder ilustrasi register
        Image.asset(
          'assets/images/register_illustration.png',
          height: 300,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Container(
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F9),
              borderRadius: BorderRadius.circular(200),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined,
                  size: 80, color: Color(0xFFB0D8E8)),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Jual Beli Mudah Hanya di Tokomedia',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Gabung dan rasakan kemudahan bertransaksi di Tokomedia',
          style: TextStyle(fontSize: 13, color: AppColors.textMedium),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: const EdgeInsets.all(36),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          const Text(
            'Daftar Sekarang',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sudah punya akun Tokomedia? ',
                  style: TextStyle(fontSize: 13, color: AppColors.textMedium)),
              GestureDetector(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text('Masuk',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Google button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _handleGoogle,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/google_icon.png',
                    width: 20,
                    height: 20,
                    errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata,
                        size: 22, color: Colors.red),
                  ),
                  const SizedBox(width: 10),
                  const Text('Google',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Divider atau
          Row(
            children: [
              const Expanded(child: Divider(color: AppColors.border)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('atau',
                    style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              ),
              const Expanded(child: Divider(color: AppColors.border)),
            ],
          ),
          const SizedBox(height: 16),
          // Input nomor HP / email
          TextField(
            controller: _phoneEmailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Nomor HP atau E-mail',
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
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Contoh: email@tokomedia.com',
                style: TextStyle(fontSize: 11, color: AppColors.textLight)),
          ),
          const SizedBox(height: 16),
          // Tombol Daftar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleDaftar,
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
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Daftar',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),
          // Syarat ketentuan
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                  fontSize: 11, color: AppColors.textMedium, height: 1.6),
              children: [
                TextSpan(text: 'Dengan mendaftar, saya menyetujui\n'),
                TextSpan(
                    text: 'Syarat & Ketentuan',
                    style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600)),
                TextSpan(text: ' serta '),
                TextSpan(
                    text: 'Kebijakan Privasi Tokomedia.',
                    style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
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
            child: const Text('Tokomedia Care',
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
