import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: Colors.black,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PC Part Picker',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Build your dream PC with our easy-to-use platform.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 2.0,
                      children: [
                        _socialButton(Icons.facebook,
                            () => _launchUrl('https://facebook.com')),
                        _socialButton(Icons.signal_cellular_alt,
                            () => _launchUrl('https://twitter.com')),
                        _socialButton(Icons.camera_alt,
                            () => _launchUrl('https://instagram.com')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Components',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _footerLink('Home', () => context.go('/')),
                    _footerLink('Contact Us', () => context.go('/about')),
                    _footerLink('Processors', () => context.go('/processors')),
                    _footerLink('Graphics Cards', () => context.go('/gpu')),
                    _footerLink(
                        'Motherboards', () => context.go('/motherboard')),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 18,
                    ),
                    const SizedBox(height: 10),
                    _footerLink('Memory', () => context.go('/memory')),
                    _footerLink('Storage', () => context.go('/storage')),
                    _footerLink('Cases', () => context.go('/cases')),
                    _footerLink('Power Supplies', () => context.go('/psu')),
                    _footerLink('Final Build', () => context.go('/final')),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey, height: 20),
          const Text(
            '© 2023 PC Part Picker. All rights reserved.',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: const Color(0xFF2FA44D),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _footerLink(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
