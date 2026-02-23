import 'package:flutter/material.dart';
import 'package:swachh_bharat_app/widgets/section_header.dart';
import 'package:swachh_bharat_app/widgets/standard_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            
            // App Logo
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.cleaning_services_outlined,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Swachh Bharat',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Clean India Mission',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            SectionHeader(
              title: 'App Information',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 16),
            
            StandardCard(
              child: Column(
                children: [
                  _buildInfoRow(context, 'Version', '1.0.0'),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, 'Build', '1.0.0'),
                  const SizedBox(height: 8),
                  _buildInfoRow(context, 'Developer', 'Swachh Bharat Team'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            SectionHeader(
              title: 'Mission',
              icon: Icons.lightbulb_outline,
            ),
            const SizedBox(height: 16),
            
            StandardCard(
              child: Text(
                'Swachh Bharat App is dedicated to keeping our communities clean and green. '
                'Through this platform, citizens can easily report cleanliness issues, '
                'track their resolution, and contribute to the Swachh Bharat mission.\n\n'
                'Together, we can build a cleaner, healthier India for future generations.',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 32),
            
            SectionHeader(
              title: 'Contact',
              icon: Icons.contact_mail_outlined,
            ),
            const SizedBox(height: 16),
            
            StandardCard(
              child: Column(
                children: [
                  Text(
                    'Email: support@swachhbharat.app',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Website: www.swachhbharat.gov.in',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Helpline: 1800-1800-1234',
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

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
