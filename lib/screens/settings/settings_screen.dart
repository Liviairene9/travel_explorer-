import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/section_title.dart';

/// Écran Paramètres : bascule entre thème clair, sombre et système.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SectionTitle(title: 'Apparence', icon: Icons.palette_outlined),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Clair'),
                  secondary: const Icon(Icons.light_mode_outlined),
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (mode) =>
                      ref.read(themeModeProvider.notifier).setMode(mode!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Sombre'),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (mode) =>
                      ref.read(themeModeProvider.notifier).setMode(mode!),
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('Système'),
                  secondary: const Icon(Icons.settings_suggest_outlined),
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (mode) =>
                      ref.read(themeModeProvider.notifier).setMode(mode!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionTitle(title: 'À propos', icon: Icons.info_outline_rounded),
          const Card(
            child: ListTile(
              leading: Icon(Icons.travel_explore_rounded),
              title: Text('Travel Explorer'),
              subtitle: Text('Version 1.0.0 — Projet Flutter multi-écrans'),
            ),
          ),
        ],
      ),
    );
  }
}
