
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

// --- Core Models ---

@JsonSerializable()
class Utilisateur {
  final String idUtilisateur;
  final String nom;
  final String prenom;
  final String email;
  final String motDePasse;
  final String type; // admin, conducteur, passager

  Utilisateur({
    required this.idUtilisateur,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.motDePasse,
    required this.type,
  });

  factory Utilisateur.fromJson(Map<String, dynamic> json) => _$UtilisateurFromJson(json);
  Map<String, dynamic> toJson() => _$UtilisateurToJson(this);
}

@JsonSerializable()
class Ligne {
  final String idLigne;
  final String numero;
  final String depart;
  final String destination;
  final String frequence;
  @JsonKey(toJson: _colorToJson, fromJson: _colorFromJson)
  final Color color;
  @JsonKey(toJson: _routeToJson, fromJson: _routeFromJson)
  final List<LatLng> routePoints;

  Ligne({
    required this.idLigne,
    required this.numero,
    required this.depart,
    required this.destination,
    required this.frequence,
    required this.color,
    required this.routePoints,
  });

  factory Ligne.fromMap(Map<String, dynamic> map, String id) => _ligneFromMap(map, id);
  Map<String, dynamic> toMap() => _ligneToMap(this);

  factory Ligne.fromJson(Map<String, dynamic> json) => _$LigneFromJson(json);
  Map<String, dynamic> toJson() => _$LigneToJson(this);
}

@JsonSerializable()
class Arret {
  final String idArret;
  final String nom;
  @JsonKey(toJson: _latLngToJson, fromJson: _latLngFromJson)
  final LatLng position;
  final String idLigne;

  Arret({
    required this.idArret,
    required this.nom,
    required this.position,
    required this.idLigne,
  });

  factory Arret.fromJson(Map<String, dynamic> json) => _$ArretFromJson(json);
  Map<String, dynamic> toJson() => _$ArretToJson(this);
}

@JsonSerializable()
class Bus {
  final String idBus;
  final String numero;
  final int capacite;
  final String status; // "en service", "en panne", "hors service"
  final String idLigne;

  Bus({
    required this.idBus,
    required this.numero,
    required this.capacite,
    required this.status,
    required this.idLigne,
  });

  factory Bus.fromJson(Map<String, dynamic> json) => _$BusFromJson(json);
  Map<String, dynamic> toJson() => _$BusToJson(this);
}

@JsonSerializable()
class PositionBus {
  final String idBus;
  @JsonKey(toJson: _latLngToJson, fromJson: _latLngFromJson)
  final LatLng position;
  final String idLigne;

  PositionBus({
    required this.idBus,
    required this.position,
    required this.idLigne,
  });

  factory PositionBus.fromMap(Map<String, dynamic> map, String id) => _positionBusFromMap(map, id);
  Map<String, dynamic> toMap() => _positionBusToMap(this);

  factory PositionBus.fromJson(Map<String, dynamic> json) => _$PositionBusFromJson(json);
  Map<String, dynamic> toJson() => _$PositionBusToJson(this);
}

// --- Incident & Alert Models ---

enum IncidentType { retard, deviation, panne, accident, autre }
enum IncidentStatus { signale, en_cours, resolu }

@JsonSerializable()
class Incident {
  final String idIncident;
  final String description;
  final DateTime date;
  final IncidentType type;
  final IncidentStatus status;
  final String idLigne;

  Incident({
    required this.idIncident,
    required this.description,
    required this.date,
    required this.type,
    required this.status,
    required this.idLigne,
  });

  factory Incident.fromJson(Map<String, dynamic> json) => _$IncidentFromJson(json);
  Map<String, dynamic> toJson() => _$IncidentToJson(this);
}

// --- User-Specific Models ---

@JsonSerializable()
class ArretFavori {
  final String idFavori;
  final String nom; // e.g., "Arrêt UCAD"
  final String idLigne;
  final List<int> prochainsPassages; // e.g., [5, 12, 25] in minutes

  ArretFavori({
    required this.idFavori,
    required this.nom,
    required this.idLigne,
    required this.prochainsPassages,
  });

  factory ArretFavori.fromJson(Map<String, dynamic> json) => _$ArretFavoriFromJson(json);
  Map<String, dynamic> toJson() => _$ArretFavoriToJson(this);
}

// --- Custom JSON Converters ---

int _colorToJson(Color color) => color.value;
Color _colorFromJson(int value) => Color(value);

Map<String, double> _latLngToJson(LatLng latLng) => {'latitude': latLng.latitude, 'longitude': latLng.longitude};
LatLng _latLngFromJson(Map<String, dynamic> json) => LatLng(json['latitude'], json['longitude']);

List<Map<String, double>> _routeToJson(List<LatLng> route) => route.map(_latLngToJson).toList();
List<LatLng> _routeFromJson(List<dynamic> json) => json.map((e) => _latLngFromJson(e)).toList();

// --- Manual Mappers for Realtime Database ---

Ligne _ligneFromMap(Map<String, dynamic> map, String id) {
  return Ligne(
    idLigne: id,
    numero: map['numero'] ?? '',
    depart: map['depart'] ?? '',
    destination: map['destination'] ?? '',
    frequence: map['frequence'] ?? '',
    color: Color(map['color'] ?? 0xFF808080),
    routePoints: (map['routePoints'] as List<dynamic>? ?? []).map((p) => LatLng(p['latitude'], p['longitude'])).toList(),
  );
}

Map<String, dynamic> _ligneToMap(Ligne ligne) {
  return {
    'numero': ligne.numero,
    'depart': ligne.depart,
    'destination': ligne.destination,
    'frequence': ligne.frequence,
    'color': ligne.color.value,
    'routePoints': ligne.routePoints.map((p) => {'latitude': p.latitude, 'longitude': p.longitude}).toList(),
  };
}

PositionBus _positionBusFromMap(Map<String, dynamic> map, String id) {
  return PositionBus(
    idBus: id,
    position: LatLng(map['latitude'] ?? 0, map['longitude'] ?? 0),
    idLigne: map['idLigne'] ?? '',
  );
}

Map<String, dynamic> _positionBusToMap(PositionBus pos) {
  return {
    'latitude': pos.position.latitude,
    'longitude': pos.position.longitude,
    'idLigne': pos.idLigne,
  };
}
