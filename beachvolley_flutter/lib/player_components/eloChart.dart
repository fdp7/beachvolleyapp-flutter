import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EloChart extends StatelessWidget {

  List<double> elo;
  EloChart(this.elo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: SfCartesianChart(
        title: ChartTitle(
          text: "ELO",
          textStyle: const TextStyle(
            color: Colors.black87, //Color(0xffd4d4d3),
            fontWeight: FontWeight.w700,
            fontSize: 18
          )
        ),
        margin: const EdgeInsets.all(20),
        plotAreaBorderWidth: 0,
        series: <ChartSeries>[
          LineSeries<EloData, double>(
            name: "elo trend",
            width: 5,
            dataSource: getEloData(elo),
            xValueMapper: (EloData eloData, _) => eloData.x,
            yValueMapper: (EloData eloData, _) => eloData.elo_i,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true
            ),
            color: const Color(0xff0496ff),
            animationDelay: 5
          ),
        ],
        primaryXAxis: NumericAxis(
          isVisible: false
        ),
        primaryYAxis: NumericAxis(
            isVisible: false
        ),
      ),
    );
  }
}

List<EloData> getEloData(List<dynamic> elo) {
  List<EloData> eloData = [];
  double i = 0.0;
  for (var elo_i in elo) {
    i++;
    eloData.add(EloData(i, elo_i));
  }
  return eloData;
}

class EloData {
  EloData(this.x, this.elo_i);
  final double x;
  final double elo_i;
}