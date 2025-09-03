import 'package:flutter/material.dart';
import '../models/conversion_history.dart';
import '../services/history_service.dart';
import '../widgets/animated_background.dart';
import '../generated/app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<ConversionHistory> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final history = await HistoryService.getHistory();
      setState(() {
        _history = history;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.failedToLoadHistory}: $e')),
        );
      }
    }
  }

  Future<void> _deleteHistory(String id) async {
    await HistoryService.deleteHistory(id);
    _loadHistory(); // 重新加载列表
  }

  Future<void> _clearAllHistory() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAllHistory),
        content: Text(l10n.clearAllHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await HistoryService.clearAllHistory();
      _loadHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
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
        child: Container(
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.conversionHistory,
                          style: TextStyle(
                            fontSize: 28,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_history.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete_sweep, color: Colors.red),
                            onPressed: _clearAllHistory,
                            tooltip: AppLocalizations.of(context)!.clearAll,
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _history.isEmpty
                          ? _buildEmptyState()
                          : RefreshIndicator(
                              onRefresh: _loadHistory,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: _history.length,
                                itemBuilder: (context, index) {
                                  return _buildHistoryCard(_history[index]);
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
        ),
    )
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noConversionHistory,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.historyWillAppearHere,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(ConversionHistory history) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(history.category),
          child: Text(
            _getCategoryIcon(history.category),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          history.conversionDescription,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppLocalizations.of(context)!.category}: ${history.category}'),
            Text('${AppLocalizations.of(context)!.time}: ${history.formattedTime}'),
            if (history.updateTime != null)
              Text(
                history.updateTime!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteHistory(history.id),
          tooltip: AppLocalizations.of(context)!.delete,
        ),
        isThreeLine: true,
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'length':
        return Colors.blue;
      case 'area':
        return Colors.green;
      case 'volume':
        return Colors.orange;
      case 'weight':
        return Colors.red;
      case 'temperature':
        return Colors.purple;
      case 'storage':
        return Colors.teal;
      case 'time':
        return Colors.indigo;
      case 'speed':
        return Colors.cyan;
      case 'currency':
        return Colors.amber;
      case 'color':
        return Colors.pink;
      case 'energy':
        return Colors.deepOrange;
      case 'pressure':
        return Colors.brown;
      case 'angle':
        return Colors.lightGreen;
      default:
        return Colors.grey;
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'length':
        return '📏';
      case 'area':
        return '📐';
      case 'volume':
        return '🧪';
      case 'weight':
        return '⚖️';
      case 'temperature':
        return '🌡️';
      case 'storage':
        return '💾';
      case 'time':
        return '⏰';
      case 'speed':
        return '🚀';
      case 'currency':
        return '💰';
      case 'color':
        return '🎨';
      case 'energy':
        return '⚡';
      case 'pressure':
        return '💨';
      case 'angle':
        return '🧭';
      default:
        return '📊';
    }
  }
}
