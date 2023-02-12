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
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                  width: 270,
                  child: Row(
                    children: [
                      Column(
                        // date
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.date_range, size: 23, color: Color(0xff006ba6)),
                              const Text("   "),
                              Text(
                                match.date,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff006ba6)
                                ),
                              )
                            ],
                          )
                        ]
                      ),
                      const SizedBox(width: 30), //make space between columns
                      Column(
                        // delete
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  size: 23,
                                  color: Color(0xffd81159)),
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
                                            String token = initJwtManager();
                                            deleteMatchByDate(context, token, match.date);
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
              Container(
                margin: const EdgeInsets.all(5),
                child: Row(
                  children: [
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

              ),
              const SizedBox(height: 10),

            ],
          ),
        )
    );
  }

  List<Widget> _createTeam(String team) {
    List<Text> rows = [];
    int length = 0;
    List<String> teamPlayers = [];
    late bool currentUserWon;

    /// Summary: establish which team we're creating
    /// and if the current player won the match
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

    //check who won

    length = teamPlayers.length;
    for (int i=0; i<length; i++){
      //make different color and font for current player for win and loss
      Color c = Colors.black87;
      double fontSize = 18;
      FontWeight fontWeight = FontWeight.w500;
      if (teamPlayers[i].toString() == currentUser){
        if (currentUserWon) {
          c = const Color(0xff04d9ff);
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

  void deleteMatchByDate(BuildContext context, token, String date) async{

    String dbDate = refactorDate(date);

    Future.delayed(const Duration(milliseconds: 500)).then((_) async {
      final url = "${ApiEndpoints.baseUrl}${ApiEndpoints.deleteMatchEndpoint}?date=$dbDate";
      var result = await http.delete(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token'
          }
      );
      if (result.statusCode == 200) {
        debugPrint("deleted match in date $date");
        Navigator.pop(context, true);

        //MUST REFRESH LEAGUE AND PLAYER PAGE AFTER A DELETION
      }
    });
  }

  String refactorDate(String date){
    String dbDate = "${DateTime.parse(match.date).toIso8601String()}+00:00".replaceAll(":", "%3A").replaceAll("+", "%2B");
    return dbDate;
  }

  String initJwtManager(){
    jwtManager.init();
    return jwtManager.jwt.toString();
  }

}