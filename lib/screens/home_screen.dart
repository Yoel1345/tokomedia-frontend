import 'package:flutter/material.dart';
import '../widgets/desktop/desktop_home.dart';
import '../widgets/mobile/mobile_home.dart';

class HomeScreen extends StatefulWidget {
  final String? initialSession;
  const HomeScreen({super.key, this.initialSession});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _phoneOrEmail;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && _phoneOrEmail == null) {
      _phoneOrEmail = args;
    }
    if (_phoneOrEmail == null && widget.initialSession != null) {
      _phoneOrEmail = widget.initialSession;
    }
  }

  String _getUsername(String phoneOrEmail) {
    if (phoneOrEmail.contains('@')) {
      return phoneOrEmail.split('@')[0];
    }
    return phoneOrEmail;
  }

  @override
  Widget build(BuildContext context) {
    final username = _phoneOrEmail != null ? _getUsername(_phoneOrEmail!) : 'Yoel';
    final userIdentifier = _phoneOrEmail ?? '';
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return DesktopHome(username: username, userIdentifier: userIdentifier);
        } else {
          return MobileHome(username: username, userIdentifier: userIdentifier);
        }
      },
    );
  }
}
