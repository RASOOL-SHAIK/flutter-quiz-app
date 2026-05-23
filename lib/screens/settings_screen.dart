import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/sound_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _soundEnabled = SoundService.isEnabled;
  }

  void _toggleSound(bool val) {
    setState(() => _soundEnabled = val);
    SoundService.setEnabled(val);
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text(
            'We do not collect any personal data. Your scores are stored locally.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('OK'))
        ],
      ),
    );
  }

  Future<void> _launchTerms() async {
    const url = 'https://example.com/terms';
    if (await canLaunchUrl(Uri.parse(url))) await launchUrl(Uri.parse(url));
  }

  void _rateApp() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Rate our app!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Sound Effects'),
            value: _soundEnabled,
            onChanged: _toggleSound,
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: _showPrivacyDialog,
          ),
          ListTile(
            title: const Text('Terms & Conditions'),
            onTap: _launchTerms,
          ),
          ListTile(
            title: const Text('Rate App'),
            onTap: _rateApp,
          ),
        ],
      ),
    );
  }
}
