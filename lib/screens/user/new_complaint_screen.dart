import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import 'package:swachh_bharat_app/models/complaint.dart';
import 'package:swachh_bharat_app/services/auth_service.dart';
import 'package:swachh_bharat_app/services/complaint_service.dart';
import 'package:swachh_bharat_app/services/location_service.dart';
import 'package:swachh_bharat_app/widgets/custom_button.dart';
import 'package:swachh_bharat_app/widgets/custom_textfield.dart';

class NewComplaintScreen extends StatefulWidget {
  final String? initialCategory;

  const NewComplaintScreen({super.key, this.initialCategory});

  @override
  State<NewComplaintScreen> createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends State<NewComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final List<String> _categories = [
    'Garbage Dump',
    'Water Logging',
    'Road Damage',
    'Public Parks',
    'Drainage Issues',
    'Street Lights',
    'Illegal Construction',
    'Others',
  ];

  String? _selectedCategory;
  File? _imageFile;
  Position? _currentPosition;
  String? _address;
  bool _isLoading = false;
  bool _isLocationLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocationLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await LocationService.determinePosition();
      final placemarks = await LocationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentPosition = position;
        _address = placemarks.isNotEmpty
            ? '${placemarks.first.street}, ${placemarks.first.locality}'
            : '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error getting location: $e';
      });
    } finally {
      setState(() {
        _isLocationLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitComplaint() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      setState(() {
        _errorMessage = 'Please select a category';
      });
      return;
    }
    if (_currentPosition == null) {
      setState(() {
        _errorMessage = 'Could not determine your location. Please try again.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final complaintService = Provider.of<ComplaintService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = authService.currentUser;
      
      if (user == null) {
        throw Exception('User not logged in');
      }

      await complaintService.createComplaint(
        userId: user.uid,
        category: _selectedCategory!,
        description: _descriptionController.text.trim(),
        imageFile: _imageFile,
        position: _currentPosition!,
      );

      if (mounted) {
        Navigator.pop(context, true); // Return success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complaint submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error submitting complaint: $e';
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
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report an Issue'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Error message
                    if (_errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
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

                    // Category dropdown
                    Text(
                      'Category *',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      hint: const Text('Select a category'),
                      items: _categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Description *',
                      hint: 'Describe the issue in detail...',
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a description';
                        }
                        if (value.trim().length < 10) {
                          return 'Description should be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Image picker
                    Text(
                      'Add Photo (Optional)',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    if (_imageFile != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _imageFile!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              TextButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(Icons.edit),
                                label: const Text('Change'),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _imageFile = null;
                                  });
                                },
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                label: const Text('Remove', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _takePhoto,
                              icon: const Icon(Icons.camera_alt_outlined),
                              label: const Text('Take Photo'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _pickImage,
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Choose from Gallery'),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),

                    // Location
                    Text(
                      'Location',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _isLocationLoading
                                      ? const Text('Getting your location...')
                                      : Text(
                                          _address ?? 'Location not available',
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                ),
                                IconButton(
                                  onPressed: _isLocationLoading ? null : _getCurrentLocation,
                                  icon: const Icon(Icons.refresh),
                                  tooltip: 'Refresh location',
                                ),
                              ],
                            ),
                            if (_currentPosition != null) ...{
                              const SizedBox(height: 8),
                              Text(
                                'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                                style: theme.textTheme.bodySmall,
                              ),
                            },
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Submit button
                    CustomButton(
                      onPressed: _submitComplaint,
                      child: const Text('Submit Complaint'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}
