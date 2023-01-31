import 'dart:convert';
import 'package:beachvolley_flutter/controllers/api_endpoints.dart';
import 'package:beachvolley_flutter/utils/JwtManager.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;

class AddMatch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddMatchState();
}

class _AddMatchState extends State<AddMatch> {

  static var jwtManager = JwtManager();

  bool isButtonDisabled = false;

  List<String> playerList = [];
  List<String> teamA = [];
  List<String> teamB = [];
  int _scoreA = 0;
  int _scoreB = 0;


  @override
  void initState(){
    jwtManager.init();
    loadPlayersList();
    super.initState();
  }

  // get ranking and sort names in alphabetical order
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
            playerList.add(data["ranking"][i]["name"]);
          });
        }
        playerList.sort();
        debugPrint(playerList.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Material(
      type: MaterialType.transparency,
      child:  Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.pregnant_woman_rounded, color: Colors.black87),
                            Text("  Team A", style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w500),)
                          ],
                        ),
                        const SizedBox(height: 1,),
                        MultiSelectDialogField(
                          title: const Text("Team A players"),
                          buttonIcon: const Icon(Icons.person_add),
                          buttonText: const Text("select"),
                          searchable: true,
                          items: playerList.map((e) => MultiSelectItem(e, e)).toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            teamA = values;
                          },
                        ),
                        const SizedBox(height: 1,),
                        NumberPicker(
                          value: _scoreA,
                          selectedTextStyle: TextStyle(color: Colors.tealAccent.shade700, fontSize: 50, fontWeight: FontWeight.w400),
                          minValue: 0,
                          maxValue: 40,
                          itemHeight: 120,
                          itemWidth: 80,
                          onChanged: (num) {
                            setState(() {
                              _scoreA = num;
                            });
                          },
                          axis: Axis.horizontal,
                        ),
                        const SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.precision_manufacturing_sharp, color: Colors.black87),
                            Text("  Team B", style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.w500),)
                          ],
                        ),
                        const SizedBox(height: 1,),
                        MultiSelectDialogField(
                          title: const Text("Team B players"),
                          buttonIcon: const Icon(Icons.person_add),
                          buttonText: const Text("select"),
                          searchable: true,
                          items: playerList.map((e) => MultiSelectItem(e, e)).toList(),
                          listType: MultiSelectListType.CHIP,
                          onConfirm: (values) {
                            teamB = values;
                          },
                        ),
                        const SizedBox(height: 1,),
                        NumberPicker(
                          value: _scoreB,
                          selectedTextStyle: TextStyle(color: Colors.tealAccent.shade700, fontSize: 50, fontWeight: FontWeight.w400),
                          minValue: 0,
                          maxValue: 40,
                          itemHeight: 120,
                          itemWidth: 80,
                          onChanged: (num) {
                            setState(() {
                              _scoreB = num;
                            });
                          },
                          axis: Axis.horizontal,
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: isButtonDisabled ? null : () { saveMatch(); },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      )
                  ),
                  child: Text('Save Match'.toUpperCase(), style: const TextStyle(fontSize: 20, color: Colors.white)),
                ),
              )
            )
          ],
        )
      ),
    );
  }

  /// Summary: teams must be notEmpty and players can't be on both teams.
  /// Returns: 0-->valid, 1-->empty, 2-->duplicate
  int validateTeams(List<String> teamA, List<String> teamB){
    int areValid = 0;
    if (teamA.isEmpty || teamB.isEmpty) {
      areValid = 1;
    } else if (teamA.isNotEmpty && teamB.isNotEmpty) {
      teamA.forEach((a) {
        teamB.forEach((b) {
          if (a == b) {
            areValid = 2;
          }
        });
      });
    }
    return areValid;
  }

  /// Summary: draw match is not allowed
  /// Returns bool
  bool validateScores(scoreA, scoreB){
    bool areValid = true;
    if (scoreA == scoreB) {
      areValid = false;
    }
    return areValid;
  }

  Future<String?> saveMatch() async {
    setState(() {
      isButtonDisabled = true;
    });

    // if no player is in both teams, save match, else print error
    int validTeams = validateTeams(teamA,teamB);
    bool validScores = validateScores(_scoreA, _scoreB);
    if (validTeams == 0 && validScores) {
      final url = ApiEndpoints.baseUrl + ApiEndpoints.addMatchEndpoint;
      final currentDate = getDate();

      var result = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "team_a": teamA,
          "team_b": teamB,
          "score_a": _scoreA,
          "score_b": _scoreB,
          "date": currentDate
        }),
        headers: {
          'Authorization': 'Bearer ${jwtManager.jwt.toString()}'
        },
      );
      if (result.statusCode == 201) {
        Navigator.pop(context);
        debugPrint(teamA.toString());
        debugPrint(teamB.toString());
        debugPrint(_scoreA.toString());
        debugPrint(_scoreB.toString());
        debugPrint(currentDate.toString());
        return "Match successfully saved by the Good God Dippi";
      }
      else {
        setState(() {
          isButtonDisabled = false;
        });
        debugPrint("An unexpected error occurred! Please report to the Good God Dippi");
        return "An unexpected error occurred!\n Please report to the Good God Dippi";
      }
    } else if (validTeams == 1) {
      setState(() {
        isButtonDisabled = false;
      });
      debugPrint("In the beginning the Good God Dippi was alone... but I guess you were not. Please check players");
      return "In the beginning the Good God Dippi was alone...\n but I guess you were not\n Please check players";
    } else if (validTeams == 2) {
      setState(() {
        isButtonDisabled = false;
      });
      debugPrint("A player can't be ubiquitous as the Good God Dippi! Please check players");
      return "A player can't be ubiquitous as the Good God Dippi!\n Please check players";
    } else if (!validScores) {
      setState(() {
        isButtonDisabled = false;
      });
      debugPrint("Only the Good God Dippi can establish a draw... YOU CANNOT. Please check scores");
      return "Only the Good God Dippi can establish a draw...\nYOU CANNOT\n Please check scores";
    }
  }

  String getDate(){
    String current = DateTime.now().toString();
    current = current.replaceFirst(" ", "T").replaceRange(20, current.length, "000+00:00");
    return current;
  }
}


