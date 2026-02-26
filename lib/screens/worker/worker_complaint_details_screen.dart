import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../models/app_user.dart';
import '../../../models/complaint.dart';
import '../../../services/complaint_service.dart';
import '../../../services/user_service.dart';
import '../../../widgets/custom_button.dart';
import '../../widgets/worker/status_badge.dart';
import '../../widgets/worker/section_header.dart';
import '../../widgets/worker/standard_card.dart';
import 'package:intl/intl.dart';

class WorkerComplaintDetailsScreen extends StatefulWidget {
  final String complaintId;

  const WorkerComplaintDetailsScreen({
    super.key,
    required this.complaintId,
  });

  @override
  State<WorkerComplaintDetailsScreen> createState() =>
      _WorkerComplaintDetailsScreenState();
}

class _WorkerComplaintDetailsScreenState
    extends State<WorkerComplaintDetailsScreen> {
  final _updateController = TextEditingController();
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  Complaint? _complaint;
  AppUser? _complainant;
  List<File> _progressImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadComplaintDetails();
  }

  @override
  void dispose() {
    _updateController.dispose();
    super.dispose();
  }

  Future<void> _loadComplaintDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final complaintService =
          Provider.of<ComplaintService>(context, listen: false);
      final userService = Provider.of<UserService>(context, listen: false);

      final complaint = await complaintService.getComplaintById(widget.complaintId);
      
      if (complaint == null) {
        throw Exception('Complaint not found');
      }

      // Load complainant details
      AppUser? complainant;
      try {
        final userData = await userService.getUserData(complaint.userId);
        if (userData != null) {
          complainant = userData;
        }
      } catch (e) {
        debugPrint('Error loading complainant: $e');
      }

      if (mounted) {
        setState(() {
          _complaint = complaint;
          _complainant = complainant;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load complaint details: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateStatus(String status) async {
    if (_isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final complaintService =
          Provider.of<ComplaintService>(context, listen: false);
      final currentUser = Provider.of<AppUser?>(context, listen: false);

      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // Update status
      await complaintService.updateComplaintStatus(
        complaintId: widget.complaintId,
        status: status,
        assignedTo: status == 'in_progress' ? currentUser.uid : null,
      );

      // Upload progress images if any
      if (_progressImages.isNotEmpty) {
        for (final image in _progressImages) {
          await complaintService.addProgressImage(
            complaintId: widget.complaintId,
            imageFile: image,
          );
        }
      }

      // Reload complaint details
      await _loadComplaintDetails();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status updated to ${status.replaceAll('_', ' ')}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update status: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _progressImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: $e';
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _progressImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to take photo: $e';
      });
    }
  }

  Future<void> _openMap(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open map'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = Provider.of<AppUser?>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_complaint == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Complaint Details')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'Complaint not found',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _loadComplaintDetails,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final complaint = _complaint!;
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
    final canUpdateStatus = complaint.status != 'resolved' &&
        complaint.status != 'rejected';
    final isAssignedToMe = complaint.assignedTo == currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Details'),
        elevation: 1,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadComplaintDetails,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error message
              if (_errorMessage != null)
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
                ),

              // Complaint header with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      complaint.category,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StatusBadge(status: complaint.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'ID: ${complaint.complaintId}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),

              // Description
              SectionHeader(
                title: 'Description',
                icon: Icons.description,
              ),
              StandardCard(
                child: Text(complaint.description),
              ),
              const SizedBox(height: 24),

              // Image
              if (complaint.photoUrl != null) ...[
                SectionHeader(
                  title: 'Photo',
                  icon: Icons.photo,
                ),
                StandardCard(
                  padding: EdgeInsets.zero,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      complaint.photoUrl!,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey.shade200,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Location
              SectionHeader(
                title: 'Location',
                icon: Icons.location_on,
              ),
              StandardCard(
                onTap: () => _openMap(
                  complaint.location.latitude,
                  complaint.location.longitude,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complaint.address,
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            'View on Map',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: theme.hintColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Complainant Details
              if (_complainant != null) ...[
                SectionHeader(
                  title: 'Complainant',
                  icon: Icons.person,
                ),
                StandardCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        _complainant!.name[0].toUpperCase(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(_complainant!.name),
                    subtitle: _complainant?.phone != null
                        ? Text(_complainant!.phone!)
                        : null,
                    trailing: _complainant?.phone != null
                        ? IconButton(
                            icon: const Icon(Icons.phone),
                            onPressed: () =>
                                launchUrlString('tel:${_complainant!.phone}'),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Status Update Section
              if (canUpdateStatus && (isAssignedToMe || !isAssignedToMe && complaint.status == 'pending'))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: 'Update Status',
                      icon: Icons.update,
                    ),
                    if (complaint.status == 'pending')
                      StandardCard(
                        child: CustomButton(
                          onPressed: _isSubmitting
                              ? null
                              : () => _updateStatus('in_progress'),
                          isLoading: _isSubmitting,
                          child: const Text('Start Working'),
                        ),
                      ),
                    if (complaint.status == 'in_progress' && isAssignedToMe)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Progress Images
                          SectionHeader(
                            title: 'Add Progress Images',
                            icon: Icons.photo_library,
                          ),
                          SizedBox(
                            height: 100,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ..._progressImages.map((file) => Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              file,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _progressImages
                                                      .remove(file);
                                                });
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => SafeArea(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ListTile(
                                              leading: const Icon(Icons.photo_library),
                                              title: const Text('Choose from Gallery'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _pickImage();
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(Icons.camera_alt),
                                              title: const Text('Take a Photo'),
                                              onTap: () {
                                                Navigator.pop(context);
                                                _takePhoto();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.dividerColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 32,
                                          color: theme.hintColor,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Add Photo',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Status update
                          SectionHeader(
                            title: 'Update Note',
                            icon: Icons.note_add,
                          ),
                          StandardCard(
                            child: TextField(
                              controller: _updateController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Add an update (optional)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : () => _updateStatus('in_progress'),
                                  child: const Text('Save Update'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomButton(
                                  onPressed: _isSubmitting
                                      ? null
                                      : () => _updateStatus('resolved'),
                                  isLoading: _isSubmitting,
                                  child: const Text('Mark as Resolved'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                  ],
                ),

              // Progress Images
              if (complaint.progressImages.isNotEmpty) ...[
                SectionHeader(
                  title: 'Progress Updates',
                  icon: Icons.history,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: complaint.progressImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            // TODO: Show full screen image viewer
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              complaint.progressImages[index],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Timeline
              SectionHeader(
                title: 'Status Timeline',
                icon: Icons.timeline,
              ),
              StandardCard(
                child: _buildTimeline(complaint),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline(Complaint complaint) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy hh:mm a');
    
    final statuses = [
      _TimelineItem(
        title: 'Submitted',
        time: complaint.createdAt,
        isActive: true,
        isFirst: true,
      ),
      if (complaint.status == 'in_progress' || complaint.status == 'resolved')
        _TimelineItem(
          title: 'In Progress',
          time: complaint.updatedAt, // This should be the actual in_progress time
          isActive: true,
          isLast: complaint.status == 'in_progress',
        ),
      if (complaint.status == 'resolved')
        _TimelineItem(
          title: 'Resolved',
          time: complaint.updatedAt,
          isActive: true,
          isLast: true,
        ),
    ];

    if (statuses.isEmpty) {
      return const Text('No status updates available');
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: statuses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = statuses[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line and dot
            Column(
              children: [
                // Top line (only if not first item)
                if (!item.isFirst)
                  Container(
                    width: 2,
                    height: 20,
                    color: theme.dividerColor,
                  ),
                // Dot
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: item.isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
                // Bottom line (only if not last item)
                if (!item.isLast)
                  Container(
                    width: 2,
                    height: 20,
                    color: theme.dividerColor,
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Status text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: item.isActive
                          ? theme.textTheme.bodyLarge?.color
                          : theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    dateFormat.format(item.time.toLocal()),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TimelineItem {
  final String title;
  final DateTime time;
  final bool isActive;
  final bool isFirst;
  final bool isLast;

  _TimelineItem({
    required this.title,
    required this.time,
    this.isActive = false,
    this.isFirst = false,
    this.isLast = false,
  });
}
