import 'package:flutter/material.dart';
import 'd6_list_ch.dart';

class d6_list extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<d6_list> {
  TextEditingController _searchController = TextEditingController();
  List<String> _statsList = [
    'Autres',
    'santé',
    'tabac',
    'restocafe',
    'electro-menager',
    'éducation',
    'divertissement',
    'vêtements',
    'logement',
    'transport',
    'Communications',
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

  void _navigateToStatsPage(BuildContext context, String statsItem) {
    if (statsItem == 'Autres') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d6_list_ch(statsItem: 'Autres')),
      );
    } else if (statsItem == 'santé') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d6_list_ch(statsItem: 'santé')),
      );
    } else if (statsItem == 'tabac') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d6_list_ch(statsItem: 'tabac')),
      );
    } else if (statsItem == 'restocafe') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d6_list_ch(statsItem: 'restocafe')),
      );
    } else if (statsItem == 'electro-menager') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d6_list_ch(statsItem: 'electro-menager')),
      );
    } else if (statsItem == 'éducation') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d6_list_ch(statsItem: 'éducation')),
      );
    } else if (statsItem == 'divertissement') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d6_list_ch(statsItem: 'divertissement')),
      );
    } else if (statsItem == 'vêtements') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d6_list_ch(statsItem: 'vêtements')),
      );
    }
    if (statsItem == 'logement') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d6_list_ch(statsItem: 'logement')),
      );
    } else if (statsItem == 'transport') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d6_list_ch(statsItem: 'transport')),
      );
    } else if (statsItem == 'Communications') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d6_list_ch(statsItem: 'Communications')),
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
          width: 100,
          height: 100,
          child: Transform.scale(scale: 1.5, child: Icon(Icons.query_stats)),
        ),
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
