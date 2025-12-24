import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swachh_bharat_app/models/complaint.dart';

class ComplaintDetailsScreen extends StatefulWidget {
  final Complaint complaint;
  final String complaintId;

  const ComplaintDetailsScreen({
    Key? key,
    required this.complaint,
    required this.complaintId,
  }) : super(key: key);

  @override
  _ComplaintDetailsScreenState createState() => _ComplaintDetailsScreenState();
}

class _ComplaintDetailsScreenState extends State<ComplaintDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  // Helper method to get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'resolved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Helper method to format date
  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(date);
  }

  // Handle feedback submission
  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Implement feedback submission logic
      // await Provider.of<ComplaintService>(context, listen: false)
      //     .addFeedback(
      //   complaintId: widget.complaint.complaintId,
      //   feedback: _feedbackController.text,
      // );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully')),
      );
      _feedbackController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting feedback: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final complaint = widget.complaint;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Details'),
        actions: [
          // TODO: Add more actions like edit/delete if needed
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Complaint Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(complaint.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _getStatusColor(complaint.status),
                            ),
                          ),
                          child: Text(
                            complaint.status.toUpperCase(),
                            style: TextStyle(
                              color: _getStatusColor(complaint.status),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'ID: ${complaint.complaintId.substring(0, 8)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      complaint.category,
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(complaint.createdAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Complaint Image
            if (complaint.photoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  complaint.photoUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 48),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            // Complaint Details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(complaint.description),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      context,
                      icon: Icons.location_on,
                      label: 'Location',
                      value: complaint.address ?? 'Not specified',
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      icon: Icons.update,
                      label: 'Last Updated',
                      value: _formatDate(complaint.updatedAt),
                    ),
                  ],
                ),
              ),
            ),

            // TODO: Add progress updates section
            // if (complaint.progressImages?.isNotEmpty ?? false) ...[
            //   const SizedBox(height: 16),
            //   Card(
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Progress Updates',
            //             style: theme.textTheme.titleMedium,
            //           ),
            //           const SizedBox(height: 8),
            //           // TODO: Add progress images carousel
            //         ],
            //       ),
            //     ),
            //   ),
            // ],

            // Feedback Form
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Feedback',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _feedbackController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Enter your feedback or update...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your feedback';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitFeedback,
                          child: _isSubmitting
                              ? const CircularProgressIndicator()
                              : const Text('Submit Feedback'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}