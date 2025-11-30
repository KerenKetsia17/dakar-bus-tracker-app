// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Utilisateur _$UtilisateurFromJson(Map<String, dynamic> json) => Utilisateur(
  idUtilisateur: json['idUtilisateur'] as String,
  nom: json['nom'] as String,
  prenom: json['prenom'] as String,
  email: json['email'] as String,
  motDePasse: json['motDePasse'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$UtilisateurToJson(Utilisateur instance) =>
    <String, dynamic>{
      'idUtilisateur': instance.idUtilisateur,
      'nom': instance.nom,
      'prenom': instance.prenom,
      'email': instance.email,
      'motDePasse': instance.motDePasse,
      'type': instance.type,
    };

Ligne _$LigneFromJson(Map<String, dynamic> json) => Ligne(
  idLigne: json['idLigne'] as String,
  numero: json['numero'] as String,
  depart: json['depart'] as String,
  destination: json['destination'] as String,
  frequence: json['frequence'] as String,
  color: _colorFromJson((json['color'] as num).toInt()),
  routePoints: _routeFromJson(json['routePoints'] as List),
);

Map<String, dynamic> _$LigneToJson(Ligne instance) => <String, dynamic>{
  'idLigne': instance.idLigne,
  'numero': instance.numero,
  'depart': instance.depart,
  'destination': instance.destination,
  'frequence': instance.frequence,
  'color': _colorToJson(instance.color),
  'routePoints': _routeToJson(instance.routePoints),
};

Arret _$ArretFromJson(Map<String, dynamic> json) => Arret(
  idArret: json['idArret'] as String,
  nom: json['nom'] as String,
  position: _latLngFromJson(json['position'] as Map<String, dynamic>),
  idLigne: json['idLigne'] as String,
);

Map<String, dynamic> _$ArretToJson(Arret instance) => <String, dynamic>{
  'idArret': instance.idArret,
  'nom': instance.nom,
  'position': _latLngToJson(instance.position),
  'idLigne': instance.idLigne,
};

Bus _$BusFromJson(Map<String, dynamic> json) => Bus(
  idBus: json['idBus'] as String,
  numero: json['numero'] as String,
  capacite: (json['capacite'] as num).toInt(),
  status: json['status'] as String,
  idLigne: json['idLigne'] as String,
);

Map<String, dynamic> _$BusToJson(Bus instance) => <String, dynamic>{
  'idBus': instance.idBus,
  'numero': instance.numero,
  'capacite': instance.capacite,
  'status': instance.status,
  'idLigne': instance.idLigne,
};

PositionBus _$PositionBusFromJson(Map<String, dynamic> json) => PositionBus(
  idBus: json['idBus'] as String,
  position: _latLngFromJson(json['position'] as Map<String, dynamic>),
  idLigne: json['idLigne'] as String,
);

Map<String, dynamic> _$PositionBusToJson(PositionBus instance) =>
    <String, dynamic>{
      'idBus': instance.idBus,
      'position': _latLngToJson(instance.position),
      'idLigne': instance.idLigne,
    };

Incident _$IncidentFromJson(Map<String, dynamic> json) => Incident(
  idIncident: json['idIncident'] as String,
  description: json['description'] as String,
  date: DateTime.parse(json['date'] as String),
  type: $enumDecode(_$IncidentTypeEnumMap, json['type']),
  status: $enumDecode(_$IncidentStatusEnumMap, json['status']),
  idLigne: json['idLigne'] as String,
);

Map<String, dynamic> _$IncidentToJson(Incident instance) => <String, dynamic>{
  'idIncident': instance.idIncident,
  'description': instance.description,
  'date': instance.date.toIso8601String(),
  'type': _$IncidentTypeEnumMap[instance.type]!,
  'status': _$IncidentStatusEnumMap[instance.status]!,
  'idLigne': instance.idLigne,
};

const _$IncidentTypeEnumMap = {
  IncidentType.retard: 'retard',
  IncidentType.deviation: 'deviation',
  IncidentType.panne: 'panne',
  IncidentType.accident: 'accident',
  IncidentType.autre: 'autre',
};

const _$IncidentStatusEnumMap = {
  IncidentStatus.signale: 'signale',
  IncidentStatus.en_cours: 'en_cours',
  IncidentStatus.resolu: 'resolu',
};

ArretFavori _$ArretFavoriFromJson(Map<String, dynamic> json) => ArretFavori(
  idFavori: json['idFavori'] as String,
  nom: json['nom'] as String,
  idLigne: json['idLigne'] as String,
  prochainsPassages: (json['prochainsPassages'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$ArretFavoriToJson(ArretFavori instance) =>
    <String, dynamic>{
      'idFavori': instance.idFavori,
      'nom': instance.nom,
      'idLigne': instance.idLigne,
      'prochainsPassages': instance.prochainsPassages,
    };
