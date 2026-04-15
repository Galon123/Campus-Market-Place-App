import 'package:e_commerce_refactor/providers/NotificationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => context.read<NotificationProvider>().clearAll(),
          )
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.notifications.isEmpty) {
            return const Center(child: Text("No notifications yet!"));
          }

          return ListView.separated(
            itemCount: provider.notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = provider.notifications[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getCategoryColor(item.type, colors),
                  child: Icon(_getCategoryIcon(item.type), color: Colors.white),
                ),
                title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.message),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(item.timeStamp), 
                      style: const TextStyle(fontSize: 10, color: Colors.grey)
                    ),
                  ],
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }

  IconData _getCategoryIcon(String type) {
    switch (type) {
      case 'Item_Created': return Icons.add;
      case 'Item_Updated': return Icons.update;
      case 'Item_Deleted' : return Icons.delete;
      case 'Bid_Created': return Icons.add;
      case 'Bid_Updated': return Icons.update;
      case 'Bid_Deleted' : return Icons.delete;
      case 'Bid_Accepted' : return Icons.check;
      case 'Bid_Rejected' : return Icons.close;
      case 'Rating_Pending' : return Icons.star;
      case 'Rating_Recieved' : return Icons.stars;
      case 'Reported_Successfully' : return Icons.report;
      default: return Icons.notifications;
    }
  }

  Color _getCategoryColor(String type, ColorScheme colors) {
    return type == 'BID' ? colors.primary : colors.secondary;
  }

  String _formatTimestamp(DateTime dt) {
    // You can use the 'intl' package here, but for now:
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}