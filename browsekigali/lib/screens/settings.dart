import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state_management.dart/auth_provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static const _prefsKeyNotifications = 'location_notifications_enabled';
  bool _locationNotificationsEnabled = true;
  bool _loadingPrefs = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _locationNotificationsEnabled =
            prefs.getBool(_prefsKeyNotifications) ?? true;
      });
    } catch (_) {
      // If preferences cannot be loaded (rare), just continue with defaults.
    } finally {
      if (mounted) {
        setState(() {
          _loadingPrefs = false;
        });
      }
    }
  }

  Future<void> _toggleLocationNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKeyNotifications, value);
    setState(() {
      _locationNotificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: _loadingPrefs
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Profile', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                if (user == null) ...[
                  const Card(
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Not signed in'),
                      subtitle: Text('Please sign in to view profile info'),
                    ),
                  ),
                ] else ...[
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Name'),
                      subtitle: Text(user.name ?? '—'),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(user.email),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Joined'),
                      subtitle: Text(
                        user.createdAt.toDate().toLocal().toString(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Log out'),
                      onTap: () async {
                        await auth.logout();
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Card(
                  child: SwitchListTile(
                    title: const Text('Location-based notifications'),
                    subtitle: const Text(
                      'Simulate enabling/disabling location notifications',
                    ),
                    value: _locationNotificationsEnabled,
                    onChanged: (value) => _toggleLocationNotifications(value),
                  ),
                ),
              ],
            ),
    );
  }
}
