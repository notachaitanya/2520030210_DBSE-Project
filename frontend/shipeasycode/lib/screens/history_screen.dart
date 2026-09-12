import 'package:flutter/material.dart';
import 'home_screen.dart' show allShipments, statusBadge;
import 'track_shipment_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'all';

  final _filters = const ['all', 'delivered', 'in_transit', 'booked', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == 'all'
        ? allShipments
        : allShipments.where((s) => s['status'] == _filter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Shipment History')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: _filter,
              items: _filters
                  .map((f) => DropdownMenuItem(value: f, child: Text(f.replaceAll('_', ' '))))
                  .toList(),
              onChanged: (value) => setState(() => _filter = value!),
            ),
            const Divider(),
            Expanded(
              child: filtered.isEmpty
                  ? const Text('No shipments in this category.')
                  : ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, i) {
                        final s = filtered[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TrackShipmentScreen(shipment: s)),
                          ),
                          title: Text('#${s['id']}  ${s['origin']} -> ${s['destination']}'),
                          subtitle: Text('${s['date']}  Rs.${s['cost'].toStringAsFixed(2)}'),
                          trailing: statusBadge(s['status']),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
