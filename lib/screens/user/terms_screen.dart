import 'package:flutter/material.dart';
import 'package:swachh_bharat_app/widgets/section_header.dart';
import 'package:swachh_bharat_app/widgets/standard_card.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
              title: 'Terms of Service',
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 16),
            
            StandardCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Acceptance of Terms',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By using the Swachh Bharat app, you agree to these terms and conditions. '
                    'Please read them carefully before using our services.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    '1. Account Registration',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You must provide accurate, complete, and current information when creating an account. '
                    'You are responsible for maintaining the confidentiality of your account credentials.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    '2. Acceptable Use',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The app is intended for reporting cleanliness issues and related concerns. '
                    'Any misuse of the platform may result in account suspension.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    '3. Complaint Reporting',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Users should only file genuine complaints with accurate information. '
                    'False or malicious reports may result in legal consequences.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    '4. Privacy and Data',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your personal information is protected as per our Privacy Policy. '
                    'We may share anonymized data with relevant authorities for complaint resolution.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    '5. Intellectual Property',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'All content and materials on this app are protected by copyright and other intellectual property laws. '
                    'Unauthorized use or reproduction is prohibited.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    '6. Limitation of Liability',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The app and its services are provided "as is" without warranties of any kind. '
                    'We are not liable for any damages arising from your use of the app.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    '7. Modifications to Terms',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We reserve the right to modify these terms at any time. '
                    'Continued use of the app constitutes acceptance of any updated terms.',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    '8. Contact Information',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'For questions about these terms, contact us at:\n'
                    'Email: legal@swachhbharat.app\n'
                    'Phone: 1800-1800-1234',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Last Updated: January 1, 2024',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
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
