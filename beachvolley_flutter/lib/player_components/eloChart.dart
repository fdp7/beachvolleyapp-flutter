import 'dart:math';

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
          text: "Elo",
          textStyle: const TextStyle(
            fontFamily: "Gaoel",
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 18
          )
        ),
        margin: const EdgeInsets.all(20),
        plotAreaBorderWidth: 0,
        series: <ChartSeries>[
          LineSeries<EloData, double>(
            name: "elo trend",
            width: 6,
            dataSource: getEloData(elo),
            xValueMapper: (EloData eloData, _) => eloData.x,
            yValueMapper: (EloData eloData, _) => eloData.elo_i,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true
            ),
            color: const Color(0xff0496ff),
            animationDelay: 5
          ),
          LineSeries<EloData, double>(
            name: "elo avg",
            isVisibleInLegend: true,
            width: 1,
            dashArray: <double>[5,5],
            dataSource: getEloDataAvg(elo),
            xValueMapper: (EloData eloData, _) => eloData.x,
            yValueMapper: (EloData eloData, _) => eloData.elo_i,
            color: const Color(0xffd81159),
            animationDelay: 5
          ),
        ],
        primaryXAxis: NumericAxis(
          isVisible: false
        ),
        primaryYAxis: NumericAxis(
          isVisible: false,
          minimum: getMinMaxYAxis(elo).min,
          maximum: getMinMaxYAxis(elo).max
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

List<EloData> getEloDataAvg(List<dynamic> elo){
  List<EloData> eloData = [];

  double eloAvg = elo.map((e) => e).reduce((a, b) => a + b) / elo.length;

  double i = 0.0;
  for (var elo_i in elo) {
    i++;
    eloData.add(EloData(i, eloAvg));
  }
  return eloData;
}

class EloData {
  EloData(this.x, this.elo_i);
  final double x;
  final double elo_i;
}

MinMaxYAxis getMinMaxYAxis(List<double> elo){
  double minElo = 100;
  double maxElo = 100;
  double offset = 10;

  for (var elo_i in elo){
    minElo = min(minElo, elo_i);
    maxElo = max(maxElo, elo_i);
  }

  double minAxis = minElo - offset;
  double maxAxis = maxElo + offset;

  return MinMaxYAxis(minAxis, maxAxis);
}

class MinMaxYAxis{
  MinMaxYAxis(this.min, this.max);
  final double min;
  final double max;
}