import 'package:flutter/material.dart';
import 'package:swachh_bharat_app/widgets/section_header.dart';
import 'package:swachh_bharat_app/widgets/profile_option_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            
            SectionHeader(
              title: 'Preferences',
              icon: Icons.tune_outlined,
            ),
            const SizedBox(height: 16),
            
            ProfileOptionTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage notification preferences',
              onTap: () {
                // TODO: Implement notification settings
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.dark_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Toggle dark/light theme',
              onTap: () {
                // TODO: Implement theme toggle
              },
            ),
            
            const SizedBox(height: 24),
            
            SectionHeader(
              title: 'Privacy & Security',
              icon: Icons.security_outlined,
            ),
            const SizedBox(height: 16),
            
            ProfileOptionTile(
              icon: Icons.lock_outlined,
              title: 'Change Password',
              subtitle: 'Update your password',
              onTap: () {
                // TODO: Implement password change
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Settings',
              subtitle: 'Manage your privacy preferences',
              onTap: () {
                // TODO: Implement privacy settings
              },
            ),
            
            const SizedBox(height: 24),
            
            SectionHeader(
              title: 'About',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 16),
            
            ProfileOptionTile(
              icon: Icons.info_outline,
              title: 'App Version',
              subtitle: 'Version 1.0.0',
              onTap: null,
            ),
            
            ProfileOptionTile(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'View terms and conditions',
              onTap: () {
                // TODO: Navigate to terms
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'View privacy policy',
              onTap: () {
                // TODO: Navigate to privacy policy
              },
            ),
          ],
        ),
      ),
    );
  }
}
