
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import 'services/firebase_service.dart';
import 'models.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  DriverScreenState createState() => DriverScreenState();
}

class DriverScreenState extends State<DriverScreen> {
  Timer? _positionUpdateTimer;
  Ligne? _assignedLigne;
  // Simulate the bus position
  int _currentRouteIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Simulate assigning a line to the driver
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    firebaseService.getLignesStream().first.then((lignes) {
      if (lignes.isNotEmpty) {
        setState(() {
          _assignedLigne = lignes.first;
        });
        _startSendingPosition();
      }
    });
  }

  void _startSendingPosition() {
    final firebaseService = Provider.of<FirebaseService>(context, listen: false);
    const busId = 'bus-001'; // In a real app, this would be the driver's bus

    _positionUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_assignedLigne != null && _assignedLigne!.routePoints.isNotEmpty) {
        final position = _assignedLigne!.routePoints[_currentRouteIndex];
        firebaseService.updateBusPosition(busId, position);

        setState(() {
          _currentRouteIndex = (_currentRouteIndex + 1) % _assignedLigne!.routePoints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _positionUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tableau de Bord Conducteur')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_assignedLigne != null)
              Text('Ligne assignée: ${_assignedLigne!.numero}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Position en cours d\'envoi...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
