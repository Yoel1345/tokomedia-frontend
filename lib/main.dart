import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/verify_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/mobile_login_screen.dart';
import 'screens/mobile_register_screen.dart';
import 'screens/mobile_verify_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/mobile_otp_screen.dart';

void main() {
  runApp(const TokopediaApp());
}

class TokopediaApp extends StatelessWidget {
  const TokopediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tokomedia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF42B549),
          primary: const Color(0xFF42B549),
        ),
        fontFamily: 'sans-serif',
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreenWrapper(),
        '/register': (context) => const RegisterScreenWrapper(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

// Wrapper untuk Login - Auto switch Desktop/Mobile
class LoginScreenWrapper extends StatelessWidget {
  const LoginScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return const LoginScreen();
        } else {
          return const MobileLoginScreen();
        }
      },
    );
  }
}

// Wrapper untuk Register - Auto switch Desktop/Mobile
class RegisterScreenWrapper extends StatelessWidget {
  const RegisterScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return const RegisterScreen();
        } else {
          return const MobileRegisterScreen();
        }
      },
    );
  }
}

// Wrapper untuk Verify - Auto switch Desktop/Mobile
class VerifyScreenWrapper extends StatelessWidget {
  final String phoneOrEmail;
  final String code;
  final bool isEmail;
  const VerifyScreenWrapper({super.key, required this.phoneOrEmail, required this.code, this.isEmail = false});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return VerifyScreen(phoneOrEmail: phoneOrEmail, code: code, isEmail: isEmail);
        } else {
          return MobileVerifyScreen(phoneOrEmail: phoneOrEmail, code: code, isEmail: isEmail);
        }
      },
    );
  }
}

// Wrapper untuk OTP Input - Auto switch Desktop/Mobile
class OtpScreenWrapper extends StatelessWidget {
  final String phoneOrEmail;
  final String code;
  final bool isEmail;
  final String method;
  const OtpScreenWrapper({super.key, required this.phoneOrEmail, required this.code, this.isEmail = false, required this.method});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return OtpScreen(phoneOrEmail: phoneOrEmail, code: code, isEmail: isEmail, method: method);
        } else {
          return MobileOtpScreen(phoneOrEmail: phoneOrEmail, code: code, isEmail: isEmail, method: method);
        }
      },
    );
  }
}
