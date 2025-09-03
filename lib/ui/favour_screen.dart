import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../generated/app_localizations.dart';

class FavourScreen extends StatelessWidget {
  const FavourScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark 
                ? [
                    Colors.transparent,
                    theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                    theme.scaffoldBackgroundColor,
                  ]
                : [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.3),
                    Colors.white.withValues(alpha: 0.9),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                child: Text(
                  'Favorites', // AppLocalizations.of(context)!.favorites,
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
              Expanded(
                child: Center(
                  child: Text(
                    'Favorites feature coming soon!', // AppLocalizations.of(context)!.favoritesComingSoon,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
