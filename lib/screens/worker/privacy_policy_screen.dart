import 'package:flutter/material.dart';
import '../../../widgets/worker/section_header.dart';
import '../../../widgets/worker/standard_card.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 1,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              
              SectionHeader(
                title: 'Privacy Policy',
                icon: Icons.privacy_tip,
              ),
              
              StandardCard(
                child: Text(
                  'Last updated: January 2024',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Information We Collect',
                icon: Icons.info,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We collect the following information to provide our services:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildPolicyItem('• Personal Information: Name, email, phone number'),
                    _buildPolicyItem('• Location Data: GPS coordinates for complaint reporting'),
                    _buildPolicyItem('• Device Information: Device type, operating system'),
                    _buildPolicyItem('• Usage Data: How you interact with the app'),
                    _buildPolicyItem('• Photos and Images: Complaint and progress photos'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'How We Use Your Information',
                icon: Icons.settings,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPolicyItem('• Process and manage cleanliness complaints'),
                    _buildPolicyItem('• Assign complaints to appropriate workers'),
                    _buildPolicyItem('• Track complaint status and progress'),
                    _buildPolicyItem('• Communicate updates to users'),
                    _buildPolicyItem('• Improve our services and user experience'),
                    _buildPolicyItem('• Ensure platform security and prevent fraud'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Data Protection',
                icon: Icons.security,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We implement appropriate security measures to protect your data:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildPolicyItem('• Secure data encryption in transit and at rest'),
                    _buildPolicyItem('• Regular security audits and updates'),
                    _buildPolicyItem('• Limited access to authorized personnel only'),
                    _buildPolicyItem('• Compliance with data protection regulations'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Data Sharing',
                icon: Icons.share,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We may share your information only in the following circumstances:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildPolicyItem('• With assigned workers for complaint resolution'),
                    _buildPolicyItem('• With government authorities as required by law'),
                    _buildPolicyItem('• With service providers for essential operations'),
                    _buildPolicyItem('• Anonymized data for research and analytics'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Your Rights',
                icon: Icons.gavel,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPolicyItem('• Access your personal data'),
                    _buildPolicyItem('• Correct inaccurate information'),
                    _buildPolicyItem('• Request deletion of your data'),
                    _buildPolicyItem('• Opt-out of non-essential communications'),
                    _buildPolicyItem('• File complaints about data handling'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Contact Us',
                icon: Icons.contact_mail,
              ),
              
              StandardCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Privacy Concerns'),
                      subtitle: const Text('privacy@swachhbharat.com'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Helpline'),
                      subtitle: const Text('1800-123-4567'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              StandardCard(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                child: Text(
                  'By using the Swachh Bharat app, you agree to the collection and use of information as described in this Privacy Policy.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.4),
      ),
    );
  }
}
