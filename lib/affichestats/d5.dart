import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class d5 extends StatefulWidget {
  //const d5({super.key});

  @override
  State<d5> createState() => _d3State();
}

class _d3State extends State<d5> {
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
        body: Center(
            child: Container(
                child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 10000,
            interval: 1000,
          ),
          palette: <Color>[Colors.teal, Colors.orange, Colors.brown],
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              name: '2010',
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
            ),
            ColumnSeries<ChartData, String>(
              name: '2015',
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y1,
            ),
            ColumnSeries<ChartData, String>(
              name: '2021',
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y2,
            ),
          ],
        ))));
  }
}

List<ChartData> chartData = <ChartData>[
  ChartData(' 1-2', 4234, 6101, 8342),
  ChartData('3-4', 3202, 4594, 5990),
  ChartData('5-6', 2320, 3179, 4389),
  ChartData('7-8', 1665, 2406, 2394),
  ChartData('9+', 1525, 2137, 2728),
];

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2);
  final String x;
  final double? y;
  final double? y1;
  final double? y2;
  /*final double? y3;
  final double? y4;
  final double? y5;*/
}
