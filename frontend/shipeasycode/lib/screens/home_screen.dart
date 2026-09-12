import 'package:flutter/material.dart';
import 'book_shipment_screen.dart';
import 'track_shipment_screen.dart';
import 'history_screen.dart';

// Each shipment is just a plain Map here -- no separate model class,
// no separate widget file. Keeps everything in one place per screen.
final List<Map<String, dynamic>> allShipments = [
  {
    'id': 1042,
    'origin': 'Hyderabad',
    'destination': 'Bangalore',
    'weight': 4.5,
    'status': 'in_transit',
    'cost': 117.50,
    'date': '28 Aug 2026',
    'carrier': 'Swift Freight 12',
    'timeline': [
      {'status': 'Booked', 'location': 'Hyderabad Hub', 'time': '28 Aug, 9:10 AM'},
      {'status': 'Picked Up', 'location': 'Hyderabad Hub', 'time': '28 Aug, 1:40 PM'},
      {'status': 'In Transit', 'location': 'Kurnool Hub', 'time': '29 Aug, 6:05 AM'},
    ],
  },
  {
    'id': 1041,
    'origin': 'Hyderabad',
    'destination': 'Chennai',
    'weight': 12.0,
    'status': 'delivered',
    'cost': 230.00,
    'date': '25 Aug 2026',
    'carrier': 'BlueLine Logistics 7',
    'timeline': [
      {'status': 'Booked', 'location': 'Hyderabad Hub', 'time': '25 Aug, 8:00 AM'},
      {'status': 'Picked Up', 'location': 'Hyderabad Hub', 'time': '25 Aug, 11:30 AM'},
      {'status': 'In Transit', 'location': 'Nellore Hub', 'time': '26 Aug, 3:15 AM'},
      {'status': 'Out for Delivery', 'location': 'Chennai Hub', 'time': '26 Aug, 9:40 AM'},
      {'status': 'Delivered', 'location': 'Chennai', 'time': '26 Aug, 1:20 PM'},
    ],
  },
  {
    'id': 1040,
    'origin': 'Hyderabad',
    'destination': 'Vijayawada',
    'weight': 2.2,
    'status': 'booked',
    'cost': 74.60,
    'date': '30 Aug 2026',
    'carrier': 'Rapid Cargo 3',
    'timeline': [
      {'status': 'Booked', 'location': 'Hyderabad Hub', 'time': '30 Aug, 10:05 AM'},
    ],
  },
  {
    'id': 1039,
    'origin': 'Hyderabad',
    'destination': 'Warangal',
    'weight': 8.0,
    'status': 'cancelled',
    'cost': 94.00,
    'date': '22 Aug 2026',
    'carrier': '-',
    'timeline': [
      {'status': 'Booked', 'location': 'Hyderabad Hub', 'time': '22 Aug, 9:00 AM'},
      {'status': 'Cancelled', 'location': 'Hyderabad Hub', 'time': '22 Aug, 9:45 AM'},
    ],
  },
];

// Plain text label instead of a colored pill badge.
Widget statusBadge(String status) {
  return Text(
    status.replaceAll('_', ' ').toUpperCase(),
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activeShipments =
        allShipments.where((s) => s['status'] != 'delivered' && s['status'] != 'cancelled').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShipEasy'),
        actions: [
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
            child: const Text('History'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Fresh Mart Grocery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('2 active shipments this month'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookShipmentScreen()),
                ),
                child: const Text('Book a New Shipment'),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Active Shipments', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            Expanded(
              child: activeShipments.isEmpty
                  ? const Text('No active shipments right now.')
                  : ListView.builder(
                      itemCount: activeShipments.length,
                      itemBuilder: (context, i) {
                        final s = activeShipments[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TrackShipmentScreen(shipment: s)),
                          ),
                          title: Text('#${s['id']}  ${s['origin']} -> ${s['destination']}'),
                          subtitle: Text('${s['weight']} kg  Rs.${s['cost'].toStringAsFixed(2)}  ${s['date']}'),
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
