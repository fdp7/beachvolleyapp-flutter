import 'package:beachvolley_flutter/models/Player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankingView extends StatelessWidget {

  Widget? _data;

  RankingView(List<Player> playerList, bool rankingModePercentage, int? sortRankingColumnIndex, bool isRankingAscendingOrder, Function onTapCallback, {super.key}){
    final columns = ['Rank', 'Name', 'Matches', 'Win'];

    List<DataCell> getCells(List<dynamic> cells) =>
        cells
            .map((data) =>
            DataCell(
              Text(
                  '$data',
                  textAlign: TextAlign.center
              ),

            )).toList();

    int compareString(bool ascendingOrder, String value1, String value2) =>
        ascendingOrder ? value1.compareTo(value2) : value2.compareTo(value1);

    int compareInt(bool ascendingOrder, int value1, int value2) =>
        ascendingOrder ? value1.compareTo(value2) : value2.compareTo(value1);

    void _onSort(int columnIndex, bool ascendingOrder) {
      if (columnIndex == 0) {
        playerList.sort((player1, player2) =>
            compareString(ascendingOrder, '${player1.rank}', '${player2.rank}')
        );
      } else if (columnIndex == 1) {
        playerList.sort((player1, player2) =>
            compareString(ascendingOrder, player1.name, player2.name)
        );
      } else if (columnIndex == 2) {
        playerList.sort((player1, player2) =>
            compareInt(ascendingOrder, player1.match_count, player2.match_count)
        );
      } else if (columnIndex == 3) {
        playerList.sort((player1, player2) =>
            compareInt(ascendingOrder, player1.win_count, player2.win_count)
        );
      }
      sortRankingColumnIndex = columnIndex;
      isRankingAscendingOrder = ascendingOrder;
    }

    List<DataColumn> getColumns(List<String> columns) =>
        columns
            .map((String column) =>
            DataColumn(
              label: Text(
                column,
                textAlign: TextAlign.center,
              ),
              onSort: _onSort,
            )).toList();

    List<DataRow> getRows(List<Player> ranking) =>
        ranking
            .map((Player player) {
          final cells = [
            player.rank,
            player.name,
            player.match_count,
            player.win_count
          ];
          return DataRow(
            cells: getCells(cells),
            color: MaterialStateProperty.resolveWith((_) {
              if (player.rank.isOdd) {
                return Colors.grey.shade100;
              }
              return Colors.grey.shade200;
            }),

          );
        }).toList();

    _data = Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 10
          ),
          child: DataTable(
            columns: getColumns(columns),
            rows: getRows(playerList),
            sortColumnIndex: sortRankingColumnIndex,
            sortAscending: isRankingAscendingOrder,
            columnSpacing: 15,
            headingTextStyle: const TextStyle(
              color: Colors.pinkAccent,
              fontSize: 15,
            ),
            dataTextStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 15
            ),
            border: TableBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: _data
    );
  }

}