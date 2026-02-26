import 'package:flutter/material.dart';
import '../../../widgets/worker/section_header.dart';
import '../../../widgets/worker/standard_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
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
              
              // App Logo and Name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.cleaning_services,
                        size: 50,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Swachh Bharat',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Cleanliness Complaint Management',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              
              SectionHeader(
                title: 'About Swachh Bharat',
                icon: Icons.info,
              ),
              
              StandardCard(
                child: Text(
                  'Swachh Bharat Cleanliness Complaint Management System is a digital platform designed to address cleanliness issues in our communities. Citizens can report cleanliness complaints, and assigned workers can efficiently manage and resolve them.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Key Features',
                icon: Icons.star,
              ),
              
              StandardCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeatureItem('• Report cleanliness issues with photos'),
                    _buildFeatureItem('• Track complaint status in real-time'),
                    _buildFeatureItem('• Efficient worker assignment system'),
                    _buildFeatureItem('• Progress tracking with image updates'),
                    _buildFeatureItem('• Location-based complaint reporting'),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Our Mission',
                icon: Icons.flag,
              ),
              
              StandardCard(
                child: Text(
                  'To create cleaner and healthier communities by providing a seamless platform for citizens to report cleanliness issues and ensuring timely resolution through efficient worker management.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Contact Information',
                icon: Icons.contact_mail,
              ),
              
              StandardCard(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: const Text('info@swachhbharat.com'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.language),
                      title: const Text('Website'),
                      subtitle: const Text('www.swachhbharat.com'),
                      contentPadding: EdgeInsets.zero,
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Office'),
                      subtitle: const Text('Ministry of Urban Development, New Delhi'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              SectionHeader(
                title: 'Acknowledgments',
                icon: Icons.favorite,
              ),
              
              StandardCard(
                child: Text(
                  'This app is developed as part of the Swachh Bharat Abhiyan initiative to promote cleanliness and hygiene across India. We thank all citizens and workers who contribute to keeping our communities clean.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              
              const SizedBox(height: 32),
              
              Center(
                child: Text(
                  'Made with ❤️ for a cleaner India',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
