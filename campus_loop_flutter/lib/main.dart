import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';
import 'screens/home_shell_screen.dart';
import 'screens/sign_in_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const CampusLoopApp());
}

class CampusLoopApp extends StatelessWidget {
  const CampusLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusLoop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: SignInScreen(
        child: HomeShellScreen(
          onSignOut: () async {
            await client.auth.signOutDevice();
          },
        ),
      ),
    );
  }
}
