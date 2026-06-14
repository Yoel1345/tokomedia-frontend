import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../service/api_service.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final TextEditingController _phoneEmailController = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  Future<void> _handleLanjut() async {
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
      final res = await ApiService.login(input, input);
      if (mounted) {
        if (res['status'] == 'success') {
          Navigator.pushReplacementNamed(context, '/home', arguments: input);
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

  void _handleEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login dengan E-mail (simulasi)')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _handleTikTok() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login dengan TikTok Shop (simulasi)')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _handleHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bantuan (simulasi)')),
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.textDark,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _handleHelp,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.help_outline,
                color: AppColors.textDark,
                size: 28,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Content scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Masuk ke Tokomedia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Input nomor HP / email
                  TextField(
                    controller: _phoneEmailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Nomor HP atau E-mail',
                      hintStyle: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                      errorText: _errorText,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
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
                        borderSide: const BorderSide(
                          color: AppColors.primaryGreen,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Contoh: 08123456789',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tombol Lanjut
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLanjut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDDE3F0),
                        foregroundColor: AppColors.textMedium,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2.5),
                            )
                          : const Text(
                              'Lanjut',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider atau masuk dengan
                  Row(
                    children: const [
                      Expanded(child: Divider(color: AppColors.border)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'atau masuk dengan',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: AppColors.border)),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Google button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _handleGoogle,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/google_icon.png',
                            width: 26,
                            height: 26,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.g_mobiledata,
                              size: 26,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Google',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // E-mail button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _handleEmail,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/email_icon.png',
                            width: 26,
                            height: 26,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.mail_outline,
                              size: 26,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'E-mail',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // TikTok Shop button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _handleTikTok,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.border),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/tiktok_shop_icon.png',
                            width: 26,
                            height: 26,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.shopping_bag_outlined,
                              size: 26,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'TikTok Shop',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // T&C text - CENTERED
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textMedium,
                          height: 1.6,
                        ),
                        children: [
                          TextSpan(text: 'Dengan masuk, saya menyetujui\n'),
                          TextSpan(
                            text: 'Syarat & Ketentuan',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ' serta '),
                          TextSpan(
                            text: 'Kebijakan Privasi Tokomedia.',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom sticky section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Belum punya akun? ',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/register'),
                  child: const Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
