import 'package:flutter/material.dart';
import '../affichestats/d8_list-chose.dart';

class d8_list extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<d8_list> {
  TextEditingController _searchController = TextEditingController();
  List<String> _statsList = [
    'Grande Tunisie',
    'Nord-Est',
    'Nord-ouest',
    'Centre-Est',
    'Centre-ouest',
    'Sud-Est',
    'Sud-Ouest',
    'Niveau national',
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
    if (statsItem == 'Grande Tunisie') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d8_list_chose()),
      );
    } else if (statsItem == 'Nord-ouest') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d8_list_chose()),
      );
    } else if (statsItem == 'Centre-Est') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d8_list_chose()),
      );
    } else if (statsItem == 'Centre-ouest') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d8_list_chose()),
      );
    } else if (statsItem == 'Sud-Est') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d8_list_chose()),
      );
    } else if (statsItem == 'Sud-Ouest') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d8_list_chose()),
      );
    } else if (statsItem == 'Niveau national') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => d8_list_chose()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indice Gini par grandes entités géographiques'),
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