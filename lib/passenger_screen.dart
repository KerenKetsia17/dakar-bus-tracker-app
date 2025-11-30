
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'services/firebase_service.dart';
import 'models.dart';

class PassengerScreen extends StatefulWidget {
  const PassengerScreen({super.key});

  @override
  PassengerScreenState createState() => PassengerScreenState();
}

class PassengerScreenState extends State<PassengerScreen> {
  int _selectedIndex = 0;
  final LatLng _userPosition = const LatLng(14.705, -17.475);
  String _searchQuery = '';
  bool _showNearbyLines = false;

  void _onTabTapped(int index) {
    setState(() { _selectedIndex = index; });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseService = Provider.of<FirebaseService>(context);
    const primaryColor = Color(0xFF3498DB);
    const backgroundColor = Color(0xFFEBF5FB);

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: const [
                  Text('Dakar Dem Dikk - Passager', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Suivez vos bus en temps réel à Dakar', style: TextStyle(color: Colors.white70, fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                     Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(25.0),
                           boxShadow: [BoxShadow(color: Colors.black.withAlpha(25), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTabItem(Icons.map, 'Carte', 0, primaryColor),
                            _buildTabItem(Icons.linear_scale, 'Lignes', 1, primaryColor),
                            _buildTabItem(Icons.star, 'Favoris', 2, primaryColor),
                            _buildTabItem(Icons.directions, 'Itinéraire', 3, primaryColor),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: _selectedIndex,
                        children: [
                          _buildMapScreen(firebaseService, _userPosition),
                          _buildLinesScreen(firebaseService),
                          _buildFavoritesScreen(),
                          _buildRoutePlannerScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label, int index, Color primaryColor) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withAlpha(26) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(children: [
          Icon(icon, color: isSelected ? primaryColor : Colors.grey[600], size: 20),
          if (isSelected) const SizedBox(width: 8),
          if (isSelected) Text(label, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}

// --- Screen Build Functions ---

Widget _buildMapScreen(FirebaseService firebaseService, LatLng userPosition) {
  return StreamBuilder<List<PositionBus>>(
    stream: firebaseService.getBusPositionsStream(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final busPositions = snapshot.data!;

      return StreamBuilder<List<Ligne>>(
        stream: firebaseService.getLignesStream(),
        builder: (context, lineSnapshot) {
          if (!lineSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final allLines = lineSnapshot.data!;

          return FlutterMap(
            options: MapOptions(initialCenter: userPosition, initialZoom: 13.0),
            children: [
              TileLayer(urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', subdomains: const ['a', 'b', 'c']),
              PolylineLayer(
                polylines: allLines.map((line) {
                  return Polyline(points: line.routePoints, color: line.color.withOpacity(0.7), strokeWidth: 4.0);
                }).toList(),
              ),
              MarkerLayer(markers: [
                Marker(
                  point: userPosition,
                  width: 100, height: 50,
                  child: Column(children: [
                    Container(padding: const EdgeInsets.all(4.0), decoration: BoxDecoration(color: Colors.blue.shade800, borderRadius: BorderRadius.circular(8)), child: const Text('Vous êtes ici', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                    Icon(Icons.person_pin_circle, color: Colors.blue.shade800, size: 30)
                  ]),
                ),
                ...busPositions.map((busPos) {
                  final line = allLines.firstWhere((l) => l.idLigne == busPos.idLigne, orElse: () => allLines.first);
                  return Marker(
                    point: busPos.position,
                    width: 40, height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: line.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 5, offset: Offset(0, 2))],
                      ),
                      child: const Icon(Icons.directions_bus, color: Colors.white, size: 20),
                    ),
                  );
                }).toList(),
              ]),
            ],
          );
        },
      );
    },
  );
}

Widget _buildLinesScreen(FirebaseService firebaseService) {
  return StreamBuilder<List<Ligne>>(
    stream: firebaseService.getLignesStream(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      final lines = snapshot.data!;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'Rechercher par ligne ou destination...', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: lines.length,
              itemBuilder: (context, index) {
                final line = lines[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2, shadowColor: Colors.black.withAlpha(25),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(children: [
                      Container(width: 8, height: 50, decoration: BoxDecoration(color: line.color, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Ligne ${line.numero}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text('${line.depart} → ${line.destination}', style: TextStyle(color: Colors.grey.shade600))])),
                      Text(line.frequence, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    ]),
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

Widget _buildFavoritesScreen() {
  // This can be implemented later with Firebase
  return const Center(child: Text('Fonctionnalité à venir'));
}

Widget _buildRoutePlannerScreen() {
  // This can be implemented later
  return const Center(child: Text('Fonctionnalité à venir'));
}

