import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/league_widget.dart';
import 'package:beachvolley_flutter/utils/JwtManager.dart';
import 'package:flutter/material.dart';
import 'package:beachvolley_flutter/models/Match.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MatchCard extends StatelessWidget {

  final Match match;
  final String currentUser;

  const MatchCard(this.currentUser, this.match, {super.key});

  static var jwtManager = JwtManager();
  final storage = const FlutterSecureStorage();


  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        elevation: 3,
        borderOnForeground: true,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      const SizedBox(width: 230), //make space between columns
                      Column(
                        // delete
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 23,
                                  color: Color(0xffd4d4d3)),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Match?', style: TextStyle(color: Colors.black87)),
                                      content: Container(
                                        height: 100,
                                        width: 150,
                                        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            var credentials = initJwtManager();
                                            deleteMatchByDate(context, credentials, match);
                                          },
                                          child: Text(
                                            'yes'.toUpperCase(),
                                            style: const TextStyle(fontSize: 16, color: Colors.white, )
                                          )
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            )
                          ]
                      )
                    ]
                  )
              ),
              Row(
                children: [
                  SizedBox(
                    width: 110,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: _createTeam("teamA")
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    height: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${match.score_a}-${match.score_b}", style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700,),)
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 110,
                    height: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: _createTeam("teamB")
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                child: Row(
                  children: [
                    Column(
                      // date
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.date_range, size: 23, color: Color(0xffd4d4d3)),
                              const Text("   "),
                              Text(
                                refactorDateToDisplay(match.date),
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffd4d4d3)
                                ),
                              )
                            ],
                          )
                        ]
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  /// Summary: establish which team we're creating
  /// and if the current player won the match
  List<Widget> _createTeam(String team) {
    List<Text> rows = [];
    int length = 0;
    List<String> teamPlayers = [];
    late bool currentUserWon;

    if (team == "teamA") {
      teamPlayers = match.team_a;
      if (teamPlayers.contains(currentUser)){
        if (match.score_a > match.score_b){
          currentUserWon = true;
        }
        else {
          currentUserWon = false;
        }
      }
    }
    else if (team == "teamB") {
      teamPlayers = match.team_b;
      if (teamPlayers.contains(currentUser)){
        if (match.score_b > match.score_a){
          currentUserWon = true;
        }
        else {
          currentUserWon = false;
        }
      }
    }

    length = teamPlayers.length;
    for (int i=0; i<length; i++){
      //make different color and font for current player for win and loss
      Color c = Colors.black87;
      double fontSize = 18;
      FontWeight fontWeight = FontWeight.w500;
      if (teamPlayers[i].toString() == currentUser){
        if (currentUserWon) {
          c = const Color(0xff0496ff);
          fontSize = 20;
          fontWeight = FontWeight.w700;
        }
        else {
          c = const Color(0xffefca08);
          fontSize = 20;
          fontWeight = FontWeight.w700;
        }

      }
      rows.add(Text(
        teamPlayers[i].toString(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: FontStyle.italic,
          color: c
        )
      ));
    }

    return rows;
  }

  /// Summary: Only players of the match can delete a match
  void deleteMatchByDate(BuildContext context, var credentials, Match match) async{

    String dbDate = refactorDateToStorage(match.date);
    String loggedUser = credentials[0];
    String jwt = credentials[1];

    // check if loggedUser played the match
    List<String> players = [];
    match.team_a.forEach((player) {
      players.add(player);
    });
    match.team_b.forEach((player) {
      players.add(player);
    });

    if (!players.contains(loggedUser)){
      Navigator.pop(context, true);
      return;
      /*return const SnackBar(
        content: Text("You can't delete a match you didn't play")
      );*/
    }

    final url = "${ApiEndpoints.baseUrl}${ApiEndpoints.deleteMatchEndpoint}?date=$dbDate";
    var result = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $jwt'
        }
    );
    if (result.statusCode == 200) {
      debugPrint("deleted match in date ${match.date}");
      Navigator.pop(context, true);
      //MUST REFRESH LEAGUE AND PLAYER PAGE AFTER A DELETION
    }

    /*return const SnackBar(
        content: Text("Dippi vanished the match as you wished")
    );*/
  }

  /// Summary: refactor date to adapt to query parameter search
  String refactorDateToStorage(String date){
    String dbDate = "${DateTime.parse(match.date).toIso8601String()}+00:00".replaceAll(":", "%3A").replaceAll("+", "%2B");
    return dbDate;
  }

  /// Summary: refactor date
  String refactorDateToDisplay(String date){
    DateTime datetime = DateTime.parse(match.date);
    String displayDate = "${datetime.day.toString()}/${datetime.month.toString()}/${datetime.year.toString()} ${datetime.hour.toString()}:${datetime.minute.toString()}";
    return displayDate;
  }

  List<String?> initJwtManager(){
    jwtManager.init();
    var jwt = jwtManager.jwt.toString();
    var loggedUser = jwtManager.name;
    var credentials = [loggedUser,jwt];
    return credentials;
  }

}