import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/app_user.dart';
import '../../../services/auth_service.dart';
import '../../widgets/custom_button.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  final List<Widget> _screens = [
    const _AssignedTasksTab(),
    const _ProfileTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'W',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            label: 'Assigned Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _AssignedTasksTab extends StatelessWidget {
  const _AssignedTasksTab();

  @override
  Widget build(BuildContext context) {
    // TODO: Implement assigned tasks list
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks assigned yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Assigned tasks will appear here',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<AppUser?>(context);
    final authService = Provider.of<AuthService>(context);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'W',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  user.email,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                if (user.phone.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.phone,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    'Worker',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildProfileSectionTitle(context, 'Account'),
          _buildProfileItem(
            context,
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: () {
              // TODO: Navigate to edit profile screen
            },
          ),
          _buildProfileItem(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {
              // TODO: Navigate to notifications screen
            },
          ),
          _buildProfileItem(
            context,
            icon: Icons.lock_outline,
            title: 'Change Password',
            onTap: () {
              // TODO: Navigate to change password screen
            },
          ),
          const Divider(height: 40),
          _buildProfileSectionTitle(context, 'Support'),
          _buildProfileItem(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {
              // TODO: Show help dialog
            },
          ),
          _buildProfileItem(
            context,
            icon: Icons.info_outline,
            title: 'About App',
            onTap: () {
              // TODO: Show about dialog
            },
          ),
          _buildProfileItem(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomButton(
              onPressed: () async {
                try {
                  await authService.signOut();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error signing out: $e'),
                        backgroundColor: theme.colorScheme.error,
                      ),
                    );
                  }
                }
              },
              child: const Text('Sign Out'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'App Version 1.0.0',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
