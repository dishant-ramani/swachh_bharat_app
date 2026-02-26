import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/app_user.dart';
import '../../../models/complaint.dart';
import '../../../services/auth_service.dart';
import '../../../services/complaint_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/worker/worker_complaint_card.dart';
import '../../widgets/worker/section_header.dart';
import '../../widgets/worker/standard_card.dart';
import 'worker_complaint_details_screen.dart';
import 'edit_profile_screen.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';
import 'privacy_policy_screen.dart';
import 'terms_screen.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const WorkerDashboardScreen(),
    const AssignedComplaintsScreen(),
    const WorkerProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Dashboard'),
        elevation: 1,
        centerTitle: true,
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : 'W',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Assigned',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Separate screen classes for better organization

class WorkerDashboardScreen extends StatefulWidget {
  const WorkerDashboardScreen({super.key});

  @override
  State<WorkerDashboardScreen> createState() => _WorkerDashboardScreenState();
}

class _WorkerDashboardScreenState extends State<WorkerDashboardScreen> {
  bool _isLoading = false;
  int _assignedCount = 0;
  int _inProgressCount = 0;
  int _resolvedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    try {
      final complaintService = Provider.of<ComplaintService>(context, listen: false);
      final user = Provider.of<AppUser?>(context, listen: false);
      
      if (user != null) {
        // Get all complaints and filter for worker
        final complaints = await complaintService.getWorkerComplaintsList(user.uid);
        _assignedCount = complaints.where((c) => c.status == 'pending').length;
        _inProgressCount = complaints.where((c) => c.status == 'in_progress').length;
        _resolvedCount = complaints.where((c) => c.status == 'resolved').length;
      }
    } catch (e) {
      debugPrint('Error loading stats: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'Dashboard',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 32),

          if (_isLoading) ...[
            const Center(child: CircularProgressIndicator()),
          ] else ...[
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: StandardCard(
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          color: Colors.orange,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_assignedCount',
                          style: theme.textTheme.headlineMedium,
                        ),
                        Text(
                          'Assigned',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StandardCard(
                    child: Column(
                      children: [
                        Icon(
                          Icons.build,
                          color: Colors.blue,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_inProgressCount',
                          style: theme.textTheme.headlineMedium,
                        ),
                        Text(
                          'In Progress',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StandardCard(
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_resolvedCount',
                          style: theme.textTheme.headlineMedium,
                        ),
                        Text(
                          'Resolved',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            SectionHeader(
              title: 'Quick Actions',
              icon: Icons.flash_on,
            ),
            StandardCard(
              child: CustomButton(
                onPressed: () {
                  // Navigate to assigned complaints
                  final parentState = context.findAncestorStateOfType<_WorkerHomeScreenState>();
                  parentState?._onItemTapped(1);
                },
                child: const Text('View Assigned Complaints'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AssignedComplaintsScreen extends StatefulWidget {
  const AssignedComplaintsScreen({super.key});

  @override
  State<AssignedComplaintsScreen> createState() => _AssignedComplaintsScreenState();
}

class _AssignedComplaintsScreenState extends State<AssignedComplaintsScreen> {
  bool _isLoading = false;
  List<Complaint> _complaints = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  Future<void> _loadComplaints() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final complaintService = Provider.of<ComplaintService>(context, listen: false);
      final user = Provider.of<AppUser?>(context, listen: false);
      
      if (user != null) {
        final complaints = await complaintService.getWorkerComplaintsList(user.uid);
        if (mounted) {
          setState(() {
            _complaints = complaints;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load complaints: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          SectionHeader(
            title: 'Assigned Complaints',
            icon: Icons.assignment,
          ),
          const SizedBox(height: 16),

          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_errorMessage != null)
            StandardCard(
              color: theme.colorScheme.errorContainer,
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else if (_complaints.isEmpty)
            StandardCard(
              child: Column(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 64,
                    color: theme.colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No complaints assigned',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Assigned complaints will appear here',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            )
          else
            ..._complaints.map((complaint) => WorkerComplaintCard(
              complaint: complaint,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WorkerComplaintDetailsScreen(
                      complaintId: complaint.complaintId,
                    ),
                  ),
                );
              },
              showAssignedBadge: complaint.assignedTo != null,
            )),
        ],
      ),
    );
  }
}

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<AppUser?>(context);
    final authService = Provider.of<AuthService>(context);

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          // Profile Header
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

          // Account Section
          SectionHeader(
            title: 'Account',
            icon: Icons.account_circle,
          ),
          StandardCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.edit_outlined),
              title: Text('Edit Profile'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: 24),

          // Support Section
          SectionHeader(
            title: 'Support',
            icon: Icons.support,
          ),
          StandardCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Help & Support'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          StandardCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About App'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          StandardCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          StandardCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsScreen()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.description_outlined),
              title: Text('Terms of Service'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          CustomButton(
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
}
