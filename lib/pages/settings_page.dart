import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:am_i_cooked/service/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isDarkMode;

  final Dio _dio = Dio();
  late final AuthService _authService = AuthService(_dio);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    isDarkMode =
        AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHigh,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Paramètres',
          style: TextStyle(
            fontFamily: 'bbh_sans_hegarty',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.dark_mode_outlined,
                    color: cs.onSurface,
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      'Mode sombre',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ),

                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });

                      if (value) {
                        AdaptiveTheme.of(context).setDark();
                      } else {
                        AdaptiveTheme.of(context).setLight();
                      }
                    },
                  ),
                ],
              ),

              Divider(
                height: 36,
                color: cs.outlineVariant,
              ),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.person_outline,
                  color: cs.onSurface,
                ),
                title: Text(
                  'Compte',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: cs.onSurfaceVariant,
                ),
                onTap: () {},
              ),

              const Spacer(),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'Déconnexion',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.red,
                  ),
                ),
                onTap: () async {
                  await _authService.logout();

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}