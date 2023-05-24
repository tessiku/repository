import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class d7 extends StatefulWidget {
  //const d7({super.key});

  @override
  State<d7> createState() => _d7State();
}

class _d7State extends State<d7> {
  @override
  Widget build(BuildContext context) {
    final String x = 'centre urbaine';
    final String y = 'centre rural';
    final String z = 'national';
    final String y1 = '2010';
    final String y2 = '2015';
    final String y3 = '2021';
    final List<ChartData> chartData = <ChartData>[
      ChartData(x: x + ' ' + y1, yValue1: 2.1),
      ChartData(x: y + ' ' + y1, yValue1: 13.6),
      ChartData(x: z + ' ' + y1, yValue1: 6),
      ChartData(x: x + ' ' + y2, yValue1: 1.2),
      ChartData(x: y + ' ' + y2, yValue1: 6.6),
      ChartData(x: z + ' ' + y2, yValue1: 2.9),
      ChartData(x: x + ' ' + y3, yValue1: 1.7),
      ChartData(x: y + ' ' + y3, yValue1: 5.3),
      ChartData(x: z + ' ' + y3, yValue1: 2.9),
    ];

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
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: SfCartesianChart(
                  tooltipBehavior: TooltipBehavior(enable: true),
                  primaryXAxis: CategoryAxis(
                      labelStyle: const TextStyle(color: Colors.transparent)),
                  axes: <ChartAxis>[
                    NumericAxis(
                      numberFormat: NumberFormat.percentPattern(),
                      majorGridLines: const MajorGridLines(width: 1),
                      opposedPosition: true,
                      name: 'yAxis1',
                      interval: 1,
                      minimum: 0,
                      maximum: 100,
                    )
                  ],
                  series: <ChartSeries<ChartData, String>>[
                    ColumnSeries<ChartData, String>(
                      xAxisName: 'xAxis1',
                      animationDuration: 2000,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x!,
                      yValueMapper: (ChartData data, _) => data.yValue1!,
                      dataLabelSettings: DataLabelSettings(isVisible: true),

                      // markerSettings: MarkerSettings(isVisible: true),
                      name: ' taux de Pauvreté',
                    ),
                    LineSeries<ChartData, String>(
                      animationDuration: 4500,
                      animationDelay: 2000,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.yValue2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData({this.x, this.yValue1, this.yValue2});
  final String? x;
  final double? yValue1;
  final double? yValue2;
}
