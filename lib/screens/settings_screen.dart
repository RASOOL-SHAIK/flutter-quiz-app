import 'package:flutter/material.dart';
import '../constants.dart';
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
    setState(() {
      _soundEnabled = val;
    });
    SoundService.setEnabled(val);
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppConstants.privacyPolicy),
        content: Text(AppConstants.privacyPolicyText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Temporarily removed Terms & Conditions (needs url_launcher)
  // You can add it back later after fixing the package.

  void _rateApp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rate our app!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.settingsTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(AppConstants.soundEffects),
            value: _soundEnabled,
            onChanged: _toggleSound,
            activeColor: theme.primaryColor,
          ),
          ListTile(
            title: Text(AppConstants.privacyPolicy),
            onTap: _showPrivacyDialog,
          ),
          // Terms & Conditions button removed temporarily
          ListTile(
            title: Text(AppConstants.rateApp),
            onTap: _rateApp,
          ),
        ],
      ),
    );
  }
}
