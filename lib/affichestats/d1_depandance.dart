import 'package:flutter/material.dart';
import 'package:ins_app/affichestats/d1_tab1.dart';

import 'd1_tab2.dart';

class StatsList extends StatefulWidget {
  @override
  State<StatsList> createState() => _StatsListState();
}

class _StatsListState extends State<StatsList> {
  TextEditingController _searchController = TextEditingController();
  List<String> _statsList = [
    'stats pour 2010 moyennes pour la famille ',
    'stats pour 2015 moyennes pour la famille',
    'stats pour 2021 moyennes pour la famille',
    'stats pour 2010 moyennes pour le personnel',
    'stats pour 2015 moyennes pour le personnel',
    'stats pour 2021 moyennes pour le personnel',
  ];
  List<String> _filteredStatsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _filteredStatsList = _statsList;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchTerm = _searchController.text;
    List<String> filteredList = [];

    if (searchTerm.isEmpty) {
      filteredList = _statsList;
    } else {
      _statsList.forEach((item) {
        if (item.toLowerCase().contains(searchTerm.toLowerCase())) {
          filteredList.add(item);
        }
      });
    }

    setState(() {
      _filteredStatsList = filteredList;
    });
  }
                                                                      //route to the stats pages with the year
  void _navigateToStatsPage(BuildContext context, String statsItem) {
    if (statsItem == 'stats pour  2010 moyennes pour la famille ') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d1_tab1(statsItem: 2010)),
      );
    } else if (statsItem == 'stats pour 2015 moyennes pour la famille') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d1_tab1(statsItem: 2015)),
      );
    } else if (statsItem == 'stats pour 2021 moyennes pour la famille') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d1_tab1(statsItem: 2021)),
      );
    } else if (statsItem == 'stats pour 2010 moyennes pour le personnel') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d1_tab2(statsItem: 2010)),
      );
    } else if (statsItem == 'stats pour 2015 moyennes pour le personnel') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d1_tab2(statsItem: 2015)),
      );
    } else if (statsItem == 'stats pour 2021 moyennes pour le personnel') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d1_tab2(statsItem: 2021)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 94, 6, 247),
        toolbarHeight: 80,
        centerTitle: true,
        title: Container(
            width: 200,
            child: Transform.scale(
                scale: 1,
                child: Text(
                  'DEPENSES ANUELLES ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ))),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredStatsList.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    _navigateToStatsPage(context, _filteredStatsList[index]);
                  },
                  child: ListTile(
                    title: Text(_filteredStatsList[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
