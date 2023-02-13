import 'dart:convert';

import 'package:beachvolley_flutter/league_components/lastMatches.dart';
import 'package:beachvolley_flutter/player_components/pieChart.dart';
import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/login_widget.dart';
import 'package:beachvolley_flutter/utils/JwtManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:beachvolley_flutter/models/Match.dart';
import 'package:beachvolley_flutter/player_components/matchesColumnChart.dart';

class PlayerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  var jwtManager = JwtManager();
  final RefreshController _refreshController = RefreshController(initialRefresh: true);

  String currentUser = 'Player';
  List<String> playerList = [];
  int matchCount = 100;
  int winCount = 50;

  List<Match> matches = [];
  List<String> teamA = [];
  List<String> teamB = [];
  String date = "";

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 1000));
    loadPlayerData(currentUser);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    _refreshController.loadComplete();
  }

  void loadPlayersList() async {
    Future.delayed(const Duration(milliseconds: 500)).then((_) async {
      final url = ApiEndpoints.baseUrl + ApiEndpoints.getRankingEndpoint;
      var result = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${jwtManager.jwt.toString()}'
          }
      );
      var data = json.decode(result.body);
      if (result.statusCode == 200) {
        playerList.clear();
        for (var i = 0; i < data["ranking"].length; i++) {
          setState(() {
            playerList.add(
                    data["ranking"][i]["name"]
            );
          });
        }
        playerList.sort();
        debugPrint(playerList.toString());
      }
    });
  }

  void loadPlayerData(String player) async {
    loadMatches();
    Future.delayed(const Duration(milliseconds: 500)).then((_) async {
      final url = ApiEndpoints.baseUrl + ApiEndpoints.getPlayerEndpoint + player;
      var result = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${jwtManager.jwt.toString()}',
          }
      );
      var data = json.decode(result.body);
      if (result.statusCode == 200) {
        matchCount = data["player"]["match_count"];
        winCount = data["player"]["win_count"];
        debugPrint("$matchCount $winCount");
        //set new data to widget
        setState(() {
          winPie();
        });
      }
    });
  }

  Widget picker(){
    if (playerList.isEmpty){
      loadPlayersList();
    }
    return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            backgroundBlendMode: BlendMode.colorBurn
          ),
          child: ListTile(
              leading: const Icon(Icons.sports_handball_outlined, size: 50, color: Color(0xffd81159)), //pink:0xffd81159, blue:0xffd81159
              title: Text(currentUser, style: const TextStyle(fontSize: 20, color: Color(0xffd81159)),),
              subtitle: const Text("click to change player", style: TextStyle(color: Color(0xffd81159))),
              trailing: const Icon(Icons.arrow_drop_down_circle_outlined, color: Color(0xffd81159)),
              onLongPress: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return alert dialog object
                  return AlertDialog(
                      title: const Text('Log Out?', style: TextStyle(color: Colors.black87),),
                      content: Container(
                        height: 100.0, // Change as per your requirement
                        width: 300.0, // Change
                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                                  (Route<dynamic> route) => false,
                            );
                          },
                          child: Text('Exit'.toUpperCase(), style: const TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      )
                  );
                },
              ),
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return alert dialog object
                  return AlertDialog(
                      title: const Text('Select a player', style: TextStyle(color: Color(0xffd81159))),
                      content: SizedBox(
                          height: 300.0, // Change as per your requirement
                          width: 300.0, // Change as per your requirement
                          child: Scrollbar(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: playerList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    title: Text(playerList[index]),
                                    onTap: () {
                                      setState(() {
                                        currentUser = playerList[index];
                                        loadPlayerData(currentUser);
                                        Navigator.pop(context);
                                      });
                                    }
                                );
                              },
                            ),
                          )
                      )
                  );
                },
              )
          ),
        )
    );
  }

  Widget winPie() {
    return SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 30,),
                  Text(
                    "Career Data",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            MyPieChart(winCount.toInt(), matchCount.toInt()),
          ],
        )
    );
  }

  Widget matchesColumnChart() => SliverToBoxAdapter(
    child: MatchesColumnChart(currentUser, matches)
  );

  Widget lastMatches() => SliverToBoxAdapter(
    child: LastMatches(currentUser, matches),
  );

  void loadMatches() async{
    Future.delayed(const Duration(milliseconds: 500)).then((_) async {
      final url = "${ApiEndpoints.baseUrl}${ApiEndpoints.getMatchesEndpoint}?player=$currentUser";
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
          //date = DateTime.parse(data["matches"][i]["date"]).toLocal().toString();
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

  String refactorDate(dynamic date){
    String parsedDate = DateTime.parse(date).toIso8601String().replaceAll("T", " ").replaceAll("Z", "");
    String newDate = parsedDate.replaceRange(19, parsedDate.length, "");
    return newDate;
  }

  @override
  void initState() {
    jwtManager.init();
    loadPlayersList();
    loadMatches();
    super.initState();

    var storage = const FlutterSecureStorage();

    Future.delayed(const Duration(milliseconds: 500)).then((_) async {
      await storage.read(key: "name").then((value) => {
        setState(() {
          currentUser = value!;
          loadPlayerData(currentUser);
        })
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      enablePullDown: true,
      enablePullUp: false,
      header: const WaterDropMaterialHeader(color: Colors.white ,backgroundColor: Color(0xffd91159)),
      child: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
          picker(),
          winPie(),
          matchesColumnChart(),
          lastMatches(),
          //otherPlayers(),
          const SliverToBoxAdapter(child: SizedBox(height: 100))
        ],
      ),
    );
  }





}
