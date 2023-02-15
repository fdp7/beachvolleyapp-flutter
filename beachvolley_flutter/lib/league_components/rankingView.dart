import 'package:beachvolley_flutter/models/Player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankingView extends StatelessWidget {

  Widget? _data;

  RankingView(List<Player> playerList, bool rankingModePercentage, int? sortRankingColumnIndex, bool isRankingAscendingOrder, Function onTapCallback, {super.key}){
    final columns = ['Rank', 'Name', 'Matches', 'Win'];

    List<DataCell> getCells(List<dynamic> cells) =>
        cells.map((data) =>
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
      // order by rank
      if (columnIndex == 0) {
        playerList.sort((player1, player2) =>
            compareString(ascendingOrder, '${player1.rank}', '${player2.rank}')
        );
      }
      // order by name
      else if (columnIndex == 1) {
        playerList.sort((player1, player2) =>
            compareString(ascendingOrder, player1.name, player2.name)
        );
      }
      // order by matches
      else if (columnIndex == 2) {
        playerList.sort((player1, player2) =>
            compareInt(ascendingOrder, player1.match_count, player2.match_count)
        );
      }
      // order by win
      else if (columnIndex == 3) {
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
        ranking.map((Player player) {
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
                return Colors.white;
              }
              return Colors.grey.shade50;
            })
          );
        }).toList();

    _data = Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(
              vertical: 50,
              horizontal: 10
          ),
          child: DataTable(
            dataRowHeight: 50,
            columns: getColumns(columns),
            rows: getRows(playerList),
            sortColumnIndex: sortRankingColumnIndex,
            sortAscending: isRankingAscendingOrder,
            columnSpacing: 15,
            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade50),
            headingTextStyle: const TextStyle(
              color: Color(0xffd81159),
              fontSize: 15,
              fontWeight: FontWeight.w500
            ),
            dataTextStyle: const TextStyle(
              color: Colors.black87,
              fontSize: 15
            ),
            border: TableBorder(
              borderRadius: BorderRadius.circular(5)
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