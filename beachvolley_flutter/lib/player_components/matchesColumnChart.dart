import 'package:flutter/material.dart';
import 'package:beachvolley_flutter/models/Match.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class MatchesColumnChart extends StatelessWidget {

  final String currentUser;
  final List<Match> matches;

  const MatchesColumnChart(this.currentUser, this.matches, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      ),
      child: SfSparkWinLossChart(
        data:  _createWinLossDataset(currentUser, matches),
        color: Colors.white,
        highPointColor: const Color(0xff04d9ff), // win
        negativePointColor: const Color(0xffEFca08), // loss
        tiePointColor: Colors.white, // added just to have lateral space
      )
    );
  }

  List<num> _createWinLossDataset(String currentUser, List<Match> matches) {
    // for selected user, for each match understand if it's win(1) or loss(-1) and append to array
    // add first and last value to have lateral (white) space

    List<num> dataset = [0];

    for (int match = 0; match < matches.length; match++){
      bool winner = _playerWinOrLoss(match);
      if (winner){
        dataset.add(1);
      }
      else{
        dataset.add(-1);
      }
    }

    dataset.add(0);

    return dataset;
  }

  bool _playerWinOrLoss(int i) {
    late bool currentUserWon;
    late String winnerTeam;

    //check winner team
    if (matches[i].score_a > matches[i].score_b){
      winnerTeam = "teamA";
    }
    else {
      winnerTeam = "teamB";
    }

    //check current user team belonging
    if (matches[i].team_a.contains(currentUser) && winnerTeam == "teamA") {
      currentUserWon = true;
    }
    else if(matches[i].team_b.contains(currentUser) && winnerTeam == "teamB") {
      currentUserWon = true;
    }
    else {
      currentUserWon = false;
    }

    return currentUserWon;
  }

}
