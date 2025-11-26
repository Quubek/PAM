import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/champion_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  final String patchVersion = "13.24.1";
  final String appVersion = "1.0.0";
  final String appAuthor = "Twój Nick/Imię";

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChampionViewModel>();
    final isDark = vm.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, "WYGLĄD"),
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(isDark ? Icons.nightlight_round : Icons.wb_sunny, color: Colors.deepPurple),
              title: const Text('Tryb Ciemny'),
              subtitle: Text(isDark ? 'Włączony' : 'Wyłączony'),
              trailing: Switch(
                value: isDark,
                activeColor: Colors.deepPurple,
                onChanged: (val) => vm.toggleTheme(val),
              ),
            ),
          ),

          const SizedBox(height: 30),

          _buildSectionHeader(context, "O PROJEKCIE"),
          Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.code, color: Colors.blue),
                  title: const Text('Wersja Patcha (Dane API)'),
                  trailing: Text(patchVersion, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.orange),
                  title: const Text('Wersja Aplikacji'),
                  trailing: Text(appVersion, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: const Text('Autor'),
                  trailing: Text('Jakub Filus', style: const TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Projekt na zaliczenie - Jakub Filus')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          const Center(
            child: Text(
              'Projekt wykonany we Flutterze.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}