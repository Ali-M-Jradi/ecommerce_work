import 'package:flutter/material.dart';
import 'package:ecommerce/pages/contact_us_page.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner image/logo
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/three_leaves.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'About Our Store',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'We are passionate about providing the best beauty and self-care products. Our mission is to offer high-quality, affordable, and trusted brands to our customers. Thank you for choosing us for your beauty needs!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 32),
              Divider(height: 1, thickness: 1, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 32),
              Text(
                'Our Mission',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                'To empower our customers to look and feel their best by providing top-quality, affordable beauty and self-care products.',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 28),
              Text(
                'Our Vision',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 12),
              const Text(
                'To be the most trusted and loved destination for beauty and wellness in our community.',
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.contact_mail, color: Theme.of(context).colorScheme.onPrimary),
                  label: Text('Contact Us', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ContactUsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
