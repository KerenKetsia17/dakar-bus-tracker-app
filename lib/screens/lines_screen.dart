import 'package:flutter/material.dart';

class LinesScreen extends StatelessWidget {
  const LinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lignes de Bus'),
        actions: [
          IconButton(icon: const Icon(Icons.map), onPressed: () {}),
          IconButton(icon: const Icon(Icons.star), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Rechercher une Ligne',
                hintText: 'Nom de la ligne',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            // TODO: Display list of bus lines
          ],
        ),
      ),
    );
  }
}
