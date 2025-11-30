
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'models.dart';

// --- Stream Controller for Real-Time Bus Movement ---
final _busPositionController = StreamController<List<PositionBus>>.broadcast();
Stream<List<PositionBus>> get busPositionStream => _busPositionController.stream;

class MockData {
  // --- Route Polylines ---
  static final List<LatLng> _routeLine4 = [
    const LatLng(14.764, -17.436), // Terme Nord
    const LatLng(14.759, -17.442),
    const LatLng(14.755, -17.448),
    const LatLng(14.748, -17.453),
    const LatLng(14.739, -17.459), // Liberté 6
  ];

  static final List<LatLng> _routeLine7 = [
    const LatLng(14.739, -17.459), // Liberté 6
    const LatLng(14.731, -17.465),
    const LatLng(14.722, -17.472),
    const LatLng(14.715, -17.480), // Parcelles Assainies
  ];

  static final List<LatLng> _routeLine9 = [
    const LatLng(14.694, -17.466), // UCAD
    const LatLng(14.699, -17.460),
    const LatLng(14.705, -17.455),
    const LatLng(14.708, -17.448), // Gare Pompiers
  ];

  static final List<LatLng> _routeLine15 = [
    const LatLng(14.735, -17.500), // Yoff
    const LatLng(14.725, -17.490),
    const LatLng(14.710, -17.475),
    const LatLng(14.685, -17.445), // Plateau
  ];

  // --- Core Data ---
  static final List<Ligne> lignes = [
    Ligne(idLigne: 'ligne_4', numero: '4', depart: 'Terme Nord', destination: 'Liberté 6', frequence: '10-15 min', color: Colors.orange, routePoints: _routeLine4),
    Ligne(idLigne: 'ligne_7', numero: '7', depart: 'Liberté 6', destination: 'Parcelles', frequence: '8-12 min', color: Colors.red, routePoints: _routeLine7),
    Ligne(idLigne: 'ligne_9', numero: '9', depart: 'UCAD', destination: 'Gare Pompiers', frequence: '15-20 min', color: Colors.green, routePoints: _routeLine9),
    Ligne(idLigne: 'ligne_15', numero: '15', depart: 'Yoff', destination: 'Plateau', frequence: '12-18 min', color: Colors.blue, routePoints: _routeLine15),
  ];

  static List<PositionBus> busPositions = [
    PositionBus(idBus: 'bus_101', position: _routeLine4[0], idLigne: 'ligne_4'),
    PositionBus(idBus: 'bus_102', position: _routeLine7[0], idLigne: 'ligne_7'),
    PositionBus(idBus: 'bus_103', position: _routeLine9[0], idLigne: 'ligne_9'),
    PositionBus(idBus: 'bus_104', position: _routeLine15[0], idLigne: 'ligne_15'),
    PositionBus(idBus: 'bus_105', position: _routeLine7[2], idLigne: 'ligne_7'),
    PositionBus(idBus: 'bus_106', position: const LatLng(14.675, -17.450), idLigne: 'ligne_hs'), // Bus hors service
  ];

  static final Map<String, int> _busRouteIndex = {
    'bus_101': 0,
    'bus_102': 0,
    'bus_103': 0,
    'bus_104': 0,
    'bus_105': 2,
  };
  
  static final List<Incident> incidents = [
    Incident(idIncident: 'inc-001', description: 'Retard de 8 minutes sur la Ligne 9', date: DateTime.now().subtract(const Duration(minutes: 5)), type: IncidentType.retard, status: IncidentStatus.signale, idLigne: 'ligne_9'),
    Incident(idIncident: 'inc-002', description: 'Déviation temporaire à Médina', date: DateTime.now().subtract(const Duration(minutes: 25)), type: IncidentType.deviation, status: IncidentStatus.en_cours, idLigne: 'ligne_15'),
  ];
  
  static final List<ArretFavori> favoris = [
    ArretFavori(idFavori: 'fav_1', nom: 'Arrêt UCAD', idLigne: 'ligne_9', prochainsPassages: [3, 12, 25]),
    ArretFavori(idFavori: 'fav_2', nom: 'Arrêt Liberté 6', idLigne: 'ligne_4', prochainsPassages: [5, 15]),
  ];

  // --- Helper Methods ---
  static Color getLineColor(String idLigne) {
    return lignes.firstWhere((l) => l.idLigne == idLigne, orElse: () => Ligne(idLigne: '', numero: '', depart: '', destination: '', frequence: '', color: Colors.grey, routePoints: [])).color;
  }

  static String getLineNumber(String idLigne) {
    return lignes.firstWhere((l) => l.idLigne == idLigne, orElse: () => Ligne(idLigne: '', numero: 'N/A', depart: '', destination: '', frequence: '', color: Colors.grey, routePoints: [])).numero;
  }
  
  // --- Bus Simulation Logic ---
  static void startBusSimulation() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      for (var i = 0; i < busPositions.length; i++) {
        final busId = busPositions[i].idBus;
        
        // Check if bus is part of the simulation
        if (_busRouteIndex.containsKey(busId)) {
          final line = lignes.firstWhere((l) => l.idLigne == busPositions[i].idLigne);
          final route = line.routePoints;
          int currentIndex = _busRouteIndex[busId]!;
          
          // Move to the next point, and loop if at the end
          currentIndex = (currentIndex + 1) % route.length;
          
          busPositions[i] = PositionBus(
            idBus: busId,
            position: route[currentIndex],
            idLigne: busPositions[i].idLigne,
          );
          _busRouteIndex[busId] = currentIndex;
        }
      }
      // Add the updated list to the stream
      _busPositionController.add(List.from(busPositions));
    });
  }
}
