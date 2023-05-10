import 'package:flutter/material.dart';

import '../affichestats/d2.dart';
import '../affichestats/d3.dart';
import '../affichestats/d4_depandance.dart';
import '../affichestats/d5.dart';
import '../affichestats/d7.dart';
import '../affichestats/d8_list.dart';

class StatsPage extends StatelessWidget {
  final List<String> stats = [
    'Évolution des dépenses annuelles moyennes pour la famille',
    'Évolution des dépenses annuelles moyennes par habitant par grandes entités géographiques',
    'Évolution des dépenses annuelles moyennes par habitant par quintile de dépenses',
    'Dépenses moyennes par catégorie professionnelle et sociale du chef de ménage',
    'Dépenses moyennes par taille de ménage',
    'Structure des dépenses',
    'Évolution de la pauvreté et de l’extrême pauvreté',
    'Ratio de pauvreté et ratio de pauvreté extrême par grandes entités géographiques',
    'Indice Gini par grandes entités géographiques'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats Page'),
      ),
      body: ListView.builder(
        itemCount: stats.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(
              Icons.query_stats_outlined,
            ),
            title: Text(stats[index]),
            onTap: () {
              if (index == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => d4_depandance()),
                );
              } else if (index == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => d2()),
                );
              } else if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => d3()),
                );
              } else if (index == 4) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => d5()),
                );
              } else if (index == 6) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => d7()),
                );
              } else if (index == 8) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => d8_list()),
                );
              }
            },
          );
        },
      ),
    );
  }
}
