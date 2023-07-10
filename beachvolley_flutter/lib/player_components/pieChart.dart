import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class MyPieChart extends StatelessWidget {

  final int _wins;
  final int _total;

  const MyPieChart(this._wins, this._total, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: PieChart(
        dataMap: {
          "Win": _wins.toDouble(),
          "Loss": _total.toDouble() - _wins.toDouble()
        },
        animationDuration: const Duration(seconds: 1),
        chartLegendSpacing: 50,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: [Colors.greenAccent.withAlpha(250), Colors.redAccent], //const [Color(0xff0496ff), Color(0xffEFca08)],
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 60,
        centerText: _total == 0 ? "" : "${(_wins/_total*100).floor()}%",
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          decimalPlaces: 0,
          chartValueStyle: TextStyle(fontSize:20, color: Colors.black87, fontWeight: FontWeight.w700),
          showChartValuesInPercentage: false,
          showChartValuesOutside: true,
        ),
      ),
    );
  }

}
