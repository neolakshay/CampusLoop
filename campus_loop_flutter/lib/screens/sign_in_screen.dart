import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../client.dart';
import '../widgets/error_view.dart';
import 'username_password_form.dart';

class SignInScreen extends StatefulWidget {
  final Widget child;

  const SignInScreen({super.key, required this.child});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignedIn = false;
  bool _isCheckingCredentials = false;
  bool? _hasUsernameCredentials;
  String? _checkError;
  int _checkGeneration = 0;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_updateSignedInState);
    _isSignedIn = client.auth.isAuthenticated;
    if (_isSignedIn) unawaited(_checkUsernameCredentials());
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_updateSignedInState);
    super.dispose();
  }

  void _updateSignedInState() {
    final isAuthenticated = client.auth.isAuthenticated;
    if (isAuthenticated == _isSignedIn) return;

    setState(() {
      _isSignedIn = isAuthenticated;
      _hasUsernameCredentials = null;
      _checkError = null;
      _isCheckingCredentials = isAuthenticated;
    });

    if (isAuthenticated) {
      unawaited(_checkUsernameCredentials());
    } else {
      _checkGeneration++;
    }
  }

  Future<void> _checkUsernameCredentials() async {
    final generation = ++_checkGeneration;
    if (mounted) {
      setState(() {
        _isCheckingCredentials = true;
        _checkError = null;
      });
    }

    try {
      final hasCredentials = await client.usernamePassword
          .hasUsernameCredentials();
      if (!mounted || generation != _checkGeneration) return;
      setState(() {
        _hasUsernameCredentials = hasCredentials;
        _isCheckingCredentials = false;
      });
    } catch (_) {
      if (!mounted || generation != _checkGeneration) return;
      setState(() {
        _checkError =
            'Unable to verify this account right now. Check the server connection and retry.';
        _isCheckingCredentials = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isSignedIn && _hasUsernameCredentials == true) return widget.child;

    if (_isSignedIn && _isCheckingCredentials) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isSignedIn && _checkError != null) {
      return Scaffold(
        body: ErrorView(
          message: _checkError!,
          onRetry: _checkUsernameCredentials,
        ),
      );
    }

    return UsernamePasswordForm(
      setupExistingAccount: _isSignedIn && _hasUsernameCredentials == false,
      onAuthenticated: _checkUsernameCredentials,
      isDark: isDark,
    );
  }
}
