import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/auth_service.dart';
import '../user/user_home_screen.dart';
import '../worker/worker_home_screen.dart';

class RoleRedirectScreen extends StatelessWidget {
  const RoleRedirectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final currentUser = authService.currentUser;

    if (currentUser == null) {
      // If user is not logged in, navigate to login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Check user role and redirect accordingly
    if (currentUser.role == 'worker') {
      return const WorkerHomeScreen();
    } else {
      // Default to user home screen
      return const UserHomeScreen();
    }
  }
}
