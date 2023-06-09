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
        //backgroundColor: Colors.black,
        body: Center(
            child: Container(
                child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 15000,
            interval: 3000,
          ),
          palette: <Color>[Colors.teal, Colors.orange, Colors.brown],
          series: <CartesianSeries>[
            ColumnSeries<ChartData, String>(
              name: '2010',
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              dataLabelMapper: (ChartData data, _) => data.y.toString(),
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
  ChartData('premier ', 815, 1392, 2014),
  ChartData('deuxième', 1422, 2228, 3258),
  ChartData('troisième ', 2008, 3014, 4382),
  ChartData('quatrieme', 2871, 4176, 5921),
  ChartData('cenquieme', 5890, 8548, 11767),
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
