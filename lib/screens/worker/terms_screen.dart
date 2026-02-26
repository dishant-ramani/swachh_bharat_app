import 'package:flutter/material.dart';
import '../../../widgets/worker/section_header.dart';
import '../../../widgets/worker/standard_card.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
                title: 'Terms of Service',
                icon: Icons.description,
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
                title: 'Acceptance of Terms',
                icon: Icons.check_circle,
              ),
              
              StandardCard(
                child: Text(
                  'By downloading, installing, or using the Swachh Bharat app, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our app.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'User Responsibilities',
                icon: Icons.person,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermItem('• Provide accurate and truthful information'),
                    _buildTermItem('• Report only genuine cleanliness issues'),
                    _buildTermItem('• Respect other users and workers'),
                    _buildTermItem('• Not misuse the platform for illegal activities'),
                    _buildTermItem('• Maintain appropriate behavior in communications'),
                    _buildTermItem('• Follow all applicable laws and regulations'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Worker Responsibilities',
                icon: Icons.work,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermItem('• Respond to assigned complaints promptly'),
                    _buildTermItem('• Provide accurate status updates'),
                    _buildTermItem('• Maintain professional conduct'),
                    _buildTermItem('• Verify complaint legitimacy before resolution'),
                    _buildTermItem('• Document progress with appropriate evidence'),
                    _buildTermItem('• Report any system issues to administrators'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Content and Data',
                icon: Icons.storage,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Users retain ownership of their submitted content. By using the app, you grant us a license to:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildTermItem('• Store and process your data for service delivery'),
                    _buildTermItem('• Use anonymized data for service improvement'),
                    _buildTermItem('• Share relevant information with assigned workers'),
                    _buildTermItem('• Comply with legal and regulatory requirements'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Prohibited Activities',
                icon: Icons.block,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermItem('• Submitting false or misleading complaints'),
                    _buildTermItem('• Harassing or threatening other users'),
                    _buildTermItem('• Attempting to compromise system security'),
                    _buildTermItem('• Using the app for commercial purposes'),
                    _buildTermItem('• Interfering with service operations'),
                    _buildTermItem('• Violating intellectual property rights'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Service Availability',
                icon: Icons.schedule,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'We strive to provide reliable service, but:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildTermItem('• Service availability is not guaranteed 24/7'),
                    _buildTermItem('• We may suspend service for maintenance'),
                    _buildTermItem('• We are not liable for service interruptions'),
                    _buildTermItem('• Users should report service issues promptly'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Limitation of Liability',
                icon: Icons.gavel,
              ),
              
              StandardCard(
                child: Text(
                  'To the maximum extent permitted by law, Swachh Bharat shall not be liable for any indirect, incidental, or consequential damages arising from your use of the app.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Termination',
                icon: Icons.exit_to_app,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTermItem('• We may terminate accounts for violations'),
                    _buildTermItem('• Users can delete their accounts anytime'),
                    _buildTermItem('• Termination does not waive obligations'),
                    _buildTermItem('• We may discontinue the service with notice'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Changes to Terms',
                icon: Icons.update,
              ),
              
              StandardCard(
                child: Text(
                  'We reserve the right to modify these terms at any time. Changes will be effective immediately upon posting in the app. Continued use constitutes acceptance of modified terms.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Contact Information',
                icon: Icons.contact_mail,
              ),
              
              StandardCard(
                child: ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('Legal Inquiries'),
                  subtitle: const Text('legal@swachhbharat.com'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              
              const SizedBox(height: 32),
              
              StandardCard(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                child: Text(
                  'These Terms of Service constitute the entire agreement between you and Swachh Bharat regarding the use of our app.',
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

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.4),
      ),
    );
  }
}
