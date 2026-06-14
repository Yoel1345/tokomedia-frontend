import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../service/api_service.dart';

class MobileOtpScreen extends StatefulWidget {
  final String phoneOrEmail;
  final String code;
  final bool isEmail;
  final String method;
  const MobileOtpScreen({super.key, required this.phoneOrEmail, required this.code, this.isEmail = false, required this.method});

  @override
  State<MobileOtpScreen> createState() => _MobileOtpScreenState();
}

class _MobileOtpScreenState extends State<MobileOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocus = FocusNode();
  bool _isLoading = false;
  int _countdown = 60;
  Timer? _timer;
  late String _code;

  @override
  void initState() {
    super.initState();
    _code = widget.code;
    _startTimer();
    _otpController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocus.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 0) {
        timer.cancel();
        if (mounted) setState(() {});
        return;
      }
      setState(() => _countdown--);
    });
  }

  Future<void> _handleResend() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiService.register(widget.phoneOrEmail, widget.phoneOrEmail);
      if (mounted) {
        if (res['status'] == 'success') {
          _code = res['code'] as String;
          _otpController.clear();
          await ApiService.sendOtp(widget.phoneOrEmail, widget.method, _code);
          _startTimer();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kode telah dikirim ulang')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? 'Gagal mengirim ulang')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim ulang kode')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleVerify() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan kode verifikasi 6 digit')),
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final res = await ApiService.verify(widget.phoneOrEmail, widget.phoneOrEmail, otp);
      if (mounted) {
        if (res['status'] == 'success') {
          Navigator.pushReplacementNamed(context, '/home', arguments: widget.phoneOrEmail);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'] ?? 'Kode verifikasi salah')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifikasi gagal')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  IconData _methodIcon() {
    switch (widget.method) {
      case 'whatsapp':
        return Icons.message;
      case 'sms':
        return Icons.sms_outlined;
      case 'email':
        return Icons.mail_outline;
      default:
        return Icons.message;
    }
  }

  String _methodLabel() {
    switch (widget.method) {
      case 'whatsapp':
        return 'WhatsApp';
      case 'sms':
        return 'SMS';
      case 'email':
        return 'E-mail';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: AppColors.textDark),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _methodIcon(),
                        color: AppColors.primaryGreen,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Masukkan Kode Verifikasi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Kode verifikasi telah dikirim melalui ${_methodLabel()}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () => _otpFocus.requestFocus(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(6, (i) {
                          final hasDigit = i < _otpController.text.length;
                          final digit = hasDigit ? _otpController.text[i] : '';
                          final isFocused = _otpFocus.hasFocus && i == _otpController.text.length;
                          return Container(
                            width: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              children: [
                                Text(
                                  digit,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 2,
                                  color: isFocused
                                      ? AppColors.primaryGreen
                                      : hasDigit
                                          ? AppColors.primaryGreen
                                          : AppColors.border,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      width: 0,
                      height: 0,
                      child: TextField(
                        controller: _otpController,
                        focusNode: _otpFocus,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(counterText: '', border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_countdown > 0)
                      Text(
                        'Kirim ulang dalam $_countdown detik',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      )
                    else
                      InkWell(
                        onTap: _isLoading ? null : _handleResend,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Tidak menerima kode? ',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textMedium,
                              ),
                            ),
                            Text(
                              'Kirim ulang',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleVerify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Verifikasi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
