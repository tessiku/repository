import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class d4_3 extends StatefulWidget {
  //const d4_3({super.key});

  @override
  State<d4_3> createState() => _d4_3State();
}

class _d4_3State extends State<d4_3> {
  @override
  Widget build(BuildContext context) {
    final String x = 'centre urbaine';
    final String y = 'centre rural';
    final String z = 'international';
    final List<ChartData> chartData = <ChartData>[
      ChartData(x: x, yValue1: 22152),
      ChartData(x: y, yValue1: 16065),
      ChartData(x: z, yValue1: 20328),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("stats for 2021"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: SfCartesianChart(
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
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.yValue1,
                      name: 'Unit Sold',
                    ),
                    LineSeries<ChartData, String>(
                      animationDuration: 4500,
                      animationDelay: 2000,
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.yValue2,
                      yAxisName: 'yAxis1',
                      markerSettings: MarkerSettings(isVisible: true),
                      name: 'Total Transaction',
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
