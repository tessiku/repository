import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class d2 extends StatefulWidget {
  //const d2({super.key});

  @override
  State<d2> createState() => _d2State();
}

class _d2State extends State<d2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'dépenses annuelles moyennes par habitant par grandes entités géographiques'),
        ),
        body: Center(
            child: Container(
                child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 8000,
            interval: 1000,
          ),
          palette: <Color>[Colors.teal, Colors.orange, Colors.brown],
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelMapper: (ChartData data, _) => data.y.toString(),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: 12),
                labelAlignment: ChartDataLabelAlignment.top,
              ),
            ),
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y1,
              dataLabelMapper: (ChartData data, _) => data.y1.toString(),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: 12),
                labelAlignment: ChartDataLabelAlignment.top,
              ),
            ),
            ColumnSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y2,
              dataLabelMapper: (ChartData data, _) => data.y2.toString(),
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: 12),
                labelAlignment: ChartDataLabelAlignment.top,
              ),
            ),
          ],
        ))));
  }
}

List<ChartData> chartData = <ChartData>[
  ChartData('territoire Tunisie', 3498, 5312, 6874),
  ChartData('N-E', 2241, 3440, 5057),
  ChartData('N-O', 1754, 2696, 4493),
  ChartData('C-E', 3081, 4309, 6130),
  ChartData(
    's-E',
    2464,
    3250,
    4675,
  ),
  ChartData('S-O', 2064, 3077, 4847),
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
