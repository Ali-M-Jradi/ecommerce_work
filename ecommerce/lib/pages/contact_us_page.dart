import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'contact@yourstore.com',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  void _launchPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+12345678900',
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.support_agent, size: 64, color: Colors.deepPurple),
            ),
            const SizedBox(height: 24),
            Text(
              'We would love to hear from you!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'For any questions, feedback, or support, please reach out to us using the information below:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: _launchEmail,
                      child: const Row(
                        children: [
                          Icon(Icons.email, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text('contact@yourstore.com', style: TextStyle(decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _launchPhone,
                      child: const Row(
                        children: [
                          Icon(Icons.phone, color: Colors.deepPurple),
                          SizedBox(width: 8),
                          Text('+1 234 567 8900', style: TextStyle(decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'Follow us on social media',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.deepPurple),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.facebook, color: Colors.blue, size: 32),
                  SizedBox(width: 16),
                  Icon(Icons.camera_alt, color: Colors.purple, size: 32), // Instagram placeholder
                  SizedBox(width: 16),
                  Icon(Icons.alternate_email, color: Colors.lightBlue, size: 32), // Twitter placeholder
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
