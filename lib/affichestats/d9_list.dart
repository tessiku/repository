import 'package:flutter/material.dart';
import 'd9_list_ch.dart';

class d9_list extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<d9_list> {
  TextEditingController _searchController = TextEditingController();
  List<String> _statsList = [
    'Grand Tunisie',
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
        MaterialPageRoute(
            builder: (context) => d9_list_ch(statsItem: 'grand tunis')),
      );
    } else if (statsItem == 'Nord-Est') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d9_list_ch(statsItem: 'nord est')),
      );
    } else if (statsItem == 'Nord-ouest') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d9_list_ch(statsItem: 'nord ouest')),
      );
    } else if (statsItem == 'Centre-Est') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d9_list_ch(statsItem: 'centre est')),
      );
    } else if (statsItem == 'Centre-ouest') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d9_list_ch(statsItem: 'centre ouest')),
      );
    } else if (statsItem == 'Sud-Est') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d9_list_ch(statsItem: 'sud est')),
      );
    } else if (statsItem == 'Sud-Ouest') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d9_list_ch(statsItem: 'sud ouest')),
      );
    } else if (statsItem == 'Niveau national') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => d9_list_ch(statsItem: '  Niveau national')),
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
