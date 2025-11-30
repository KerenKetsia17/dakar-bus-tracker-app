
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'models.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de Bord Administrateur'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.linear_scale), text: 'Lignes'),
            Tab(icon: Icon(Icons.directions_bus), text: 'Bus'),
            Tab(icon: Icon(Icons.warning), text: 'Incidents'),
            Tab(icon: Icon(Icons.people), text: 'Utilisateurs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LignesTab(),
          const Center(child: Text('Gestion des Bus (à venir)')),
          const Center(child: Text('Gestion des Incidents (à venir)')),
          const Center(child: Text('Gestion des Utilisateurs (à venir)')),
        ],
      ),
    );
  }
}

// --- Onglet pour la gestion des Lignes ---

class LignesTab extends StatefulWidget {
  @override
  _LignesTabState createState() => _LignesTabState();
}

class _LignesTabState extends State<LignesTab> {
  late Future<List<Ligne>> _lignesFuture;

  @override
  void initState() {
    super.initState();
    _refreshLignes();
  }

  void _refreshLignes() {
    final apiService = Provider.of<ApiService>(context, listen: false);
    setState(() {
      _lignesFuture = apiService.getLignes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiService = Provider.of<ApiService>(context);

    return Scaffold(
      body: FutureBuilder<List<Ligne>>(
        future: _lignesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final lignes = snapshot.data!;

          return ListView.builder(
            itemCount: lignes.length,
            itemBuilder: (context, index) {
              final ligne = lignes[index];
              return ListTile(
                title: Text('Ligne ${ligne.numero}'),
                subtitle: Text('${ligne.depart} -> ${ligne.destination}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showLigneDialog(context, apiService, ligne: ligne),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await apiService.deleteLigne(ligne.idLigne);
                        _refreshLignes();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLigneDialog(context, apiService),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLigneDialog(BuildContext context, ApiService apiService, {Ligne? ligne}) {
    final _formKey = GlobalKey<FormState>();
    final _numeroController = TextEditingController(text: ligne?.numero);
    final _departController = TextEditingController(text: ligne?.depart);
    final _destinationController = TextEditingController(text: ligne?.destination);
    final _frequenceController = TextEditingController(text: ligne?.frequence);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(ligne == null ? 'Ajouter une ligne' : 'Modifier la ligne'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _numeroController,
                  decoration: const InputDecoration(labelText: 'Numéro de ligne'),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                TextFormField(
                  controller: _departController,
                  decoration: const InputDecoration(labelText: 'Départ'),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                TextFormField(
                  controller: _destinationController,
                  decoration: const InputDecoration(labelText: 'Destination'),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
                TextFormField(
                  controller: _frequenceController,
                  decoration: const InputDecoration(labelText: 'Fréquence'),
                  validator: (value) => value!.isEmpty ? 'Champ requis' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final nouvelleLigne = Ligne(
                    idLigne: ligne?.idLigne ?? '', // L'ID sera généré par le backend
                    numero: _numeroController.text,
                    depart: _departController.text,
                    destination: _destinationController.text,
                    frequence: _frequenceController.text,
                    color: Colors.blue, // Couleur par défaut
                    routePoints: [], // Itinéraire vide par défaut
                  );

                  if (ligne == null) {
                    await apiService.createLigne(nouvelleLigne);
                  } else {
                    await apiService.updateLigne(ligne.idLigne, nouvelleLigne);
                  }
                  _refreshLignes();
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Sauvegarder'),
            ),
          ],
        );
      },
    );
  }
}
