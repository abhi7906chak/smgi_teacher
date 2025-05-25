// utils/social_links.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinksScreen extends StatelessWidget {
  final String facebookUrl;
  final String instagramUrl;
  final String linkedinUrl;
  final String githubUrl;

  const SocialLinksScreen({
    super.key,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.linkedinUrl,
    required this.githubUrl,
  });

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Social Links"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              title: "Facebook",
              icon: Icons.facebook,
              color: Colors.blue.shade800,
              onTap: () => _launchURL(facebookUrl),
            ),
            _buildCard(
              title: "Instagram",
              icon: Icons.camera_alt,
              color: Colors.pink.shade400,
              onTap: () => _launchURL(instagramUrl),
            ),
            _buildCard(
              title: "LinkedIn",
              icon: Icons.business,
              color: Colors.blue.shade700,
              onTap: () => _launchURL(linkedinUrl),
            ),
            _buildCard(
              title: "GitHub",
              icon: Icons.code,
              color: Colors.black87,
              onTap: () => _launchURL(githubUrl),
            ),
          ],
        ),
      ),
    );
  }
}
