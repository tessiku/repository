import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GetData extends StatefulWidget {
  const GetData({Key? key}) : super(key: key);

  @override
  _GetDataState createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  late CollectionReference<Map<String, dynamic>> _tabRef;
  late List<ChartData> _chartData;

  @override
  void initState() {
    super.initState();
    _tabRef = FirebaseFirestore.instance.collection('TAB1');
    _chartData = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Data'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _tabRef.where("Annee", isEqualTo: 2010).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Clear the chart data list
            _chartData.clear();

            // Iterate over the documents in the query snapshot and extract the necessary data
            for (final doc in snapshot.data!.docs) {
              //final annee = doc['Annee'];
              final moyenne = doc['Moyenne'];
              final zone = doc['Zone'];

              // Add a new ChartData object to the chart data list
              _chartData.add(ChartData(x: zone, yValue1: moyenne));
            }

            // Return the chart widget
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(),
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
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('error');
          } else {
            return Text('waiting');
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
