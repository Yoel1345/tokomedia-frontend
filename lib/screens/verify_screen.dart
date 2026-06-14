import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../main.dart';
import '../service/api_service.dart';

class VerifyScreen extends StatefulWidget {
  final String phoneOrEmail;
  final String code;
  final bool isEmail;
  const VerifyScreen({super.key, required this.phoneOrEmail, required this.code, this.isEmail = false});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text('tokomedia',
                  style: AppTextStyles.logoText.copyWith(fontSize: 28)),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                        size: 80, color: Color(0xFFB0D8E8))),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('Jual Beli Mudah Hanya di Tokomedia',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            const Text(
                                'Gabung dan rasakan kemudahan bertransaksi di Tokomedia',
                                style: TextStyle(
                                    fontSize: 13, color: AppColors.textMedium),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      const SizedBox(width: 60),
                      // Kanan — pilih metode verifikasi
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.all(36),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back,
                                    color: AppColors.textDark),
                                padding: EdgeInsets.zero,
                              ),
                              const SizedBox(height: 16),
                              const Center(
                                child: Text('Pilih Metode Verifikasi',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark)),
                              ),
                              const SizedBox(height: 8),
                              const Center(
                                child: Text(
                                  'Pilih salah satu metode dibawah ini untuk\nmendapatkan kode verifikasi.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textMedium,
                                      height: 1.5),
                                ),
                              ),
                              const SizedBox(height: 24),
                              if (widget.isEmail)
                                _buildVerifyOption(
                                  iconPath: 'assets/icons/email_icon.png',
                                  title: 'E-mail ke',
                                  subtitle: widget.phoneOrEmail,
                                  method: 'email',
                                )
                              else ...[
                                _buildVerifyOption(
                                  iconPath: 'assets/icons/whatsapp_icon.png',
                                  title: 'WhatsApp ke',
                                  subtitle:
                                      '62${widget.phoneOrEmail.replaceFirst('0', '')}',
                                  method: 'whatsapp',
                                ),
                                const SizedBox(height: 12),
                                _buildVerifyOption(
                                  iconPath: 'assets/icons/sms_icon.png',
                                  title: 'SMS ke',
                                  subtitle:
                                      '62${widget.phoneOrEmail.replaceFirst('0', '')}',
                                  method: 'sms',
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('© 2009-2026, PT Tokomedia',
                    style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child:
                        Text('|', style: TextStyle(color: AppColors.border))),
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
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyOption({
    required String iconPath,
    required String title,
    required String subtitle,
    required String method,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreenWrapper(
              phoneOrEmail: widget.phoneOrEmail,
              code: widget.code,
              isEmail: widget.isEmail,
              method: method,
            ),
          ),
        );
        ApiService.sendOtp(widget.phoneOrEmail, method, widget.code);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                iconPath,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.message,
                  color: AppColors.primaryGreen,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textMedium)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
