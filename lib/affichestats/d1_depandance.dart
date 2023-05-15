import 'package:flutter/material.dart';
import 'package:ins_app/affichestats/d1_4.dart';
import 'd1_1.dart';
import 'd1_2.dart';
import 'd1_3.dart';
import 'd1_5.dart';
import 'd1_6.dart';

class d4_depandance extends StatelessWidget {
  final List<String> stats = [
    'stats for  2010 moyennes pour la famille ',
    'stats for 2015 moyennes pour la famille',
    'stats for 2021 moyennes pour la famille',
    'stats for 2010 moyennes pour le personnel',
    'stats for 2015 moyennes pour le personnel',
    'stats for 2021 moyennes pour le personnel',
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
                    MaterialPageRoute(builder: (context) => d1_1()),
                  );
                } else if (i == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => d1_2()),
                  );
                } else if (i == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => d1_3()),
                  );
                } else if (i == 3) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => d1_4()),
                  );
                } else if (i == 4) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => d1_5()),
                  );
                } else if (i == 5) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => d1_6()),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
