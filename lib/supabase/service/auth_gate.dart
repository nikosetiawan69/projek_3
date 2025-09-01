import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_samples/ui/home.dart';
import 'package:flutter_samples/ui/screen/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final StreamSubscription<AuthState> _sub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (mounted) {
        if (event == AuthChangeEvent.signedOut) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return user != null ? const RiveAppHome() : const LoginPage();
  }
}
