
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart'; // Importation corrigée
import '../models.dart';

class FirebaseService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // --- Streams for real-time data ---
  Stream<List<Ligne>> getLignesStream() {
    return _database.ref('lignes').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries.map((e) => Ligne.fromMap(Map<String, dynamic>.from(e.value), e.key)).toList();
    });
  }

  Stream<List<PositionBus>> getBusPositionsStream() {
    return _database.ref('bus_positions').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.entries.map((e) => PositionBus.fromMap(Map<String, dynamic>.from(e.value), e.key)).toList();
    });
  }

  // --- CRUD Operations for Lignes (will be removed from client-side)
  Future<void> addLigne(Ligne ligne) async {
    final newLigneRef = _database.ref('lignes').push();
    await newLigneRef.set(ligne.toMap());
  }

  Future<void> updateLigne(String id, Ligne ligne) async {
    await _database.ref('lignes/$id').update(ligne.toMap());
  }

  Future<void> deleteLigne(String id) async {
    await _database.ref('lignes/$id').remove();
  }

  // --- Bus Position Update ---
  Future<void> updateBusPosition(String busId, LatLng position) async {
    await _database.ref('bus_positions/$busId').set({
      'idLigne': 'ligne-temp-id', // This should be dynamic
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
