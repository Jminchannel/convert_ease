import 'package:flutter/material.dart';
import '../providers/language_provider.dart';
import '../services/language_service.dart';
import '../generated/app_localizations.dart';
import '../widgets/animated_background.dart';

class SettingsScreen extends StatefulWidget {
  final LanguageProvider languageProvider;

  const SettingsScreen({super.key, required this.languageProvider});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        colors: isDark
            ? [
                Colors.deepPurple.shade800,
                Colors.indigo.shade700,
                Colors.blue.shade600,
              ]
            : [
                Colors.deepPurple.shade300,
                Colors.blue.shade200,
                Colors.cyan.shade100,
              ],
        child:
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark 
                    ? [
                        Colors.transparent,
                        theme.scaffoldBackgroundColor.withValues(alpha: 0.6),
                        theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                      ]
                    : [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.7),
                      ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        l10n.settings,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                          shadows: const [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildLanguageSection(context, l10n, theme, isDark),
                    // const SizedBox(height: 20),
                    // _buildThemeSection(context, l10n, theme, isDark),
                    const SizedBox(height: 20),
                    _buildAboutSection(context, l10n, theme, isDark),
                  ],
                ),
              ),
            ),
      ),
    )
    );
  }

  // Widget _buildThemeSection(BuildContext context, AppLocalizations l10n, ThemeData theme, bool isDark) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: isDark ? Colors.grey[800]!.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.3),
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(
  //         color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
  //         width: 1,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withValues(alpha: 0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, 5),
  //         ),
  //       ],
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(20.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(10),
  //                 decoration: BoxDecoration(
  //                   color: Colors.orange.withValues(alpha: 0.1),
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //                 child: const Icon(
  //                   Icons.palette,
  //                   color: Colors.orange,
  //                   size: 20,
  //                 ),
  //               ),
  //               const SizedBox(width: 12),
  //               Text(
  //                 'Theme',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: isDark ? Colors.white : Colors.black87,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 15),
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //             decoration: BoxDecoration(
  //               color: isDark ? Colors.grey[700]!.withValues(alpha: 0.3) : Colors.grey[100]!.withValues(alpha: 0.5),
  //               borderRadius: BorderRadius.circular(12),
  //               border: Border.all(
  //                 color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.3),
  //                 width: 1,
  //               ),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   isDark ? 'Dark Mode' : 'Light Mode',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: isDark ? Colors.white70 : Colors.black87,
  //                   ),
  //                 ),
  //                 Switch(
  //                   value: isDark,
  //                   onChanged: (value) {
  //                     // TODO: Implement theme switching
  //                     ScaffoldMessenger.of(context).showSnackBar(
  //                       const SnackBar(
  //                         content: Text('Theme switching coming soon!'),
  //                         duration: Duration(seconds: 2),
  //                       ),
  //                     );
  //                   },
  //                   activeColor: Colors.deepPurple,
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAboutSection(BuildContext context, AppLocalizations l10n, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800]!.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'About', // l10n.about,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildAboutItem('App Name', 'ConvertEase', Icons.apps, isDark), // l10n.appName
            _buildAboutItem('Version', '1.0.0', Icons.tag, isDark), // l10n.version
            _buildAboutItem('Build Number', '1', Icons.build, isDark), // l10n.buildNumber
            _buildAboutItem('Developer', 'ConvertEase Team', Icons.code, isDark), // l10n.developer
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700]!.withValues(alpha: 0.3) : Colors.grey[100]!.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'A powerful and beautiful unit conversion app\nsupporting multiple categories and languages.', // l10n.appDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white70 : Colors.black54,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutItem(String label, String value, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context, AppLocalizations l10n, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? theme.cardColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.language,
                color: Colors.deepPurple,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.language,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.brightness == Brightness.dark 
                      ? Colors.white 
                      : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.selectLanguage,
            style: TextStyle(
              fontSize: 14,
              color: theme.brightness == Brightness.dark 
                  ? Colors.white54 
                  : Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          ...LanguageService.supportedLocales.map((locale) => 
            _buildLanguageOption(context, l10n, theme, locale)),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, AppLocalizations l10n, ThemeData theme, Locale locale) {
    final isSelected = widget.languageProvider.currentLocale == locale;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? Colors.deepPurple 
              : theme.dividerColor.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected 
            ? Colors.deepPurple.withOpacity(0.05)
            : Colors.transparent,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(
          widget.languageProvider.getLanguageName(locale),
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected 
                ? Colors.deepPurple 
                : (theme.brightness == Brightness.dark 
                    ? Colors.white70 
                    : Colors.black87),
          ),
        ),
        trailing: isSelected 
            ? Icon(
                Icons.check_circle,
                color: Colors.deepPurple,
              )
            : null,
        onTap: () => _changeLanguage(context, l10n, locale),
      ),
    );
  }

  void _changeLanguage(BuildContext context, AppLocalizations l10n, Locale locale) {
    if (widget.languageProvider.currentLocale == locale) return;

    widget.languageProvider.changeLanguage(locale).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.languageChanged),
            backgroundColor: Colors.deepPurple,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }
}