import 'package:flutter/material.dart';
import 'home_screen.dart' show statusBadge;

class TrackShipmentScreen extends StatelessWidget {
  final Map<String, dynamic> shipment;
  const TrackShipmentScreen({super.key, required this.shipment});

  bool get _canCancel => shipment['status'] == 'booked';

  @override
  Widget build(BuildContext context) {
    final List timeline = shipment['timeline'];

    return Scaffold(
      appBar: AppBar(title: Text('Shipment #${shipment['id']}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text('${shipment['origin']} -> ${shipment['destination']}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            statusBadge(shipment['status']),
            const SizedBox(height: 8),
            Text('Carrier: ${shipment['carrier']}'),
            Text('${shipment['weight']} kg  Rs.${shipment['cost'].toStringAsFixed(2)}'),
            const SizedBox(height: 20),
            const Text('Tracking Timeline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            ...List.generate(timeline.length, (i) {
              final event = timeline[i];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text('${i + 1}.'),
                title: Text(event['status']),
                subtitle: Text('${event['location']} - ${event['time']}'),
              );
            }),
            const SizedBox(height: 12),
            if (_canCancel)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Shipment cancelled.')),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel Shipment'),
                ),
              )
            else if (shipment['status'] != 'cancelled' && shipment['status'] != 'delivered')
              const Text('This shipment has already been picked up and cannot be cancelled.'),
          ],
        ),
      ),
    );
  }
}
