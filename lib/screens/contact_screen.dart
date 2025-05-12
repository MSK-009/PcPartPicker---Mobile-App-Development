import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pc_part_picker/widgets/app_bar.dart';
import 'package:pc_part_picker/widgets/footer_widget.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real app, send the form data to a backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Message sent successfully!'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch URL'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Contact Us'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    const Color(0xFF1C7C30),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Get In Touch',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Have questions about PC parts or need help with your build? We\'re here to help!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Contact information and form
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Information
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildContactItem(
                          Icons.location_on,
                          'Address',
                          '123 PC Street, New York, NY 10001',
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          Icons.phone,
                          'Phone',
                          '+1 (555) 123-4567',
                          () => _launchUrl('tel:+15551234567'),
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          Icons.email,
                          'Email',
                          'contact@pcpartpicker.com',
                          () => _launchUrl('mailto:contact@pcpartpicker.com'),
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          Icons.access_time,
                          'Hours',
                          'Monday - Friday: 9am - 5pm EST',
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Follow Us',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildSocialButton(
                              Icons.facebook,
                              Colors.blue,
                              () => _launchUrl('https://facebook.com'),
                            ),
                            const SizedBox(width: 16),
                            _buildSocialButton(
                              Icons.alternate_email,
                              Colors.blue.shade700,
                              () => _launchUrl('https://twitter.com'),
                            ),
                            const SizedBox(width: 16),
                            _buildSocialButton(
                              Icons.camera_alt,
                              Colors.pink.shade400,
                              () => _launchUrl('https://instagram.com'),
                            ),
                            const SizedBox(width: 16),
                            _buildSocialButton(
                              Icons.video_call,
                              Colors.red,
                              () => _launchUrl('https://youtube.com'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 40),

                  // Contact Form
                  Expanded(
                    flex: 3,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Send us a Message',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Name field
                                  TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Your Name',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.person),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Email field
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Your Email',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Subject field
                                  TextFormField(
                                    controller: _subjectController,
                                    decoration: const InputDecoration(
                                      labelText: 'Subject',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.subject),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a subject';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Message field
                                  TextFormField(
                                    controller: _messageController,
                                    decoration: const InputDecoration(
                                      labelText: 'Message',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.message),
                                      alignLabelWithHint: true,
                                    ),
                                    maxLines: 5,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your message';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24),

                                  // Submit button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.send),
                                      label: const Text('Send Message'),
                                      onPressed: _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                      ),
                                    ),
                                  ),
                                ],
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

            // Map or image section
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey.shade200,
              child: Center(
                child: Icon(
                  Icons.map,
                  size: 100,
                  color: Colors.grey.shade400,
                ),
              ),
            ),

            // Footer
            const FooterWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    IconData icon,
    String title,
    String content, [
    VoidCallback? onTap,
  ]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: onTap,
                child: Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: onTap != null ? Colors.blue : null,
                    decoration: onTap != null ? TextDecoration.underline : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
} 