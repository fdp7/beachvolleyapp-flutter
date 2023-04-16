import 'dart:convert';

import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/league_components/lastMatches.dart';
import 'package:beachvolley_flutter/league_components/rankingView.dart';
import 'package:beachvolley_flutter/models/Match.dart';
import 'package:beachvolley_flutter/models/Player.dart';
import 'package:beachvolley_flutter/utils/JwtManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:beachvolley_flutter/utils/globals.dart' as globals;

class League extends StatefulWidget {
  const League({super.key});

  @override
  State<StatefulWidget> createState() => _LeagueState();
}

class _LeagueState extends State<League> {

  static var jwtManager = JwtManager();
  var storage = const FlutterSecureStorage();

  List<Player> playerList = [];
  bool rankingModePercentage = false;
  int? sortRankingColumnIndex;
  bool isRankingAscendingOrder = false;

  List<Match> matches = [];
  List<String> teamA = [];
  List<String> teamB = [];
  String date = "";
  String currentUser = "";
  List<double> elo = [100.0];

  final RefreshController _refreshController = RefreshController(initialRefresh: true);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      enablePullDown: true,
      enablePullUp: false,
      header: const WaterDropMaterialHeader(
          color: Colors.white, backgroundColor: Color(0xffd81159)),
      child: CustomScrollView(
        slivers: <Widget>[
          ranking(),
          lastMatches(),
          const SliverToBoxAdapter(child: SizedBox(height: 100))
        ],
      ),
    );
  }

  @override
  void initState() {
    jwtManager.init();
    loadRanking();
    loadMatches();
    super.initState();
  }

  Widget ranking() =>
      SliverToBoxAdapter(
        child: RankingView(playerList, rankingModePercentage, sortRankingColumnIndex, isRankingAscendingOrder, () {
          setState(() {
            rankingModePercentage = !rankingModePercentage;
          });
        }),
      );

  Widget lastMatches() => SliverToBoxAdapter(
    child: LastMatches(currentUser, matches),
  );

  // get ranking
  void loadRanking() async {
    Future.delayed(const Duration(milliseconds: 500)).then((_) async {
      final url = ApiEndpoints.baseUrl + globals.selectedSport + ApiEndpoints.getRankingEndpoint;
      var result = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${jwtManager.jwt.toString()}'
          }
      );
      var data = json.decode(result.body);
      if (result.statusCode == 200) {
        playerList.clear();
        elo.clear();
        for (var i = 0; i < data["ranking"].length; i++) {
          elo = createElo(data["ranking"][i]["elo"]);
          setState(() {
            playerList.add(
                Player(
                  data["ranking"][i]["name"],
                  data["ranking"][i]["match_count"],
                  data["ranking"][i]["win_count"],
                  elo,
                  num.parse(data["ranking"][i]["last_elo"].toStringAsFixed(1)).toDouble(), //1 decimal
                  i + 1, // rank
                )
            );
          });
        }
      }
    });
  }
  
  void loadMatches() async{
    Future.delayed(const Duration(milliseconds: 500)).then((_) async {
      final url = ApiEndpoints.baseUrl + globals.selectedSport + ApiEndpoints.getMatchesEndpoint;
      var result = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${jwtManager.jwt.toString()}'
          }
      );
      var data = json.decode(result.body);
      if (result.statusCode == 200) {
        matches.clear();

        for (var i = 0; i < data["matches"].length; i++) {
          // make Date
          date = refactorDate(data["matches"][i]["date"]);
          // make Teams
          teamA = createTeam(data["matches"][i]["team_a"]);
          teamB = createTeam(data["matches"][i]["team_b"]);
          // make Matches
          setState(() {
            matches.add(
                Match(
                  date,
                  teamA,
                  teamB,
                  data["matches"][i]["score_a"],
                  data["matches"][i]["score_b"],
                )
            );
            debugPrint("$date $teamA $teamB");
          });
        }
      }
    });
  }

  List<String> createTeam(dynamic matchData){
    List<String> teamPlayers = [];
    for (var j = 0; j < matchData.length; j++) {
      teamPlayers.add(matchData[j]);
    }
    return teamPlayers;
  }

  List<double> createElo(List<dynamic> eloData){
    List<double> eloResult = [];
    for (var j = 0; j < eloData.length; j++){
      double elo_i = num.parse(eloData[j].toStringAsFixed(1)).toDouble(); //1 decimal
      eloResult.add(elo_i);
    }
    return eloResult;
  }

  String refactorDate(dynamic date){
    String parsedDate = DateTime.parse(date).toIso8601String().replaceAll("T", " ").replaceAll("Z", "");
    String newDate = parsedDate.replaceRange(19, parsedDate.length, "");
    return newDate;
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    loadRanking();
    loadMatches();
    _refreshController.refreshCompleted();
  }

}