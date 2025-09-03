import 'package:flutter/material.dart';

import '../generated/app_localizations.dart';
import '../models/category_model.dart';
import '../widgets/animated_background.dart';
import 'conversion_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _showAllCategories = false;
  late ScrollController _scrollController;
  late AnimationController _titleAnimationController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _titleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _titleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final displayedCategories = _showAllCategories
        ? categories
        : categories.sublist(0, 6);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedBackground(
        colors: isDark 
            ? [
                theme.scaffoldBackgroundColor,
                theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
              ]
            : [
                Colors.deepPurple,
                Colors.deepPurple.shade300,
                Colors.blue.shade200,
              ],
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedBuilder(
                animation: _scrollController.hasClients ? _scrollController : _titleAnimationController,
                builder: (context, child) {
                  // Calculate opacity and scale based on scroll offset
                  final opacity = (1.0 - (_scrollOffset / 100.0)).clamp(0.0, 1.0);
                  final scale = (0.8 + (opacity * 0.4)).clamp(0.8, 1.2);
                  
                  return AnimatedOpacity(
                    opacity: opacity,
                    duration: const Duration(milliseconds: 150),
                    child: Transform.scale(
                      scale: scale,
                      child: Text(
                        l10n!.appTitle,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17 + (scale - 0.8) * 10, // Font size changes with scale
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 2),
                              blurRadius: 4 * scale,
                              color: Colors.black45,
                            ),
                            Shadow(
                              offset: const Offset(0, 0),
                              blurRadius: 8 * scale,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              titlePadding: const EdgeInsetsDirectional.only(start: 16, bottom: 16),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      bottom: 20,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 50,
                      child: AnimatedBuilder(
                        animation: _scrollController.hasClients ? _scrollController : _titleAnimationController,
                        builder: (context, child) {
                          final opacity = (1.0 - (_scrollOffset / 80.0)).clamp(0.0, 1.0);
                          final translateY = _scrollOffset * 0.2;
                          
                          return AnimatedOpacity(
                            opacity: opacity,
                            duration: const Duration(milliseconds: 150),
                            child: Transform.translate(
                              offset: Offset(0, translateY),
                              child: Text(
                                l10n!.selectCategory,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.crossAxisExtent > 600 
                    ? (constraints.crossAxisExtent / 220).floor().clamp(2, 4)
                    : 2;
                
                return SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index == displayedCategories.length) {
                        return _buildViewMoreButton();
                      }
                      return _buildCategoryCard(displayedCategories[index]);
                    },
                    childCount: displayedCategories.length + 1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildCategoryCard(Category category) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: category.color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () => _navigateToConversionScreen(category),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  category.color.withOpacity(isDark ? 0.9 : 0.8),
                  category.color.withOpacity(isDark ? 0.7 : 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      category.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  flex: 2,
                  child:                       Text(
                        category.getLocalizedName(AppLocalizations.of(context)!),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${category.units.length} ${AppLocalizations.of(context)!.units}',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewMoreButton() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            setState(() {
              _showAllCategories = !_showAllCategories;
            });
          },
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  isDark 
                      ? theme.cardColor 
                      : Colors.white,
                  isDark 
                      ? theme.cardColor.withOpacity(0.8) 
                      : Colors.grey[50]!,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.deepPurple.withOpacity(0.3),
                width: 2,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: AnimatedRotation(
                    turns: _showAllCategories ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.expand_more,
                      size: 24,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    _showAllCategories ? AppLocalizations.of(context)!.showLess : AppLocalizations.of(context)!.showMore,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.textTheme.titleMedium?.color,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _showAllCategories
                          ? AppLocalizations.of(context)!.hiding(categories.length - 6)
                          : AppLocalizations.of(context)!.moreCategories(categories.length - 6),
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToConversionScreen(Category category) {
    // 这里跳转到具体的换算页面
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConversionScreen(category: category),
    ));

    // 暂时用SnackBar演示
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Selected: ${category.name}'),
    //     duration: const Duration(milliseconds: 500),
    //   ),
    // );
  }
}