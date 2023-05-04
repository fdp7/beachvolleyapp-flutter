import 'package:beachvolley_flutter/models/Player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RankingView extends StatelessWidget {

  Widget? _data;

  /*RankingView(List<Player> playerList, bool rankingModePercentage, int? sortRankingColumnIndex, bool isRankingAscendingOrder, Function onTapCallback, {super.key}){
    final columns = ['', 'Name', 'P', 'W', 'Elo'];

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
            player.win_count,
            player.last_elo
          ];
          return DataRow(
            cells: getCells(cells),
            color: MaterialStateProperty.resolveWith((_) {
              if (player.rank == 1) {
                return const Color(0xffffd700).withOpacity(0.6);//Colors.yellow.shade600;
              }
              else if (player.rank == 2){
                return Colors.grey.shade300.withOpacity(0.8);
              }
              else if (player.rank == 3){
                return const Color(0xffd7995b).withOpacity(0.7);//Colors.orange.shade200;
              }
              else {
                return Colors.grey.shade50;
              }
            })
          );
        }).toList();

    _data =
        Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 30,
                    top: 50
                  ),
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                    SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Ranking\n",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(
                  left: 10,
                  bottom: 40
                ),
                child: DataTable(
                  dataRowHeight: 50,
                  showBottomBorder: false,
                  columns: getColumns(columns),
                  rows: getRows(playerList),
                  sortColumnIndex: sortRankingColumnIndex,
                  sortAscending: isRankingAscendingOrder,
                  columnSpacing: 15,
                  headingRowColor: MaterialStateColor.resolveWith((_) =>
                    Colors.white //Color(0xffebebea)
                  ),
                  headingTextStyle: const TextStyle(
                    fontFamily: 'Gaoel',
                    color: Color(0xffd81159),
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  ),
                  dataTextStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 17
                  ),
                  border: TableBorder.all(
                    color: const Color(0xffebebea),
                    borderRadius: BorderRadius.circular(20),
                    style: BorderStyle.none
                  ),
                )
              ),
            ),
          ],
        );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: _data
    );
  }*/

  RankingView(List<Player> playerList, {super.key}){

    Color goldColor = const Color(0xffffd700).withOpacity(0.6);
    Color silverColor = const Color(0xffd5d5d7).withOpacity(0.6); //Colors.grey.shade300.withOpacity(0.8);
    Color bronzeColor = const Color(0xffd7995b).withOpacity(0.6);
    DataCell iconForRanking(Player player){
      if (player.rank == 1){
        return const DataCell(FaIcon(FontAwesomeIcons.crown, color: Color(0xffd81159)),);
      }
      else if (player.rank == 2){
        return DataCell(FaIcon(FontAwesomeIcons.medal, color: silverColor.withAlpha(250)),);
      }
      else if (player.rank == 3){
        return DataCell(FaIcon(FontAwesomeIcons.medal, color: bronzeColor,));
      }
      else {
        return const DataCell(Icon(Icons.accessibility_sharp, color: Colors.white,));
      }
    }
    
    _data = GestureDetector(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            numeric: true,
            label: FaIcon(
              FontAwesomeIcons.crown,
              color: Colors.white,
            ),
          ),
          DataColumn(
            label: Text('Name')
          ),
          DataColumn(
            label: Text('P')
          ),
          DataColumn(
              label: Text('W')
          ),
          DataColumn(
              label: Text('Elo')
          )
        ],
        rows: playerList.map<DataRow>((p) => DataRow(
          cells: <DataCell>[
            iconForRanking(p),
            DataCell(Text(p.name)),
            DataCell(Text('${p.match_count}')),
            DataCell(Text('${p.win_count}')),
            DataCell(Text('${p.last_elo}'))
          ],
          color: MaterialStateProperty.resolveWith((_) {
            if (p.rank == 1){
              return goldColor;
            }
            else if (p.rank == 2){
              return silverColor;
            }
            else if (p.rank == 3){
              return bronzeColor;
            }
            else {
              return Colors.transparent;
            }
          })
        )).toList(),
        dataRowHeight: 50,
        showBottomBorder: false,
        columnSpacing: 15,
        headingTextStyle: const TextStyle(
            fontFamily: 'Gaoel',
            color: Color(0xffd81159),
            fontSize: 17,
            fontWeight: FontWeight.w500
        ),
        dataTextStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 17
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 20,),
                  Text(
                    "Ranking",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'Gaoel'),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
            //margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: _data
        ),
        const SizedBox(height: 40,)
      ],
    );
  }

}