import 'package:flutter/material.dart';
import 'package:swachh_bharat_app/widgets/section_header.dart';
import 'package:swachh_bharat_app/widgets/profile_option_tile.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
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
              title: 'Frequently Asked Questions',
              icon: Icons.help_outline,
            ),
            const SizedBox(height: 16),
            
            ProfileOptionTile(
              icon: Icons.question_answer_outlined,
              title: 'How to file a complaint?',
              onTap: () {
                // TODO: Show FAQ for filing complaints
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.question_answer_outlined,
              title: 'How to track complaint status?',
              onTap: () {
                // TODO: Show FAQ for tracking
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.question_answer_outlined,
              title: 'What are complaint categories?',
              onTap: () {
                // TODO: Show categories info
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.question_answer_outlined,
              title: 'How long does resolution take?',
              onTap: () {
                // TODO: Show resolution time info
              },
            ),
            
            const SizedBox(height: 24),
            
            SectionHeader(
              title: 'Contact Support',
              icon: Icons.support_agent_outlined,
            ),
            const SizedBox(height: 16),
            
            ProfileOptionTile(
              icon: Icons.phone_outlined,
              title: 'Call Support',
              subtitle: '+91-XXXX-XXXX',
              onTap: () {
                // TODO: Implement phone call
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'support@swachhbharat.app',
              onTap: () {
                // TODO: Implement email support
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.chat_outlined,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
              onTap: () {
                // TODO: Implement live chat
              },
            ),
            
            const SizedBox(height: 24),
            
            SectionHeader(
              title: 'Report an Issue',
              icon: Icons.bug_report_outlined,
            ),
            const SizedBox(height: 16),
            
            ProfileOptionTile(
              icon: Icons.report_problem_outlined,
              title: 'Report App Issue',
              subtitle: 'Report technical problems with the app',
              onTap: () {
                // TODO: Implement issue reporting
              },
            ),
            
            ProfileOptionTile(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts and suggestions',
              onTap: () {
                // TODO: Implement feedback form
              },
            ),
          ],
        ),
      ),
    );
  }
}
