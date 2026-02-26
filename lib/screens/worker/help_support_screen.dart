import 'package:flutter/material.dart';
import '../../../widgets/worker/section_header.dart';
import '../../../widgets/worker/standard_card.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
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
                title: 'Frequently Asked Questions',
                icon: Icons.help_outline,
              ),
              
              StandardCard(
                child: ExpansionTile(
                  title: const Text('How do I update complaint status?'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'To update a complaint status, navigate to the complaint details and use the status update buttons. You can mark complaints as "In Progress" when you start working and "Resolved" when completed.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              
              StandardCard(
                child: ExpansionTile(
                  title: const Text('How do I add progress images?'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'When a complaint is in progress, you can add progress images by tapping the "Add Photo" button in the complaint details screen. You can choose from gallery or take a new photo.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              
              StandardCard(
                child: ExpansionTile(
                  title: const Text('What are the different complaint statuses?'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '• Pending: Complaint is waiting to be assigned\n'
                        '• In Progress: You are currently working on it\n'
                        '• Resolved: The complaint has been successfully addressed\n'
                        '• Rejected: The complaint was not valid',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              SectionHeader(
                title: 'Contact Support',
                icon: Icons.contact_support,
              ),
              
              StandardCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email Support'),
                      subtitle: const Text('support@swachhbharat.com'),
                      onTap: () {
                        // TODO: Open email app
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('Helpline'),
                      subtitle: const Text('1800-123-4567'),
                      onTap: () {
                        // TODO: Open phone dialer
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.schedule),
                      title: const Text('Working Hours'),
                      subtitle: const Text('Mon-Fri: 9:00 AM - 6:00 PM'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              SectionHeader(
                title: 'Report an Issue',
                icon: Icons.bug_report,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'If you\'re experiencing technical issues, please provide the following details:',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildIssueItem('• Device type and model'),
                    _buildIssueItem('• App version'),
                    _buildIssueItem('• Steps to reproduce the issue'),
                    _buildIssueItem('• Screenshots if applicable'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Open issue reporting flow
                      },
                      child: const Text('Report Issue'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIssueItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(text),
    );
  }
}
