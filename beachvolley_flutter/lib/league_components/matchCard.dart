import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:beachvolley_flutter/models/Match.dart';

class MatchCard extends StatelessWidget {

  final Match match;

  const MatchCard(this.match, {super.key});

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
              Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.3), BlendMode.dstATop),
                        image: const AssetImage("images/beachvolleyfield1.jpg"), fit: BoxFit.cover)),
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
              SizedBox(
                  width: 265,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.date_range, size: 23, color: Colors.pink),
                        const Text("   "),
                        Text(match.date, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),)
                      ]
                  )
              ),
            ],
          ),
        )
    );
  }

  List<Widget> _createTeam(String team) {
    List<Text> rows = [];
    int length = 0;
    List<String> teamPlayers = [];

    if (team == "teamA") {
      teamPlayers = match.team_a;
    }
    else if (team == "teamB") {
      teamPlayers = match.team_b;
    }

    length = teamPlayers.length;

    for (int i=0; i<length; i++){
      rows.add(Text(teamPlayers[i].toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic)));
    }

    return rows;
  }
}
