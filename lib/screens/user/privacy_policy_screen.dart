import 'package:flutter/material.dart';
import 'package:swachh_bharat_app/widgets/section_header.dart';
import 'package:swachh_bharat_app/widgets/standard_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
              title: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
            ),
            const SizedBox(height: 16),
            
            StandardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Information We Collect',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We collect information you provide directly from you, including:\n'
                    '• Name and contact information\n'
                    '• Location data for complaint reporting\n'
                    '• Images and media you upload\n'
                    '• Usage analytics and app performance data',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'How We Use Your Information',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your information is used to:\n'
                    '• Provide and improve our services\n'
                    '• Process complaints and coordinate with authorities\n'
                    '• Send you notifications about your complaints\n'
                    '• Analyze app usage to improve user experience',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Data Protection',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We implement appropriate security measures to protect your data:\n'
                    '• Secure data transmission\n'
                    '• Limited data access within our team\n'
                    '• Regular security audits\n'
                    '• Compliance with data protection regulations',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Rights',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have the right to:\n'
                    '• Access and update your personal information\n'
                    '• Request deletion of your data\n'
                    '• Opt-out of marketing communications\n'
                    '• File complaints with data protection authorities',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Contact Us',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For privacy concerns or questions about this policy, contact us at:\n'
                    'Email: privacy@swachhbharat.app\n'
                    'Phone: 1800-1800-1234',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
