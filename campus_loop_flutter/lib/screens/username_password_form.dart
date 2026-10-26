import 'package:campus_loop_client/campus_loop_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../client.dart';
import '../theme/app_colors.dart';

enum _AuthMode { login, register }

class UsernamePasswordForm extends StatefulWidget {
  final bool setupExistingAccount;
  final bool isDark;
  final Future<void> Function() onAuthenticated;

  const UsernamePasswordForm({
    super.key,
    required this.setupExistingAccount,
    required this.isDark,
    required this.onAuthenticated,
  });

  @override
  State<UsernamePasswordForm> createState() => _UsernamePasswordFormState();
}

class _UsernamePasswordFormState extends State<UsernamePasswordForm> {
  static final RegExp _usernamePattern = RegExp(
    r'^[A-Za-z0-9][A-Za-z0-9._-]{1,30}[A-Za-z0-9]$',
  );

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late _AuthMode _mode;
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  bool get _isRegistering =>
      widget.setupExistingAccount || _mode == _AuthMode.register;

  @override
  void initState() {
    super.initState();
    _mode = widget.setupExistingAccount ? _AuthMode.register : _AuthMode.login;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) return 'Enter a username.';
    if (!_usernamePattern.hasMatch(username)) {
      return 'Use 3–32 letters, numbers, dots, underscores, or hyphens. Start and end with a letter or number.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Enter a password.';
    if (_isRegistering && password.runes.length < 12) {
      return 'Use at least 12 characters.';
    }
    if (password.runes.length > 128) {
      return 'Password must be no more than 128 characters.';
    }
    if (_isRegistering && password.trim().isEmpty) {
      return 'Password cannot contain only whitespace.';
    }
    return null;
  }

  String? _validateConfirmation(String? value) {
    if (value == null || value.isEmpty) return 'Confirm your password.';
    if (value != _passwordController.text) return 'Passwords do not match.';
    return null;
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final result = _isRegistering
          ? await client.usernamePassword.register(
              _usernameController.text.trim(),
              _passwordController.text,
            )
          : await client.usernamePassword.login(
              _usernameController.text.trim(),
              _passwordController.text,
            );
      await client.auth.updateSignedInUser(result);
      await widget.onAuthenticated();
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = _friendlyError(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _friendlyError(Object error) {
    if (error is UsernamePasswordAuthException) return error.message;
    final text = error.toString();
    if (text.contains('SocketException') ||
        text.contains('Connection refused')) {
      return 'Unable to reach the CampusLoop server. Check that it is running.';
    }
    return 'Authentication failed. Check your details and try again.';
  }

  void _switchMode() {
    if (_isSubmitting || widget.setupExistingAccount) return;
    setState(() {
      _mode = _isRegistering ? _AuthMode.login : _AuthMode.register;
      _errorMessage = null;
      _formKey.currentState?.reset();
      _confirmPasswordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isSetup = widget.setupExistingAccount;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.loop_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'CampusLoop',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your campus activity feed & peer-led study groups',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AutofillGroup(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              isSetup
                                  ? 'Set up username and password'
                                  : _isRegistering
                                  ? 'Create your account'
                                  : 'Sign in',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isSetup
                                  ? 'Your existing session can be kept without email. Choose credentials for future sign-ins.'
                                  : 'Use a username and password. No email address is needed.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _usernameController,
                              enabled: !_isSubmitting,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.none,
                              autocorrect: false,
                              maxLength: 32,
                              autofillHints: const [AutofillHints.username],
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Icons.person_outline),
                                counterText: '',
                              ),
                              validator: _validateUsername,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passwordController,
                              enabled: !_isSubmitting,
                              obscureText: _obscurePassword,
                              maxLength: 128,
                              autofillHints: [
                                _isRegistering
                                    ? AutofillHints.newPassword
                                    : AutofillHints.password,
                              ],
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock_outline),
                                counterText: '',
                                suffixIcon: IconButton(
                                  tooltip: _obscurePassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: _isSubmitting
                                      ? null
                                      : () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                              ),
                              validator: _validatePassword,
                            ),
                            if (_isRegistering) ...[
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _confirmPasswordController,
                                enabled: !_isSubmitting,
                                obscureText: _obscurePassword,
                                maxLength: 128,
                                autofillHints: const [
                                  AutofillHints.newPassword,
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Confirm password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  counterText: '',
                                ),
                                validator: _validateConfirmation,
                              ),
                            ],
                            if (_errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.cancelled,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _isSubmitting ? null : _submit,
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      isSetup
                                          ? 'Save username and password'
                                          : _isRegistering
                                          ? 'Create account'
                                          : 'Sign in',
                                    ),
                            ),
                            if (!isSetup) ...[
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _isSubmitting ? null : _switchMode,
                                child: Text(
                                  _isRegistering
                                      ? 'Already have an account? Sign in'
                                      : 'New to CampusLoop? Create an account',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
