import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class d1_tab2 extends StatefulWidget {
  const d1_tab2({Key? key, required this.statsItem}) : super(key: key);
  final int statsItem;

  @override
  _d1_tab2State createState() => _d1_tab2State();
}

class _d1_tab2State extends State<d1_tab2> {
  late CollectionReference<Map<String, dynamic>> _tabRef;
  late List<ChartData> _chartData;
  late TooltipBehavior _tooltipBehavior;
  String _tooltipHeader = '';

  @override
  void initState() {
    super.initState();
    _tabRef = FirebaseFirestore.instance.collection('TAB2');

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
        title: Text(widget.statsItem.toString()),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _tabRef.where("Annee", isEqualTo: widget.statsItem).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _chartData.clear();
            for (final doc in snapshot.data!.docs) {
              final moyenne = doc['Moyenne'];
              final zone = doc['Zone'];
              _chartData.add(ChartData(x: zone, yValue1: moyenne));
              _tooltipBehavior = TooltipBehavior(
                enable: true,
                header: _tooltipHeader,
                format: 'Moyenne: point.y',
              );
              print('data add : $moyenne, $zone');
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
  ChartData({required this.x, required this.yValue1});
  final String x;
  final int yValue1;
}
