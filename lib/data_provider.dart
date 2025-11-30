
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'models.dart';

class DataProvider {
  // --- Route Polylines ---
  static final List<LatLng> _routeLine4 = [ const LatLng(14.764, -17.436), const LatLng(14.759, -17.442), const LatLng(14.755, -17.448), const LatLng(14.748, -17.453), const LatLng(14.739, -17.459), ];
  static final List<LatLng> _routeLine7 = [ const LatLng(14.739, -17.459), const LatLng(14.731, -17.465), const LatLng(14.722, -17.472), const LatLng(14.715, -17.480), ];
  static final List<LatLng> _routeLine9 = [ const LatLng(14.694, -17.466), const LatLng(14.699, -17.460), const LatLng(14.705, -17.455), const LatLng(14.708, -17.448), ];
  static final List<LatLng> _routeLine15 = [ const LatLng(14.735, -17.500), const LatLng(14.725, -17.490), const LatLng(14.710, -17.475), const LatLng(14.685, -17.445), ];

  static final List<Ligne> lignes = [
    Ligne(idLigne: 'ligne_4', numero: '4', depart: 'Terme Nord (Thiaroye)', destination: 'Liberté 6', frequence: '10-15 min', color: Colors.orange, routePoints: _routeLine4),
    Ligne(idLigne: 'ligne_7', numero: '7', depart: 'Terminus Liberté 6', destination: 'Parcelles Assainies', frequence: '8-12 min', color: Colors.red, routePoints: _routeLine7),
    Ligne(idLigne: 'ligne_9', numero: '9', depart: 'UCAD', destination: 'Gare Routière Pompiers', frequence: '15-20 min', color: Colors.green, routePoints: _routeLine9),
    Ligne(idLigne: 'ligne_15', numero: '15', depart: 'Yoff', destination: 'Plateau', frequence: '12-18 min', color: Colors.blue, routePoints: _routeLine15),
  ];

  static final List<Arret> arrets = [
    Arret(idArret: 'arret_indep', nom: 'Place de l\'Indépendance', position: const LatLng(14.668, -17.433), idLigne: 'ligne_7'),
    Arret(idArret: 'arret_ucad', nom: 'Université UCAD', position: const LatLng(14.694, -17.466), idLigne: 'ligne_9'),
  ];

  static final List<Bus> bus = [
    Bus(idBus: 'bus-001', numero: 'DDD-178', capacite: 50, status: 'en service', idLigne: 'ligne_9'),
    Bus(idBus: 'bus-002', numero: 'DDD-123', capacite: 50, status: 'en service', idLigne: 'ligne_4'),
    Bus(idBus: 'bus-003', numero: 'DDD-456', capacite: 50, status: 'en service', idLigne: 'ligne_7'),
    Bus(idBus: 'bus-004', numero: 'DDD-789', capacite: 50, status: 'en service', idLigne: 'ligne_15'),
    Bus(idBus: 'bus-005', numero: 'DDD-101', capacite: 50, status: 'en service', idLigne: 'ligne_7'),
    Bus(idBus: 'bus-006', numero: 'DDD-102', capacite: 50, status: 'en service', idLigne: 'ligne_9'),
  ];

  static final List<Incident> incidents = [
    Incident(idIncident: 'inc-001', description: 'Retard de 8 minutes - Bus DDD-178 (Embouteillage VDN)', date: DateTime.now().subtract(const Duration(minutes: 5)), status: IncidentStatus.signale, idLigne: 'ligne_9', type: IncidentType.retard),
    Incident(idIncident: 'inc-002', description: 'Trafic fluide sur l\'axe Liberté 6 - Sandaga', date: DateTime.now().subtract(const Duration(minutes: 15)), status: IncidentStatus.resolu, idLigne: 'ligne_7', type: IncidentType.autre),
    Incident(idIncident: 'inc-003', description: 'Déviation temporaire à Médina (travaux)', date: DateTime.now().subtract(const Duration(minutes: 25)), status: IncidentStatus.en_cours, idLigne: 'ligne_15', type: IncidentType.deviation),
  ];
}
