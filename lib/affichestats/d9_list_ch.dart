import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class d9_list_ch extends StatefulWidget {
  const d9_list_ch({Key? key, required this.statsItem}) : super(key: key);
  final String statsItem;

  @override
  _d9_list_chState createState() => _d9_list_chState();
}

class _d9_list_chState extends State<d9_list_ch> {
  late CollectionReference<Map<String, dynamic>> _tabRef;
  late List<ChartData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  String _tooltipHeader = '';

  @override
  void initState() {
    super.initState();
    _tabRef = FirebaseFirestore.instance.collection('TAB9');

    _chartData = [];
    print('Selected item: ${widget.statsItem}');
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: _tooltipHeader,
      format: 'Moyenne: point.y',
    );
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
              final GINI = doc['GINI'];
              final annee = doc['annee'];
              final zone = doc['zone'];
              _chartData.add(ChartData(
                  x: annee.toString(),
                  yValue1: GINI,
                  yValue2: zone.toString()));
              _tooltipBehavior = TooltipBehavior(
                enable: true,
                header: _tooltipHeader,
                format: 'Moyenne: point.y',
              );
              print('data add : $GINI, $annee, $zone');
            }
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              tooltipBehavior: _tooltipBehavior,
              axes: <ChartAxis>[
                NumericAxis(
                  numberFormat: NumberFormat.compact(),
                  majorGridLines: const MajorGridLines(width: 0),
                  opposedPosition: true,
                  name: 'yAxis1',
                  interval: 1000,
                  minimum: 0,
                  maximum: 8000,
                )
              ],
              series: <ChartSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  animationDuration: 2000,
                  dataSource: _chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.yValue1,
                  name: 'Moyenne',
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
