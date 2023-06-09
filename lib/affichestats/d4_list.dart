import 'package:flutter/material.dart';
import 'd4_list_ch.dart';

class d4_list extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<d4_list> {
  TextEditingController _searchController = TextEditingController();
  List<String> _statsList = [
    'Chômeurs',
    'Autres inactifs',
    'ouvriers non agricoles',
    'exploitants agricoles',
    'artisans',
    'Ouvriers agricoles',
    'ProfLibS',
    'Niveau national',
    'Ouvriers agricoles',
    'indépendants',
    'autres employés',
    'ProfLibM',
    'Retraités',
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
    if (statsItem == 'Chômeurs') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'Chômeurs')),
      );
    } else if (statsItem == 'Autres inactifs') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'Autres inactifs')),
      );
    } else if (statsItem == 'ouvriers non agricoles') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                d4_list_ch(statsItem: 'ouvriers non agricoles')),
      );
    } else if (statsItem == 'exploitants agricoles') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                d4_list_ch(statsItem: 'exploitants agricoles')),
      );
    } else if (statsItem == 'artisans') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'artisans')),
      );
    } else if (statsItem == 'Ouvriers agricoles') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'Ouvriers agricoles')),
      );
    } else if (statsItem == 'ProfLibS') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'ProfLibS')),
      );
    } else if (statsItem == 'Niveau national') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: '  Niveau national')),
      );
    } else if (statsItem == 'Ouvriers agricoles') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'Ouvriers agricoles')),
      );
    } else if (statsItem == 'indépendants') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'indépendants')),
      );
    } else if (statsItem == 'autres employés') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'autres employés')),
      );
    } else if (statsItem == 'ProfLibM') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'ProfLibM')),
      );
    } else if (statsItem == 'Retraités') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d4_list_ch(statsItem: 'Retraités')),
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
