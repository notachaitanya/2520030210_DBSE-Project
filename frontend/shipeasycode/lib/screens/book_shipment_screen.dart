import 'package:flutter/material.dart';

class BookShipmentScreen extends StatefulWidget {
  const BookShipmentScreen({super.key});
  @override
  State<BookShipmentScreen> createState() => _BookShipmentScreenState();
}

class _BookShipmentScreenState extends State<BookShipmentScreen> {
  final _originController = TextEditingController();
  final _destController = TextEditingController();
  final _weightController = TextEditingController();
  double? _estimatedCost;

  void _calculateCost() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final sameCity = _originController.text.trim().toLowerCase() ==
            _destController.text.trim().toLowerCase() &&
        _originController.text.isNotEmpty;
    final rate = sameCity ? 8.0 : 15.0;
    setState(() => _estimatedCost = 50 + (weight * rate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Shipment')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: _originController,
              decoration: const InputDecoration(labelText: 'Pickup City', border: OutlineInputBorder()),
              onChanged: (_) => _calculateCost(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _destController,
              decoration: const InputDecoration(labelText: 'Drop City', border: OutlineInputBorder()),
              onChanged: (_) => _calculateCost(),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Package Weight (kg)', border: OutlineInputBorder()),
              onChanged: (_) => _calculateCost(),
            ),
            const SizedBox(height: 20),
            if (_estimatedCost != null)
              Text(
                'Estimated Cost: Rs.${_estimatedCost!.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Shipment booked. Carrier assigned automatically.')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Confirm Booking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
