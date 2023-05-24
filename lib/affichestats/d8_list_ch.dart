import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class d8_list_ch extends StatefulWidget {
  const d8_list_ch({Key? key, required this.statsItem}) : super(key: key);
  final String statsItem;

  @override
  _d8_list_chState createState() => _d8_list_chState();
}

class _d8_list_chState extends State<d8_list_ch> {
  late CollectionReference<Map<String, dynamic>> _tabRef;
  late List<ChartData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    super.initState();
    _tabRef = FirebaseFirestore.instance.collection('TAB8');
    _tooltipBehavior = TooltipBehavior(enable: true);
    _chartData = [];
    _chartData = [];
    print('Selected item: ${widget.statsItem}');
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
            child: Transform.scale(
                scale: 1,
                child: Text(
                  widget.statsItem.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ))),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _tabRef.where("zone", isEqualTo: widget.statsItem).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _chartData.clear();
            for (final doc in snapshot.data!.docs) {
              final p1 = doc['p1'];
              final annee = doc['annee'];
              final zone = doc['zone'];
              _chartData.add(ChartData(
                  x: annee.toString(), yValue1: p1, yValue2: zone.toString()));

              print('data add : $p1, $annee, $zone');
            }
            print("data exesteted");
            return SfCircularChart(
              title: ChartTitle(
                  text: widget.statsItem +
                      " par pourcentage (Ratio de pauvreté)"),
              legend: Legend(isVisible: true),
              tooltipBehavior: TooltipBehavior(
                  enable: true, format: widget.statsItem + ' point.y%'),
              series: <CircularSeries>[
                DoughnutSeries<ChartData, String>(
                  dataSource: _chartData,
                  xValueMapper: (ChartData data, _) => data.x, // year
                  yValueMapper: (ChartData data, _) => data.yValue1, // valuer
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  animationDelay: 5,
                  enableTooltip: true,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class ChartData {
  ChartData({required this.x, required this.yValue1, required this.yValue2});
  final String x;
  final double yValue1;
  final String yValue2;
}
