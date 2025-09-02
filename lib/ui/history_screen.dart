import 'package:flutter/material.dart';
import '../models/conversion_history.dart';
import '../services/history_service.dart';

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
          SnackBar(content: Text('Failed to load history: $e')),
        );
      }
    }
  }

  Future<void> _deleteHistory(String id) async {
    await HistoryService.deleteHistory(id);
    _loadHistory(); // 重新加载列表
  }

  Future<void> _clearAllHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History'),
        content: const Text('Are you sure you want to delete all conversion history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear All'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversion History'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearAllHistory,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: _isLoading
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
            'No Conversion History',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your conversion history will appear here',
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
            Text('Category: ${history.category}'),
            Text('Time: ${history.formattedTime}'),
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
          tooltip: 'Delete',
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
