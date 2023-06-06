import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class d6_list_ch extends StatefulWidget {
  const d6_list_ch({Key? key, required this.statsItem}) : super(key: key);
  final String statsItem;

  @override
  _d6_list_chState createState() => _d6_list_chState();
}

class _d6_list_chState extends State<d6_list_ch> {
  late CollectionReference<Map<String, dynamic>> _tabRef;
  late List<ChartData> _chartData;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tabRef = FirebaseFirestore.instance.collection('TAB6');
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
          width: 150,
          child: Transform.scale(
            scale: 1,
            child: Text(
              widget.statsItem.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _tabRef.where("categorie", isEqualTo: widget.statsItem).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _chartData.clear();
            for (final doc in snapshot.data!.docs) {
              final moyenne = doc['moyenne'];
              final annee = doc['annee'];
              final categorie = doc['categorie'];
              final pct = doc['pct'];
              _chartData.add(
                ChartData(
                    x: annee,
                    yValue1: moyenne,
                    yValue2: categorie,
                    yValue3: pct),
              );

              print('data add : $moyenne, $annee, $categorie');
            }
            print("data exesteted");
            return Column(
              children: [
                Expanded(
                  child: SfCircularChart(
                    title: ChartTitle(
                      text:
                          widget.statsItem + " Dépenses moyennes par habitant",
                    ),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      format: 'point.x  est  point.y' + ' Dinars',
                    ),
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: _chartData,
                        xValueMapper: (ChartData data, _) =>
                            data.x.toString(), // year
                        yValueMapper: (ChartData data, _) =>
                            data.yValue1, // valuer
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        animationDelay: 5,
                        enableTooltip: true,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SfCircularChart(
                    title: ChartTitle(
                      text: widget.statsItem + " Dépenses  (par pourcentage)",
                    ),
                    legend: Legend(isVisible: true),
                    tooltipBehavior: TooltipBehavior(
                      enable: true,
                      format: 'point.x  est  point.y' + ' %',
                    ),
                    series: <CircularSeries>[
                      DoughnutSeries<ChartData, String>(
                        dataSource: _chartData,
                        xValueMapper: (ChartData data, _) =>
                            data.x.toString(), // year
                        yValueMapper: (ChartData data, _) =>
                            data.yValue3, // valuer
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                        animationDelay: 5,
                        enableTooltip: true,
                      ),
                    ],
                  ),
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
  ChartData(
      {required this.x,
      required this.yValue1,
      required this.yValue2,
      required this.yValue3});
  final int x;
  final int yValue1;
  final String yValue2;
  final double yValue3;
}
