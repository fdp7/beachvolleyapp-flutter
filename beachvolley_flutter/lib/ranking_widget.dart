import 'package:flutter/material.dart';

class Ranking extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {

  @override
  Widget build(BuildContext context) {
    return
      DataTable(
        columns: [
          DataColumn(label: Text('Rank')),
          DataColumn(label: Text('Name')),
          DataColumn(
              label: Text('Win'),
              numeric: true,
          ),
        ],
        rows:[
          DataRow(cells: [
            DataCell(Icon(
                Icons.wine_bar,
                color: Colors.deepPurpleAccent,
            )),
            DataCell(Text('fede')),
            DataCell(Text('30')),
          ]),
          DataRow(cells: [
            DataCell(Text('2')),
            DataCell(Text('matte')),
            DataCell(Text('40')),
          ]),
          DataRow(cells: [
            DataCell(Text('3')),
            DataCell(Text('ma')),
            DataCell(Text('70')),
          ]),
          DataRow(cells: [
            DataCell(Text('4')),
            DataCell(Text('pa')),
            DataCell(Text('50')),
          ]),
        ]
    );
  }
}