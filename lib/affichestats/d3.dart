import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class d3 extends StatefulWidget {
  //const d3({ Key? key }) : super(key: key);

  @override
  State<d3> createState() => _d3State();
}

class _d3State extends State<d3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Évolution des dépenses annuelles moyennes par habitant par quintile de dépenses'),
        ),
        //backgroundColor: Colors.black,
        body: Center(
            child: Container(
                child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 15000,
            interval: 3000,
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
  ChartData('premier ', 815, 1392, 2014),
  ChartData('second ', 1422, 2228, 3258),
  ChartData('third ', 2008, 3014, 4382),
  ChartData('forth ', 2871, 4176, 5921),
  ChartData('fifthe ', 5890, 8548, 11767),
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
