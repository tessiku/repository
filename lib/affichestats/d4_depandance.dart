import 'package:flutter/material.dart';
import '../affichestats/d4_1.dart';
import '../affichestats/d4_2.dart';
import '../affichestats/d4_3.dart';

class d4_depandance extends StatelessWidget {
  final List<String> stats = [
    'stats for  2010 ',
    'stats for 2015',
    'stats for 2021'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('les dépenses annuelles moyennes pour la famille'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('List of stats:'),
          SizedBox(height: 16),
          for (int i = 0; i < stats.length; i++)
            ListTile(
              leading: Icon(Icons.query_stats_outlined),
              title: Text(stats[i]),
              onTap: () {
                if (i == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => d4_1()),
                  );
                } else if (i == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => d4_2()),
                  );
                } else if (i == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => d4_3()),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
